-- The vault path comes from $OBSIDIAN_VAULT, set in the untracked
-- ~/.zshrc.local (template: .zshrc.local.example) so no user-specific
-- path lands in this repo or its history. Explicit over auto-detect:
-- with multiple vaults, "first found" is arbitrary, not intent. States:
--   valid path -> enabled
--   bogus path -> warn once per session, inert
--   unset      -> warn once per session, inert (set a path, or "off")
--   "off"      -> explicitly disabled, silent
local function find_vault()
    local path = vim.env.OBSIDIAN_VAULT
    if path == "off" then return end
    if not path or path == "" then
        vim.notify("obsidian.nvim: $OBSIDIAN_VAULT not set — configure it in ~/.zshrc.local, or set it to 'off' to disable", vim.log.levels.WARN)
        return
    end
    if vim.uv.fs_stat(path) then return path end
    vim.notify("obsidian.nvim: $OBSIDIAN_VAULT is not a directory: " .. path, vim.log.levels.WARN)
end

return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    keys = {
        { "<leader>on", "<cmd>Obsidian new<cr>",          desc = "Obsidian: new note" },
        { "<leader>of", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian: find note" },
        { "<leader>os", "<cmd>Obsidian search<cr>",       desc = "Obsidian: search vault" },
        { "<leader>od", "<cmd>Obsidian today<cr>",        desc = "Obsidian: today's daily" },
        { "<leader>oy", "<cmd>Obsidian yesterday<cr>",    desc = "Obsidian: yesterday's daily" },
        { "<leader>ob", "<cmd>Obsidian backlinks<cr>",    desc = "Obsidian: backlinks" },
        { "<leader>oo", "<cmd>Obsidian open<cr>",         desc = "Obsidian: open in app" },
        { "<leader>or", "<cmd>Obsidian rename<cr>",       desc = "Obsidian: rename note" },
        { "<leader>ol", "<cmd>Obsidian links<cr>",        desc = "Obsidian: list links" },
    },
    opts = function()
        local vault = find_vault()
        if not vault then return end
        return {
        legacy_commands = false,
        frontmatter = {
            enabled = false,
        },
        workspaces = {
            {
                name = vim.fn.fnamemodify(vault, ":t"),
                path = vault,
            },
        },
        daily_notes = {
            folder = "daily",
            date_format = "%Y.%m.%d--%A",
            template = "2025.02.05--template--daily.md",
        },
        templates = {
            folder = "_templates",
        },
        completion = {
            min_chars = 2,
        },
        -- render-markdown.nvim handles UI. Let obsidian.nvim stay out of its way.
        ui = { enable = false },
    }
    end,
    config = function(_, opts)
        -- No vault found: opts fn returned nil and lazy hands us {}
        if not (opts and opts.workspaces) then return end
        require("obsidian").setup(opts)

        -- Bind on LspAttach so obsidian's `gd` wins over the buffer-local
        -- `gd` set by autocmds.lua (vim.lsp.buf.definition). marksman doesn't
        -- follow [[wikilinks]], so smart_action handles that, then falls
        -- through to standard markdown links, then to LSP definition.
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                if vim.bo[args.buf].filetype ~= "markdown" then return end
                local smart = function() return require("obsidian").util.smart_action() end
                vim.keymap.set("n", "gd", smart,
                    { buffer = args.buf, expr = true, desc = "Follow wikilink / LSP definition" })
                vim.keymap.set("n", "<cr>", smart,
                    { buffer = args.buf, expr = true, desc = "Follow wikilink under cursor" })
            end,
        })
    end,
}
