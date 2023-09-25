return {
	{
		"gorbit99/codewindow.nvim",
		opts = { window_border = "rounded" },
		config = function(_, opts)
			local codewindow = require("codewindow")

			codewindow.setup(opts)
			codewindow.apply_default_keybinds()

			local current_window
			local create_window = require("codewindow.window").create_window
			---@diagnostic disable-next-line: duplicate-set-field
			require("codewindow.window").create_window = function(buffer, on_switch_window, on_cursor_move)
				local window = create_window(buffer, on_switch_window, on_cursor_move)
				if window then
					if not current_window then
						current_window = window
						window = create_window(buffer, on_switch_window, on_cursor_move)
						if window then
							current_window = window
						end
					else
						current_window = window
					end
					if vim.api.nvim_buf_is_valid(buffer or -1) then
						vim.api.nvim_create_autocmd(require("codewindow.config").get().events, {
							group = "CodewindowAugroup",
							buffer = buffer,
							callback = function()
								vim.api.nvim_exec_autocmds("WinScrolled", {
									group = "CodewindowAugroup",
									buffer = buffer,
								})
							end,
						})
					end
				end
				return window
			end
			setmetatable(require("codewindow.config").get(), {
				__index = function(_, key)
					if key == "max_minimap_height" and current_window then
						return math.ceil(vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(current_window.parent_win)) / 4) + 2
					end
				end,
			})

			local update_minimap = require("codewindow.text").update_minimap
			---@diagnostic disable-next-line: duplicate-set-field
			require("codewindow.text").update_minimap = function(...)
				local nvim_buf_get_lines = vim.api.nvim_buf_get_lines
				---@diagnostic disable-next-line: duplicate-set-field
				vim.api.nvim_buf_get_lines = function(...)
					local lines = nvim_buf_get_lines(...)
					for index, line in ipairs(lines) do
						lines[index] = line:gsub("\t", (" "):rep(vim.opt.tabstop:get()))
					end
					return lines
				end
				update_minimap(...)
				vim.api.nvim_buf_get_lines = nvim_buf_get_lines
			end


			local display_cursor = require("codewindow.highlight").display_cursor
			---@diagnostic disable-next-line: duplicate-set-field
			require("codewindow.highlight").display_cursor = function(...)
				local nvim_win_get_cursor = vim.api.nvim_win_get_cursor
				---@diagnostic disable-next-line: duplicate-set-field
				vim.api.nvim_win_get_cursor = function(...)
					local cursor = nvim_win_get_cursor(...)
					cursor[2] = vim.fn.virtcol(cursor)
					return cursor
				end
				display_cursor(...)
				vim.api.nvim_win_get_cursor = nvim_win_get_cursor
			end
		end,
		keys = {
			"<leader>mo",
			"<leader>mf",
			"<leader>mc",
			"<leader>mm",
		},
	}
}
