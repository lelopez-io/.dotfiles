return {
    "mbbill/undotree",

    config = function()
        vim.g.undotree_SetFocusWhenToggle = 1 -- Auto Focus
        vim.g.undotree_SplitWidth = 40 -- 30 is a bit to small
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end,
}
