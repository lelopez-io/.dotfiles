-- Markdown preview mode: render-markdown.nvim + mermaid diagrams via image.nvim
--
-- Mermaid Image Lifecycle:
--   1. Images render inline below ```mermaid blocks using image.nvim + Kitty protocol
--   2. Cached in /tmp as mermaid_{hash}.png (re-renders only when content changes)
--   3. External clear (tmux session browser, etc):
--      - tmux calls `mermaid_clear` zsh function before showing overlays
--      - mermaid_clear() clears images and sets render_blocked=true
--   4. Redraw triggers: FocusGained, WinScrolled, CursorMoved, BufEnter
--   5. VimResized (tmux splits): clears images, re-renders on next scroll/interaction
--   6. Harpoon navigation: triggers BufWinEnter for render-markdown.nvim refresh
--
-- External API (for tmux/scripts via nvim --remote-expr):
--   mermaid_clear()  - Clear images and block re-rendering
--   mermaid_redraw() - Unblock and redraw images
--   mermaid_debug()  - Print state for debugging

local DEBOUNCE_MS = 300
local CACHE_DIR = "/tmp"
local MMDC_PATH = "/opt/homebrew/bin/mmdc"
-- Update after `brew upgrade ungoogled-chromium`: ls /opt/homebrew/Caskroom/ungoogled-chromium/
local CHROMIUM_PATH = "/opt/homebrew/Caskroom/ungoogled-chromium/147.0.7727.116-1.1/Chromium.app/Contents/MacOS/Chromium"

local preview_enabled = false
local preview_focused = true
local file_watcher = nil
local mermaid_images = {}
local debounce_timer = nil
local pending_renders = {}
local needs_redraw = false
local last_tmux_session = nil
local render_blocked = false

local function get_tmux_session()
    if not vim.env.TMUX then return nil end
    local handle = io.popen("tmux display-message -p '#{session_id}'")
    if not handle then return nil end
    local session = handle:read("*l")
    handle:close()
    return session
end

-- Heading icons have numbers that blur when bold
local function remove_heading_bold()
    for i = 1, 6 do
        local hl = vim.api.nvim_get_hl(0, { name = "RenderMarkdownH" .. i, link = false })
        if hl.fg then
            hl.bold = false
            vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i, hl)
        end
    end
end

-- Normalize mermaid: \n -> <br/>, quote labels with / to avoid shape parsing
local function normalize_mermaid(content)
    content = content:gsub("%[([^%]\"]+)%]", function(label)
        local needs_quotes = false
        local new_label = label

        -- Convert \n to <br/>
        if label:find("\\n") then
            new_label = new_label:gsub("\\n", "<br/>")
            needs_quotes = true
        end

        -- Quote if contains / (path-like) to avoid shape interpretation
        if label:find("/") then
            needs_quotes = true
        end

        if needs_quotes then
            return '["' .. new_label .. '"]'
        end
        return "[" .. new_label .. "]"
    end)
    return content
end

local function hash_content(content)
    return vim.fn.sha256(normalize_mermaid(content)):sub(1, 16)
end

local function find_mermaid_blocks()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local blocks = {}
    local in_mermaid = false
    local start_line = nil
    local content_lines = {}

    for i, line in ipairs(lines) do
        if line:match("^```mermaid") then
            in_mermaid = true
            start_line = i
            content_lines = {}
        elseif line:match("^```") and in_mermaid then
            in_mermaid = false
            local content = table.concat(content_lines, "\n")
            local hash = hash_content(content)
            table.insert(blocks, {
                start_line = start_line,
                end_line = i,
                content = content,
                hash = hash,
            })
        elseif in_mermaid then
            table.insert(content_lines, line)
        end
    end

    return blocks
end

local function is_cached(hash)
    local png_path = string.format("%s/mermaid_%s.png", CACHE_DIR, hash)
    return vim.fn.filereadable(png_path) == 1
end

local function render_mermaid_async(content, hash, callback)
    local png_path = string.format("%s/mermaid_%s.png", CACHE_DIR, hash)

    if is_cached(hash) then
        callback(png_path)
        return
    end

    if pending_renders[hash] then
        return
    end

    local mmd_path = string.format("%s/mermaid_%s.mmd", CACHE_DIR, hash)
    local f = io.open(mmd_path, "w")
    if not f then
        vim.notify("Failed to write mmd file", vim.log.levels.ERROR)
        callback(nil)
        return
    end
    f:write(normalize_mermaid(content))
    f:close()

    pending_renders[hash] = true

    local log_path = string.format("%s/mermaid_%s.log", CACHE_DIR, hash)

    vim.fn.jobstart({
        MMDC_PATH, "-i", mmd_path, "-o", png_path, "-b", "transparent", "-t", "dark", "-s", "3", "-w", "800", "-H", "3000"
    }, {
        env = { PUPPETEER_EXECUTABLE_PATH = CHROMIUM_PATH },
        stdout_buffered = true,
        stderr_buffered = true,
        on_stdout = function(_, data)
            if data and #data > 0 then
                local f = io.open(log_path, "a")
                if f then f:write(table.concat(data, "\n")); f:close() end
            end
        end,
        on_stderr = function(_, data)
            if data and #data > 0 then
                local f = io.open(log_path, "a")
                if f then f:write(table.concat(data, "\n")); f:close() end
            end
        end,
        on_exit = function(_, exit_code)
            pending_renders[hash] = nil

            if exit_code == 0 and vim.fn.filereadable(png_path) == 1 then
                os.remove(mmd_path)
                os.remove(log_path)
                vim.schedule(function()
                    callback(png_path)
                end)
            else
                vim.schedule(function()
                    vim.notify("Mermaid render failed for " .. hash .. " (see " .. log_path .. ")", vim.log.levels.WARN)
                    callback(nil)
                end)
            end
        end,
    })
end

-- Send Kitty graphics delete command to terminal
local function clear_kitty_graphics()
    local kitty_delete = "\x1b_Ga=d,d=A\x1b\\"
    if vim.env.TMUX then
        kitty_delete = "\x1bPtmux;" .. kitty_delete:gsub("\x1b", "\x1b\x1b") .. "\x1b\\"
    end
    io.stdout:write(kitty_delete)
    io.stdout:flush()
end

-- Full clear: remove from image.nvim tracking and clear Kitty graphics
local function clear_mermaid_images()
    local ok, image_api = pcall(require, "image")
    if not ok then return end

    for _, img in ipairs(mermaid_images) do
        pcall(function() img:clear(true) end)
    end
    mermaid_images = {}

    pcall(function() image_api.clear() end)
    clear_kitty_graphics()
end

-- Global functions for tmux to call via nvim --remote-expr
_G.mermaid_clear = function()
    render_blocked = true
    clear_mermaid_images()
end

_G.mermaid_redraw = function()
    render_blocked = false
    if preview_enabled then
        display_mermaid_images()
    end
end

_G.mermaid_debug = function()
    vim.notify(string.format("preview_enabled=%s render_blocked=%s images=%d",
        tostring(preview_enabled), tostring(render_blocked), #mermaid_images), vim.log.levels.INFO)
end

local function display_single_image(png_path, end_line, bufnr, winid)
    local ok, image_api = pcall(require, "image")
    if not ok then return end

    -- Calculate max height to prevent overflow into other panes
    local win_height = vim.api.nvim_win_get_height(winid)
    local win_info = vim.fn.getwininfo(winid)[1]
    local topline = win_info and win_info.topline or 1
    local lines_from_top = end_line - topline + 1
    local available_lines = win_height - lines_from_top
    local max_height = math.max(5, available_lines - 1)  -- Leave 1 line buffer, min 5 lines

    local ok_img, img = pcall(image_api.from_file, png_path, {
        buffer = bufnr,
        window = winid,
        with_virtual_padding = true,
        inline = true,
        x = 0,
        y = end_line,
        max_height = max_height,
    })

    if ok_img and img then
        pcall(function() img:render() end)
        table.insert(mermaid_images, img)
    end
end

local function display_mermaid_images()
    if not preview_enabled or render_blocked then return end

    local ok, _ = pcall(require, "image")
    if not ok then return end

    clear_mermaid_images()

    local blocks = find_mermaid_blocks()
    if #blocks == 0 then return end

    local bufnr = vim.api.nvim_get_current_buf()
    local winid = vim.api.nvim_get_current_win()

    for _, block in ipairs(blocks) do
        local end_line = block.end_line - 1  -- Convert to 0-indexed for image.nvim
        render_mermaid_async(block.content, block.hash, function(png_path)
            if png_path and preview_enabled then
                display_single_image(png_path, end_line, bufnr, winid)
            end
        end)
    end
end

local function display_mermaid_debounced()
    if debounce_timer then
        debounce_timer:stop()
    end
    debounce_timer = vim.defer_fn(function()
        debounce_timer = nil
        display_mermaid_images()
    end, DEBOUNCE_MS)
end

local function start_file_watcher()
    if file_watcher then return end

    local filepath = vim.api.nvim_buf_get_name(0)
    if filepath == "" then return end

    file_watcher = vim.uv.new_fs_event()
    file_watcher:start(filepath, {}, vim.schedule_wrap(function(err, _, events)
        if err then return end
        if events.change and preview_enabled then
            vim.cmd("checktime")
            if preview_focused then
                display_mermaid_debounced()
            else
                needs_redraw = true
            end
        end
    end))
end

local function stop_file_watcher()
    if file_watcher then
        file_watcher:stop()
        file_watcher = nil
    end
end

local preview_augroup = vim.api.nvim_create_augroup("MarkdownPreview", { clear = true })

local function enable_preview()
    preview_enabled = true
    last_tmux_session = get_tmux_session()
    vim.cmd("RenderMarkdown enable")
    vim.defer_fn(remove_heading_bold, 200)
    start_file_watcher()
    display_mermaid_debounced()

    vim.api.nvim_create_autocmd("BufWritePost", {
        group = preview_augroup,
        pattern = "*.md",
        callback = function()
            if preview_enabled and preview_focused then
                display_mermaid_debounced()
            else
                needs_redraw = true
            end
        end,
    })

    vim.api.nvim_create_autocmd({ "FocusLost", "WinLeave", "BufLeave" }, {
        group = preview_augroup,
        pattern = "*.md",
        callback = function()
            preview_focused = false
        end,
    })

    vim.api.nvim_create_autocmd("FocusGained", {
        group = preview_augroup,
        pattern = "*.md",
        callback = function()
            preview_focused = true
            if not preview_enabled then return end

            -- Handle return from tmux session browser (render_blocked)
            if render_blocked then
                render_blocked = false
                display_mermaid_images()
                return
            end

            -- Handle session switch (different tmux session)
            local current_session = get_tmux_session()
            if current_session and last_tmux_session and current_session ~= last_tmux_session then
                last_tmux_session = current_session
                clear_mermaid_images()
                display_mermaid_debounced()
            elseif needs_redraw then
                needs_redraw = false
                display_mermaid_debounced()
            end
        end,
    })

    vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
        group = preview_augroup,
        pattern = "*.md",
        callback = function()
            preview_focused = true
            if preview_enabled and needs_redraw then
                needs_redraw = false
                display_mermaid_debounced()
            end
        end,
    })

    -- Backup redraw triggers if FocusGained doesn't fire
    vim.api.nvim_create_autocmd({ "WinScrolled", "CursorMoved", "CursorMovedI", "InsertEnter" }, {
        group = preview_augroup,
        pattern = "*.md",
        callback = function()
            if preview_enabled and (render_blocked or needs_redraw) then
                render_blocked = false
                needs_redraw = false
                display_mermaid_images()
            end
        end,
    })

    -- Clear images on terminal resize (tmux splits) - re-render on scroll
    vim.api.nvim_create_autocmd("VimResized", {
        group = preview_augroup,
        callback = function()
            if preview_enabled then
                clear_mermaid_images()
                needs_redraw = true
            end
        end,
    })

    vim.notify("Markdown preview ON", vim.log.levels.INFO)
end

local function disable_preview()
    preview_enabled = false
    vim.cmd("RenderMarkdown disable")
    clear_mermaid_images()
    stop_file_watcher()

    if debounce_timer then
        debounce_timer:stop()
        debounce_timer = nil
    end

    vim.api.nvim_clear_autocmds({ group = preview_augroup })
    vim.notify("Markdown preview OFF", vim.log.levels.INFO)
end

local function toggle_preview()
    if preview_enabled then
        disable_preview()
    else
        enable_preview()
    end
end

return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
        "3rd/image.nvim",
    },
    ft = { "markdown" },
    keys = {
        { "<leader>mp", toggle_preview, desc = "Toggle markdown preview" },
    },
    config = function()
        require("render-markdown").setup({
            enabled = true,
            render_modes = { "n", "c", "t", "i" },
            anti_conceal = {
                enabled = true,
                above = 0,
                below = 0,
                ignore = {
                    code_background = true,
                },
            },
            heading = {
                enabled = true,
                sign = true,
                icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
                position = "inline",
                left_margin = { 0, 0, 0, 0, 0, 0 },
                left_pad = { 0, 0, 0, 0, 0, 0 },
                right_pad = { 0, 0, 0, 0, 0, 0 },
                min_width = { 0, 0, 0, 0, 0, 0 },
                border = false,
            },
            indent = { enabled = false },
            code = {
                enabled = true,
                sign = false,
                style = "full",
                border = "thin",
            },
            bullet = {
                enabled = true,
                icons = { "●", "○", "◆", "◇" },
            },
            checkbox = {
                enabled = true,
                unchecked = { icon = "󰄱 " },
                checked = { icon = "󰄵 " },
            },
            quote = { enabled = true },
            pipe_table = { enabled = true },
            callout = {
                note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
                tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
                important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
                warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
                caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
            },
        })

        vim.api.nvim_create_user_command("MarkdownPreview", toggle_preview, {
            desc = "Toggle markdown preview mode",
        })

        -- Auto-enable preview for markdown files
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "markdown",
            callback = function()
                if not preview_enabled then
                    enable_preview()
                end
            end,
        })

        -- Handle buffer switches (e.g., harpoon navigation)
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "*.md",
            callback = function()
                if vim.bo.filetype == "markdown" then
                    if not preview_enabled then
                        enable_preview()
                    else
                        display_mermaid_debounced()
                    end
                    -- Trigger BufWinEnter for render-markdown (harpoon uses nvim_set_current_buf which may not fire it)
                    vim.schedule(function()
                        vim.cmd("doautocmd BufWinEnter")
                    end)
                end
            end,
        })

        -- Enable immediately if current buffer is already markdown (lazy load case)
        if vim.bo.filetype == "markdown" then
            enable_preview()
        end
    end,
}
