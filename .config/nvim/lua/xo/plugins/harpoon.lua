return {
    "ThePrimeagen/harpoon",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        vim.keymap.set("n", "<leader>ha", mark.add_file)
        vim.keymap.set("n", "<leader>hl", ui.toggle_quick_menu)
        vim.keymap.set("n", "<leader>hj", ui.nav_next)
        vim.keymap.set("n", "<leader>hk", ui.nav_prev)
    end,
}
