vim.g.mapleader = ","
vim.g.maplocalleader = ","

vim.g.c_syntax_for_h = 1

vim.opt.mouse = "a"

vim.opt.lazyredraw = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state").."/undo"

vim.opt.wrap = false
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8

vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.smartindent = true

vim.opt.cinkeys:remove({ "0#" })
vim.opt.cinoptions:append({ "#1s" })

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.fillchars:append({ foldopen = "", foldclose = "", eob = " ", msgsep = "─" })

vim.opt.cmdheight = 0

vim.filetype.add({ pattern = {
	["${XDG_CONFIG_HOME}/neofetch/config%.conf"] = function(path, bufnr)
		return require("vim.filetype.detect").sh(path, require("vim.filetype").getlines(bufnr), "bash")
	end,
} })
