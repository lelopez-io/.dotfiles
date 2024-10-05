return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()

        local append_file = function()
            harpoon:list():add()
        end
        local toggle_menu = function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end
        local next_file = function()
            harpoon:list():next()
        end
        local prev_file = function()
            harpoon:list():prev()
        end

        vim.keymap.set("n", "<leader>hi", append_file, { desc = "Add file to Harpoon" })
        vim.keymap.set("n", "<leader>hh", toggle_menu, { desc = "Toggle Harpoon menu" })
        vim.keymap.set("n", "<leader>hj", next_file, { desc = "Next Harpoon file" })
        vim.keymap.set("n", "<leader>hk", prev_file, { desc = "Prev Harpoon file" })
    end,
}
