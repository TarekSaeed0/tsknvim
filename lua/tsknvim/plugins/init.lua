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
vim.api.nvim_create_user_command("LazyIsLoaded", function(opts)
	print(vim.tbl_filter(function(plugin)
		return plugin.name == opts.args
	end, require("lazy").plugins())[1]._.loaded ~= nil)
end, {
	nargs = 1,
	complete = function(arg_lead)
		return vim.tbl_filter(function(name)
			return name:find(arg_lead, 1, true) == 1
		end, vim.tbl_map(function(plugin)
			return plugin.name
		end, require("lazy").plugins()))
	end,
})

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
