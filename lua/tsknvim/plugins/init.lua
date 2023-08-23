if vim.g.lazy_did_setup then
	return {}
end

local lazy_path = vim.fn.stdpath("data").."/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazy_path,
	})
end
vim.opt.rtp:prepend(lazy_path)

vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "lazy" })

vim.diagnostic.config({ virtual_text = { prefix = "●" } }, vim.api.nvim_create_namespace("lazy"))

require("lazy").setup("tsknvim.plugins", {
	install = { colorscheme = { "catppuccin" } },
	ui = { border = "rounded" },
	checker = { enabled = true },
	performance = { rtp = { disabled_plugins = {
		"2html_plugin", "editorconfig", "tohtml", "getscript",
		"getscriptPlugin", "gzip", "logipat",
		"netrw", "netrwPlugin", "netrwSettings",
		"netrwFileHandlers", "matchit", "tar",
		"tarPlugin", "rrhelper", "spellfile_plugin",
		"vimball", "vimballPlugin", "zip",
		"zipPlugin", "tutor", "rplugin",
		"spellfile", "syntax", "synmenu", "optwin",
		"compiler", "bugreport", "ftplugin",
	} } },
})

local report = require("lazy.manage.checker").report
---@diagnostic disable-next-line: duplicate-set-field
require("lazy.manage.checker").report = function(notify)
	if os.execute("echo -e \"GET http://google.com HTTP/1.0\n\n\" | nc google.com 80 &> /dev/null") == 0 then
		report(notify)
	end
end
