
return {
	"ThePrimeagen/harpoon",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = true,
	keys = {
		{ "<leader>hm", "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Mark file with harpoon" },
		{ "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<cr>", desc = "Go to next harpoon mark" },
		{ "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<cr>", desc = "Go to previous harpoon mark" },
		{ "<leader>ha", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Show harpoon marks" },

        -- vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
        -- vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

        -- vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
        -- vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
        -- vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
        -- vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
        -- vim.keymap.set("n", "<leader><C-h>", function() harpoon:list():replace_at(1) end)
        -- vim.keymap.set("n", "<leader><C-t>", function() harpoon:list():replace_at(2) end)
        -- vim.keymap.set("n", "<leader><C-n>", function() harpoon:list():replace_at(3) end)
        -- vim.keymap.set("n", "<leader><C-s>", function() harpoon:list():replace_at(4) end)
	},
}



