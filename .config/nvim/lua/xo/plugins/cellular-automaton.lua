return {
    "eandrju/cellular-automaton.nvim",
    config = function()
        vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")
        vim.keymap.set("n", "<leader>gol", "<cmd>CellularAutomaton game_of_life<CR>", { desc = "Cellular Automaton: Game of Life" })
    end,
}
