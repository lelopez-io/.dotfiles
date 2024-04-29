return {
    "stevearc/conform.nvim",
    opts = {},

    config = function()
        require("conform").setup({
            -- If this is set, Conform will run the formatter on save.
            -- It will pass the table to conform.format().
            -- This can also be a function that returns the table.
            format_on_save = {
                -- I recommend these options. See :help conform.format for details.
                lsp_fallback = true,
                timeout_ms = 500,
            },
            -- Set the log level. Use `:ConformInfo` to see the location of the log file.
            log_level = vim.log.levels.ERROR,
            -- Conform will notify you when a formatter errors
            notify_on_error = true,
            -- Make sure to install the formaters and ensure the command is available.
            -- Check while in a file with :ConformInfo
            formatters_by_ft = {
                lua = { "stylua" },
                -- Conform will run multiple formatters sequentially
                python = { "isort", "black" },
                -- Use a sub-list to run only the first available formatter
                javascript = { { "prettierd", "prettier" } },

                -- markdown = { "prettierd" },
                -- Use the "_" filetype to run formatters on filetypes that don't
                -- have other formatters configured.
                ["_"] = { "prettierd" },
            },
        })

        vim.keymap.set("n", "<leader>f", function()
            local fc = require("conform").format({ timeout_ms = 500 })
            if not fc then
                vim.lsp.buf.format()
            end
        end)
    end,
}
