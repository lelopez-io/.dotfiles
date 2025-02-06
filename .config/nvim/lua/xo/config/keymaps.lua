-- Leader key configuration
vim.g.mapleader = " "

-- File explorer
vim.keymap.set("n", "<leader>jj", vim.cmd.Ex, {
    noremap = false,
    silent = false,
    desc = "Open file explorer (netrw)",
})

-- Indentation controls
vim.keymap.set("i", "<S-Tab>", "<C-d>", {
    noremap = true,
    silent = true,
    desc = "Allow shift-tab to unindent in insert mode",
})
vim.keymap.set("n", "<S-Tab>", "<<", {
    noremap = true,
    silent = true,
    desc = "Allow shift-tab to unindent in normal mode",
})

-- Quick save
vim.keymap.set("n", "<C-s>", ":w<CR>", {
    noremap = true,
    silent = true,
    desc = "Save with Ctrl+S",
})
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", {
    noremap = true,
    silent = true,
    desc = "Save with Ctrl+S in insert mode",
})

-- Move selected lines up/down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {
    noremap = false,
    silent = false,
    desc = "Move selected lines down",
})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {
    noremap = false,
    silent = false,
    desc = "Move selected lines up",
})

-- Better line joins and scrolling
vim.keymap.set("n", "J", "mzJ`z", {
    noremap = false,
    silent = false,
    desc = "Join lines and keep cursor position",
})
vim.keymap.set("n", "n", "nzzzv", {
    noremap = false,
    silent = false,
    desc = "Next search result and center cursor",
})
vim.keymap.set("n", "N", "Nzzzv", {
    noremap = false,
    silent = false,
    desc = "Previous search result and center cursor",
})

-- Paste over selection without copying it
vim.keymap.set("x", "<leader>p", [["_dP]], {
    noremap = false,
    silent = false,
    desc = "Paste without yanking selection",
})

-- System clipboard operations
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], {
    noremap = false,
    silent = false,
    desc = "Yank to system clipboard",
})
vim.keymap.set("n", "<leader>Y", [["+Y]], {
    noremap = false,
    silent = false,
    desc = "Yank line to system clipboard",
})

-- Yank relative file path
vim.keymap.set("n", "<leader><C-y>", function()
    local relative_path = vim.fn.expand("%")
    vim.fn.setreg("+", relative_path)
    vim.notify("Copied: " .. relative_path)
end, {
    noremap = true,
    silent = true,
    desc = "Yank relative file path to clipboard",
})

-- Delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], {
    noremap = false,
    silent = false,
    desc = "Delete without yanking",
})

-- Disable Ex mode
vim.keymap.set("n", "Q", "<nop>", {
    noremap = false,
    silent = false,
    desc = "Disable Ex mode",
})

-- Quickfix navigation
vim.keymap.set("n", "<C-l>", "<cmd>cnext<CR>zz", {
    noremap = false,
    silent = false,
    desc = "Next quickfix item",
})
vim.keymap.set("n", "<C-h>", "<cmd>cprev<CR>zz", {
    noremap = false,
    silent = false,
    desc = "Previous quickfix item",
})

-- Page navigation
vim.keymap.set("n", "<C-k>", "<C-u>zz", {
    noremap = false,
    silent = false,
    desc = "Scroll up half page",
})
vim.keymap.set("n", "<C-j>", "<C-d>zz", {
    noremap = false,
    silent = false,
    desc = "Scroll down half page",
})
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", {
    noremap = false,
    silent = false,
    desc = "Next location list item",
})
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", {
    noremap = false,
    silent = false,
    desc = "Previous location list item",
})

-- Quick actions
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
    noremap = false,
    silent = false,
    desc = "Search and replace word under cursor",
})
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", {
    noremap = false,
    silent = true,
    desc = "Make current file executable",
})

-- Go error handling snippet
vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>", {
    noremap = false,
    silent = false,
    desc = "Insert Go error handling",
})

-- Format current buffer
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end, {
    noremap = false,
    silent = false,
    desc = "Format current buffer",
})

-- Reload configurations
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("source ~/.config/nvim/init.lua")
    vim.notify("Reloaded neovim configuration", vim.log.levels.INFO)
end, {
    noremap = false,
    silent = false,
    desc = "Reload neovim configuration",
})

vim.keymap.set("n", "<leader><leader>.", function()
    if vim.bo.filetype == "lua" then
        vim.cmd("so")
        vim.notify("Sourced current lua file", vim.log.levels.INFO)
    else
        vim.notify("Sourcing only works on Lua files", vim.log.levels.WARN)
    end
end, {
    noremap = false,
    silent = false,
    desc = "Source current lua file",
})
