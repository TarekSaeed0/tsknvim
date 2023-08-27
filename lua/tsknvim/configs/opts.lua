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
vim.opt.fillchars:append({ eob = " " })

vim.opt.cmdheight = 0

local spawn = vim.loop.spawn
---@diagnostic disable-next-line: duplicate-set-field
vim.loop.spawn = function(path, options, on_exit)
	if ({ man = true, mandb = true, manpath = true, apropos = true })[path] then
		options = options or {}
		options.args = options.args or {}
		table.insert(options.args, 1, "--config-file="..vim.env.XDG_CONFIG_HOME.."/man/config")
	end
	return spawn(path, options, on_exit)
end
