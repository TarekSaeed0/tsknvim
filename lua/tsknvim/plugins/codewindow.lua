return {
	{
		"gorbit99/codewindow.nvim",
		opts = { window_border = "rounded" },
		config = function(_, opts)
			local codewindow = require("codewindow")

			codewindow.setup(opts)
			codewindow.apply_default_keybinds()

			local window
			local create_window = require("codewindow.window").create_window
			---@diagnostic disable-next-line: duplicate-set-field
			require("codewindow.window").create_window = function(buffer, on_switch_window, on_cursor_move)
				local new_window = create_window(buffer, on_switch_window, on_cursor_move)
				if new_window then
					if not window then
						require("codewindow.config").get().max_minimap_height = math.ceil(vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(new_window.parent_win)) / 4) + 2
						new_window = create_window(buffer, on_switch_window, on_cursor_move)
					end
					window = new_window
				end
				window = new_window or window
				return new_window
			end
			setmetatable(require("codewindow.config").get(), {
				__index = function(_, key)
					if key == "max_minimap_height" and window then
						return math.ceil(vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(window.parent_win)) / 4) + 2
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
