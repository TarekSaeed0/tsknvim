vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("tsknvim_open_at_last_cursor_position", { clear = true }),
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
			vim.api.nvim_win_set_cursor(0, mark)
		end
	end,
})

--[[ vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local virtual_line = { { "" } }
		local virtual_lines = {}
		for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			local buffer = vim.api.nvim_win_get_buf(window)
			for _ = #virtual_lines, vim.api.nvim_win_get_height(window) do
				table.insert(virtual_lines, virtual_line)
			end
			vim.api.nvim_buf_set_extmark(
				buffer,
				vim.api.nvim_create_namespace("tsknvim_continue_column_after_end_of_buffer"),
				math.max(0, vim.api.nvim_buf_line_count(buffer) - 1),
				0,
				{ id = 1, virt_lines = virtual_lines }
			)
		end
		vim.defer_fn(function()
			vim.api.nvim_set_decoration_provider(
				vim.api.nvim_create_namespace("tsknvim_continue_column_after_end_of_buffer"),
				{
					on_win = function(_, window, buffer)
						vim.defer_fn(function()
							if vim.api.nvim_win_is_valid(window) and vim.api.nvim_buf_is_valid(buffer) then
								for _ = #virtual_lines, vim.api.nvim_win_get_height(window) do
									table.insert(virtual_lines, virtual_line)
								end
								vim.api.nvim_buf_set_extmark(
									buffer,
									vim.api.nvim_create_namespace("tsknvim_continue_column_after_end_of_buffer"),
									math.max(0, vim.api.nvim_buf_line_count(buffer) - 1),
									0,
									{ id = 1, virt_lines = virtual_lines }
								)
							end
						end, 0)
					end,
				}
			)
		end, 0)
	end,
	once = true,
}) ]]

vim.api.nvim_create_autocmd("CmdlineEnter", {
	group = vim.api.nvim_create_augroup("tsknvim_show_command_line_on_enter", { clear = true }),
	callback = function()
		vim.opt.cmdheight = 1
	end,
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
	group = vim.api.nvim_create_augroup("tsknvim_hide_command_line_on_leave", { clear = true }),
	callback = function()
		vim.opt.cmdheight = 0
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("tsknvim_highlight_text_on_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "search", timeout = 250 })
	end,
})
