local utils = {}

utils.in_focus = true
vim.api.nvim_create_autocmd("FocusGained", {
	group = vim.api.nvim_create_augroup("tsknvim_set_in_focus_on_focus_gained", { clear = true }),
	callback = function()
		utils.in_focus = true
	end,
})
vim.api.nvim_create_autocmd("FocusLost", {
	group = vim.api.nvim_create_augroup("tsknvim_unset_in_focus_on_focus_lost", { clear = true }),
	callback = function()
		utils.in_focus = false
	end,
})

utils.is_installed = function(name)
	local plugin = require("lazy.core.config").plugins[name]
	return plugin and plugin._.installed
end
utils.is_loaded = function(name)
	local plugin = require("lazy.core.config").plugins[name]
	return plugin and plugin._.loaded
end

return utils
