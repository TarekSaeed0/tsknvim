if vim.g.lazy_did_setup then
	return {}
end

local lazy_path = vim.fn.stdpath("data").."/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
	if vim.fn.executable("git") ~= 1 then
		return {}
	end
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
	local timer = vim.loop.new_timer()
	local tcp = vim.loop.new_tcp()

	timer:start(1000, 0, function()
		timer:stop()
		timer:close()
		tcp:close()
	end)

	tcp:connect("8.8.8.8", 53, function(error)
		timer:stop()
		timer:close()
		tcp:close()

		if not error then
			vim.defer_fn(function()
				report(notify)
			end, 0)
		end
	end)
end
