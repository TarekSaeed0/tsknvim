-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

LazyVim.in_focus = true
vim.api.nvim_create_autocmd("FocusGained", {
	group = vim.api.nvim_create_augroup("set_in_focus_on_focus_gained", { clear = true }),
	callback = function()
		LazyVim.in_focus = true
	end,
})
vim.api.nvim_create_autocmd("FocusLost", {
	group = vim.api.nvim_create_augroup("unset_in_focus_on_focus_lost", { clear = true }),
	callback = function()
		LazyVim.in_focus = false
	end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
	callback = function()
		if vim.w.auto_cursorline then
			vim.wo.cursorline = true
			vim.w.auto_cursorline = nil
		end
	end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
	callback = function()
		if vim.wo.cursorline then
			vim.w.auto_cursorline = true
			vim.wo.cursorline = false
		end
	end,
})

vim.defer_fn(function()
	vim.api.nvim_set_decoration_provider(
		vim.api.nvim_create_namespace("tsknvim_highlight_non_current_floating_windows"),
		{
			on_start = function()
				local current_window = vim.api.nvim_get_current_win()
				for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
					local highlights = {}
					for highlight_from, highlight_to in
						vim.api.nvim_get_option_value("winhighlight", { win = window }):gmatch("([^,]+):([^,]+)")
					do
						highlights[highlight_from] = highlight_to
					end

					local config = vim.api.nvim_win_get_config(window)
					if config and (config.external or config.relative ~= "") then
						local highlight = highlights.NormalFloat or highlights.Normal
						if highlight then
							while highlight ~= "NormalFloatC" and highlight ~= "NormalFloatNC" do
								highlight = vim.api.nvim_get_hl(0, { name = highlight }).link
								if not highlight then
									goto skip_window
								end
							end
						end

						highlights.NormalFloat = (window == current_window and LazyVim.in_focus) and "NormalFloatC"
							or "NormalFloatNC"
					else
						local highlight = highlights.Normal
						if highlight then
							while highlight ~= "NormalC" and highlight ~= "NormalNC" do
								highlight = vim.api.nvim_get_hl(0, { name = highlight }).link
								if not highlight then
									goto skip_window
								end
							end
						end

						highlights.Normal = (window == current_window and LazyVim.in_focus) and "NormalC" or "NormalNC"
					end

					highlights.LineNr = (window == current_window and LazyVim.in_focus) and "LineNrC" or "LineNrNC"
					if vim.api.nvim_get_option_value("number", { win = window }) then
						vim.api.nvim_set_option_value(
							"relativenumber",
							(window == current_window and LazyVim.in_focus),
							{ win = window }
						)
					end

					vim.api.nvim_set_option_value(
						"winhighlight",
						vim.iter(highlights)
							:map(function(key, value)
								return key .. ":" .. value
							end)
							:join(","),
						{ win = window }
					)

					::skip_window::
				end
			end,
		}
	)
end, 0)

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local virtual_line = { { "" } }
		local virtual_lines = {}
		for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			if vim.api.nvim_get_option_value("number", { win = window }) then
				local buffer = vim.api.nvim_win_get_buf(window)
				for _ = #virtual_lines, vim.api.nvim_win_get_height(window) do
					table.insert(virtual_lines, virtual_line)
				end
				vim.api.nvim_buf_set_extmark(
					buffer,
					vim.api.nvim_create_namespace("continue_statuscolumn_after_end_of_buffer"),
					math.max(0, vim.api.nvim_buf_line_count(buffer) - 1),
					-1,
					{ id = 1, virt_lines = virtual_lines }
				)
			end
		end
		vim.defer_fn(function()
			vim.api.nvim_set_decoration_provider(
				vim.api.nvim_create_namespace("continue_statuscolumn_after_end_of_buffer"),
				{
					on_win = function(_, window, buffer)
						if vim.api.nvim_get_option_value("number", { win = window }) then
							vim.defer_fn(function()
								if vim.api.nvim_win_is_valid(window) and vim.api.nvim_buf_is_valid(buffer) then
									for _ = #virtual_lines, vim.api.nvim_win_get_height(window) do
										table.insert(virtual_lines, virtual_line)
									end
									vim.api.nvim_buf_set_extmark(
										buffer,
										vim.api.nvim_create_namespace("continue_statuscolumn_after_end_of_buffer"),
										math.max(0, vim.api.nvim_buf_line_count(buffer) - 1),
										-1,
										{ id = 1, virt_lines = virtual_lines }
									)
								end
							end, 0)
						end
					end,
				}
			)
		end, 0)
	end,
	once = true,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("tsknvim_disable_line_numbers_for_terminal", { clear = true }),
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
	end,
})
