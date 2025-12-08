return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        require("nvim-autopairs").setup({
            check_ts = true, -- Use treesitter
            ts_config = {
                lua = { "string" }, -- Don't add pairs in lua string treesitter nodes
                javascript = { "template_string" },
                java = false, -- Don't check treesitter on java
            },
        })
    end,
}
