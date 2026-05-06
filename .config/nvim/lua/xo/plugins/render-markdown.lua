-- Markdown preview mode: render-markdown + mermaid diagrams, auto-refresh on external changes

local DEBOUNCE_MS = 300
local CACHE_DIR = "/tmp"

local preview_enabled = false
local preview_focused = true
local file_watcher = nil
local mermaid_images = {}
local debounce_timer = nil
local pending_renders = {}
local needs_redraw = false

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

    vim.fn.jobstart({
        "mmdc", "-i", mmd_path, "-o", png_path, "-b", "transparent", "-t", "dark", "-s", "2"
    }, {
        on_exit = function(_, exit_code)
            pending_renders[hash] = nil
            os.remove(mmd_path)

            if exit_code == 0 and vim.fn.filereadable(png_path) == 1 then
                vim.schedule(function()
                    callback(png_path)
                end)
            else
                vim.schedule(function()
                    vim.notify("Mermaid render failed for " .. hash, vim.log.levels.WARN)
                    callback(nil)
                end)
            end
        end,
        on_stderr = function(_, data)
            if data and data[1] and data[1] ~= "" then
                vim.schedule(function()
                    vim.notify("mmdc: " .. table.concat(data, "\n"), vim.log.levels.DEBUG)
                end)
            end
        end,
    })
end

local function clear_mermaid_images()
    local ok, _ = pcall(require, "image")
    if not ok then return end

    for _, img in ipairs(mermaid_images) do
        pcall(function() img:clear() end)
    end
    mermaid_images = {}
end

local function display_single_image(png_path, end_line, bufnr, winid)
    local ok, image_api = pcall(require, "image")
    if not ok then return end

    local ok_img, img = pcall(image_api.from_file, png_path, {
        buffer = bufnr,
        window = winid,
        with_virtual_padding = true,
        inline = true,
        x = 0,
        y = end_line,
    })

    if ok_img and img then
        pcall(function() img:render() end)
        table.insert(mermaid_images, img)
    end
end

local function display_mermaid_images()
    if not preview_enabled then return end

    local ok, _ = pcall(require, "image")
    if not ok then return end

    clear_mermaid_images()

    local blocks = find_mermaid_blocks()
    if #blocks == 0 then return end

    local bufnr = vim.api.nvim_get_current_buf()
    local winid = vim.api.nvim_get_current_win()

    for _, block in ipairs(blocks) do
        render_mermaid_async(block.content, block.hash, function(png_path)
            if png_path and preview_enabled then
                display_single_image(png_path, block.end_line, bufnr, winid)
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
    vim.cmd("RenderMarkdown enable")
    vim.defer_fn(remove_heading_bold, 200)
    start_file_watcher()
    display_mermaid_images()

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

    vim.api.nvim_create_autocmd({ "FocusGained", "WinEnter", "BufEnter" }, {
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
    end,
}
