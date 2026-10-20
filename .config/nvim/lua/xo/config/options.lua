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
-- now, the local clipboard tool keeps this machine's clipboard in sync so
-- `"+p` round-trips. A herdr session outlives the shell that started it, so
-- the birth env cannot decide this. Paste stays local, since OSC 52 reads
-- block 10s when unanswered. pbcopy on macOS, wl-clipboard on Wayland; with
-- neither, yanks still reach the terminal and paste returns nothing.
local osc52 = require("vim.ui.clipboard.osc52")

local local_copy, local_paste
if vim.fn.executable("pbcopy") == 1 then
    local_copy, local_paste = { "pbcopy" }, { "pbpaste" }
elseif vim.fn.executable("wl-copy") == 1 then
    local_copy, local_paste = { "wl-copy" }, { "wl-paste", "--no-newline" }
end

local function copy(reg)
    local send = osc52.copy(reg)
    return function(lines, regtype)
        send(lines, regtype)
        if local_copy then
            vim.fn.system(local_copy, table.concat(lines, "\n"))
        end
    end
end

local function paste()
    if not local_paste then return {} end
    return vim.fn.systemlist(local_paste)
end

vim.g.clipboard = {
    name = "osc52+local",
    copy = { ["+"] = copy("+"), ["*"] = copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
}
