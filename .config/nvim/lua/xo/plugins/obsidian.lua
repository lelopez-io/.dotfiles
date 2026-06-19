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
    opts = {
        legacy_commands = false,
        frontmatter = {
            enabled = false,
        },
        workspaces = {
            {
                name = "lelopez",
                path = vim.fn.expand("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/lelopez"),
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
            nvim_cmp = false,
            min_chars = 2,
        },
        -- render-markdown.nvim handles UI; let obsidian.nvim stay out of its way
        ui = { enable = false },
    },
    config = function(_, opts)
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
