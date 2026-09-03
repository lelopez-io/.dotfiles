vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = true
vim.opt.linebreak = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.filetype.add({
    extension = {
        templ = "templ",
    },
})

-- Yanks go to both clipboards: OSC 52 reaches whatever terminal is attached
-- now, pbcopy keeps the local pasteboard in sync so `"+p` round-trips. A herdr
-- session outlives the shell that started it, so the birth env cannot decide
-- this. Paste stays local, since OSC 52 reads block 10s when unanswered.
local osc52 = require("vim.ui.clipboard.osc52")

local function copy(reg)
    local send = osc52.copy(reg)
    return function(lines, regtype)
        send(lines, regtype)
        vim.fn.system({ "pbcopy" }, table.concat(lines, "\n"))
    end
end

local function paste()
    return vim.fn.systemlist("pbpaste")
end

vim.g.clipboard = {
    name = "osc52+pbcopy",
    copy = { ["+"] = copy("+"), ["*"] = copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
}
