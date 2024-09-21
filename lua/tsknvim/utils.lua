local M = {}

M.in_focus = true
vim.api.nvim_create_autocmd("FocusGained", {
	group = vim.api.nvim_create_augroup("tsknvim_set_in_focus_on_focus_gained", { clear = true }),
	callback = function()
		M.in_focus = true
	end,
})
vim.api.nvim_create_autocmd("FocusLost", {
	group = vim.api.nvim_create_augroup("tsknvim_unset_in_focus_on_focus_lost", { clear = true }),
	callback = function()
		M.in_focus = false
	end,
})

---@param name string
---@return boolean
M.is_installed = function(name)
	local plugin = require("lazy.core.config").plugins[name]
	return plugin and plugin._.installed ~= nil
end
---@param name string
---@return boolean
M.is_loaded = function(name)
	local plugin = require("lazy.core.config").plugins[name]
	return plugin and plugin._.loaded ~= nil
end

---@param callback fun(string)
M.select_file = function(callback)
	local fb_actions = require("telescope._extensions.file_browser.actions")
	local fb_utils = require("telescope._extensions.file_browser.utils")

	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	require("telescope").extensions.file_browser.file_browser({
		cwd = vim.fn.expand("%:p:h"),
		attach_mappings = function()
			local entry_is_dir = function()
				local entry = action_state.get_selected_entry()
				return entry and fb_utils.is_dir(entry.Path)
			end

			actions.select_default:replace(function(prompt_bufnr)
				local path = action_state.get_selected_entry().path
				if entry_is_dir() then
					fb_actions.open_dir(prompt_bufnr, nil, path)
				else
					require("telescope.actions").close(prompt_bufnr)
					callback(path)
				end
			end)

			return true
		end,
	})
end

return M
