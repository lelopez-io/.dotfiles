return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",  -- Required for Neovim 0.12+
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            -- A list of parser names, or "all"
            ensure_installed = {
                "vimdoc",
                "javascript",
                "typescript",
                "c",
                "lua",
                "rust",
                "jsdoc",
                "bash",
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
            auto_install = true,

            indent = {
                enable = true,
            },

            highlight = {
                -- `false` will disable the whole extension
                enable = true,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = { "markdown" },
            },
        })

        -- Register custom templ parser (new API for nvim-treesitter main branch)
        vim.api.nvim_create_autocmd("User", {
            pattern = "TSUpdate",
            callback = function()
                require("nvim-treesitter.parsers").templ = {
                    install_info = {
                        url = "https://github.com/vrischmann/tree-sitter-templ",
                        revision = "68d6707ed20159ae7525241b8161c126dc1c620c",
                        files = { "src/parser.c", "src/scanner.c" },
                    },
                }
            end,
        })

        vim.treesitter.language.register("templ", "templ")
    end,
}
