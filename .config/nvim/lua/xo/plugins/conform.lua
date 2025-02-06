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
                -- Use stop_after_first for these formatters
                javascript = { "eslint_d", "prettierd" },
                typescript = { "eslint_d", "prettierd" },
                javascriptreact = { "eslint_d", "prettierd" },
                typescriptreact = { "eslint_d", "prettierd" },
                css = { "prettierd", "prettier" },
                html = { "prettierd", "prettier" },
                json = { "prettierd", "prettier" },
                markdown = { "prettierd", "prettier" },
            },
            format_on_save = {
                -- Enable format on save
                lsp_fallback = true,
                timeout_ms = 500,
                -- Use stop_after_first for prettier-based formatting
                stop_after_first = {
                    "javascript",
                    "typescript",
                    "javascriptreact",
                    "typescriptreact",
                    "css",
                    "html",
                    "json",
                    "markdown",
                },
            },
            formatters = {
                prettierd = {
                    -- Enable project-level config files
                    cwd = require("conform.util").root_file({
                        -- Add all possible Prettier config files
                        ".prettierrc",
                        ".prettierrc.json",
                        ".prettierrc.js",
                        ".prettierrc.cjs",
                        "prettier.config.js",
                        "package.json",
                    }),
                    -- Include the Tailwind plugin and ensure filename is provided
                    args = function(ctx)
                        return {
                            "--plugin=prettier-plugin-tailwindcss",
                            ctx.filename,
                        }
                    end,
                },
            },
        })

    end,
}
