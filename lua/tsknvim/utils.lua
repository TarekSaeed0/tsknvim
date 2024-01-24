local utils = {}

utils.in_focus = true
vim.api.nvim_create_autocmd("FocusGained", {
	group = vim.api.nvim_create_augroup("tsknvim_set_in_focus_on_focus_gained", { clear = true }),
	callback = function()
		utils.in_focus = true
		vim.opt.relativenumber = true
	end,
})
vim.api.nvim_create_autocmd("FocusLost", {
	group = vim.api.nvim_create_augroup("tsknvim_unset_in_focus_on_focus_lost", { clear = true }),
	callback = function()
		utils.in_focus = false
		vim.opt.relativenumber = false
	end,
})

utils.is_loaded = function(name)
	return vim.tbl_filter(function(plugin)
		return plugin.name == name
	end, require("lazy").plugins())[1]._.loaded ~= nil
end

return utils
