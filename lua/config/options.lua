-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.guifont = { "FiraCode Nerd Font:h11" }

vim.opt.tabstop = 2
vim.opt.shiftwidth = 0
vim.opt.expandtab = false

vim.opt.pumblend = 0

vim.opt.fillchars:append({ foldopen = "", foldclose = "", msgsep = "─" })

vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_format_enabled = 1
vim.g.vimtex_quickfix_enabled = 0

require("config.usercmds")
