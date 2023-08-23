vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("tsknvim_open_at_last_cursor_position", { clear = true }),
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, "\"")
		if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
			vim.api.nvim_win_set_cursor(0, mark)
		end
	end,
})

do
	local virtual_line = { { "" } }
	local virtual_lines = {}
	vim.api.nvim_set_decoration_provider(vim.api.nvim_create_namespace("tsknvim_continue_column_after_end_of_buffer"), {
		on_win = function(_, window, buffer)
			for _ = #virtual_lines, vim.api.nvim_win_get_height(window) do
				table.insert(virtual_lines, virtual_line)
			end
			vim.api.nvim_buf_set_extmark(buffer, vim.api.nvim_create_namespace("tsknvim_continue_column_after_end_of_buffer"), vim.api.nvim_buf_line_count(buffer) - 1, 0, { id = 1, virt_lines = virtual_lines })
		end,
	})
end

vim.api.nvim_create_autocmd("CmdlineEnter", {
	group = vim.api.nvim_create_augroup("tsknvim_show_command_line_on_enter", { clear = true }),
	callback = function()
		vim.opt.cmdheight = 1
	end,
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
	group = vim.api.nvim_create_augroup("tsknvim_hide_command_line_on_exit", { clear = true }),
	callback = function()
		vim.opt.cmdheight = 0
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("tsknvim_strip_trailing_whitespace_on_save", { clear = true }),
	command = "%s/\\s\\+$//e",
})
