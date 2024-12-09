vim.g.mapleader = " "
vim.keymap.set("n", "<leader>jj", vim.cmd.Ex, { desc = "Open file explorer (netrw)" })

vim.keymap.set(
    "i",
    "<S-Tab>",
    "<C-d>",
    { noremap = true, silent = true, desc = "Allow shift-tab to unindent in insert mode" }
)
vim.keymap.set(
    "n",
    "<S-Tab>",
    "<<",
    { noremap = true, silent = true, desc = "Allow shift-tab to unindent in normal mode" }
)
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true, desc = "Save with Ctrl+S" })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = true, desc = "Save with Ctrl+S in insert mode" })

-- Move selected lines up/down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- Better line joins and scrolling
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center cursor" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center cursor" })

-- Paste over selection without copying it
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yanking selection" })

-- System clipboard operations
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

-- Delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- Disable Ex mode
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })

-- Quickfix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location list item" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous location list item" })

-- Quick actions
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search and replace word under cursor" })
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })

-- Go error handling snippet
vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>", { desc = "Insert Go error handling" })

-- Format current buffer
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end, { desc = "Format current buffer" })

-- Source current file
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end, { desc = "Source current file" })
