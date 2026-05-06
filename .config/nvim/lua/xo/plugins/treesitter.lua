return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- Required for Neovim 0.12+
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({
            install_dir = vim.fn.stdpath("data") .. "/site",
        })

        require("nvim-treesitter").install({
            "vimdoc",
            "javascript",
            "typescript",
            "c",
            "lua",
            "rust",
            "jsdoc",
            "bash",
            "markdown",
            "markdown_inline",
        })

        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                pcall(vim.treesitter.start)
            end,
            desc = "Enable treesitter highlighting",
        })

        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
            desc = "Enable treesitter indentation",
        })

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
            desc = "Register templ parser",
        })

        vim.treesitter.language.register("templ", "templ")
    end,
}
