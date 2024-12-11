return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },
    config = function()
        local telescope = require("telescope")
        telescope.setup({
            defaults = {
                file_ignore_patterns = { "node_modules", ".git", ".venv", "yarn.lock" },
            },
            pickers = {
                live_grep = {
                    file_ignore_patterns = { "node_modules", ".git", ".venv" },
                    additional_args = function(_)
                        return { "--hidden" }
                    end,
                },
                find_files = {
                    file_ignore_patterns = { "node_modules", ".git", ".venv" },
                    hidden = true,
                },
            },
            extensions = {
                "fzf",
            },
        })
        telescope.load_extension("fzf")

        local builtin = require("telescope.builtin")

        -- Telescope keymaps
        vim.keymap.set("n", "<leader>kk", builtin.find_files, {
            noremap = false,
            silent = false,
            desc = "Find files in current directory (includes hidden files)",
        })

        vim.keymap.set("n", "<leader>ki", builtin.git_files, {
            noremap = false,
            silent = false,
            desc = "Find files tracked by git",
        })

        vim.keymap.set("n", "<leader>kws", function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end, {
            noremap = false,
            silent = false,
            desc = "Search for word under cursor",
        })

        vim.keymap.set("n", "<leader>kWs", function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end, {
            noremap = false,
            silent = false,
            desc = "Search for WORD under cursor (includes more characters)",
        })

        vim.keymap.set("n", "<leader>ksa", function()
            builtin.grep_string({
                search = vim.fn.input("Grep > "),
                additional_args = { "--hidden" },
            })
        end, {
            noremap = false,
            silent = false,
            desc = "Interactive search (grep) through all files",
        })

        vim.keymap.set("n", "<leader>kh", builtin.help_tags, {
            noremap = false,
            silent = false,
            desc = "Search through Neovim help tags",
        })
    end,
}
