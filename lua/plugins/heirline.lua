return {
	{
		"nvim-lualine/lualine.nvim",
		optional = true,
		enabled = false,
	},
	{
		"akinsho/bufferline.nvim",
		optional = true,
		enabled = false,
	},
	{
		"rebelot/heirline.nvim",
		event = "VeryLazy",
		init = function()
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				vim.o.statusline = " "
			else
				vim.o.laststatus = 0
			end
		end,
		opts = function()
			local hl_utils = require("heirline.utils")

			local statusline = { hl = "StatusLine" }

			local mode = {
				init = function(self)
					local mode = vim.api.nvim_get_mode().mode
					self.name = vim
						.iter(mode:gmatch("."))
						:enumerate()
						:map(function(i)
							return mode:sub(1, -i)
						end)
						:map(function(s)
							return self.names[s]
						end)
						:next() or mode
				end,
				static = {
					names = {
						n = { "NORMAL", "N" },
						no = { "O-PENDING", "OP" },
						v = { "VISUAL", "V" },
						V = { "V-LINE", "VL" },
						["\22"] = { "V-BLOCK", "VB" },
						s = { "SELECT", "S" },
						S = { "S-LINE", "SL" },
						["\19"] = { "S-BLOCK", "SB" },
						i = { "INSERT", "I" },
						R = { "REPLACE", "R" },
						Rv = { "V-REPLACE", "VR" },
						c = { "COMMAND", "C" },
						cv = { "EX", "EX" },
						r = { "PROMPT", "E" },
						rm = { "MORE", "M" },
						["r?"] = { "CONFIRM", "CO" },
						["!"] = { "SHELL", "SH" },
						t = { "TERMINAL", "T" },
					},
				},
				{
					{
						provider = "",
						hl = function()
							return { fg = hl_utils.get_highlight("Keyword").fg }
						end,
					},
					hl = "Normal",
				},
				{
					flexible = 40,
					{
						provider = function(self)
							return "  " .. self.name[1] .. " "
						end,
					},
					{
						provider = function(self)
							return "  " .. self.name[2] .. " "
						end,
					},
					hl = function()
						return {
							fg = hl_utils.get_highlight("StatusLine").bg,
							bg = hl_utils.get_highlight("Keyword").fg,
						}
					end,
				},
				{
					provider = "╲",
					hl = function()
						return { fg = hl_utils.get_highlight("Keyword").fg }
					end,
				},
				hl = { bold = true },
			}
			table.insert(statusline, mode)

			local cwd = {
				{ provider = "  " },
				init = function(self)
					local path = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")

					local separator = package.config:sub(1, 1)
					local ellipsis = "…"

					local components = vim.split(path, separator)

					local child = { flexible = 50 }

					child[1] = { provider = path }
					for i = 2, #components do
						child[i] = {
							provider = ellipsis .. separator .. table.concat(components, separator, i),
						}
					end
					child[#components + 1] = nil

					self[2] = self:new(child, 2)
				end,
				update = { "DirChanged" },
			}
			table.insert(statusline, cwd)

			local venv = {
				provider = function()
					return "  " .. vim.env.VIRTUAL_ENV_PROMPT
				end,
				condition = function()
					return vim.env.VIRTUAL_ENV_PROMPT
				end,
			}
			table.insert(statusline, venv)

			if LazyVim.has("gitsigns.nvim") then
				local git = {
					init = function(self)
						if not rawget(self, "once") then
							vim.api.nvim_create_autocmd("BufEnter", {
								callback = function()
									self._win_cache = nil
								end,
							})
							self.once = true
						end
					end,
					{
						init = function(self)
							---@diagnostic disable-next-line: undefined-field
							self.branch = vim.b.gitsigns_head
						end,
						provider = function(self)
							return "  " .. self.branch
						end,
						on_click = {
							callback = function()
								if LazyVim.has("telescope.nvim") then
									require("telescope.builtin").git_branches()
								elseif LazyVim.has("fzf-lua") then
									require("fzf-lua").git_branches()
								end
							end,
							name = "heirline_git_branch_callback",
						},
						condition = function()
							---@diagnostic disable-next-line: undefined-field
							return vim.b.gitsigns_head
						end,
					},
					{
						init = function(self)
							---@diagnostic disable-next-line: undefined-field
							self.add_count = vim.b.gitsigns_status_dict.added or 0
							---@diagnostic disable-next-line: undefined-field
							self.change_count = vim.b.gitsigns_status_dict.changed or 0
							---@diagnostic disable-next-line: undefined-field
							self.delete_count = vim.b.gitsigns_status_dict.removed or 0
						end,
						{
							provider = function(self)
								return "  " .. self.add_count
							end,
							hl = "GitSignsAdd",
							condition = function(self)
								return self.add_count ~= 0
							end,
						},
						{
							provider = function(self)
								return "  " .. self.change_count
							end,
							hl = "GitSignsChange",
							condition = function(self)
								return self.change_count ~= 0
							end,
						},
						{
							provider = function(self)
								return "  " .. self.delete_count
							end,
							hl = "GitSignsDelete",
							condition = function(self)
								return self.delete_count ~= 0
							end,
						},
						on_click = {
							callback = function()
								if LazyVim.has("telescope.nvim") then
									require("telescope.builtin").git_status()
								elseif LazyVim.has("fzf-lua") then
									require("fzf-lua").git_status()
								end
							end,
							name = "heirline_git_status_callback",
						},
						condition = function()
							---@diagnostic disable-next-line: undefined-field
							return vim.b.gitsigns_status_dict
						end,
					},
					-- FIX: temporarily disabled because I don't know how to add both GitSignsUpdate and BufEnter
					update = {
						"User",
						pattern = { "GitSignsUpdate", "GitSignsChanged" },
					},
				}
				table.insert(statusline, git)
			end

			local cmd = {
				{
					{
						provider = "  ",
						hl = { fg = "red", bold = true },
					},
					{
						provider = function()
							return "@" .. vim.fn.reg_recording()
						end,
					},
					condition = function()
						return vim.fn.reg_recording() ~= ""
					end,
					update = {
						"RecordingEnter",
						"RecordingLeave",
						callback = vim.schedule_wrap(function()
							vim.cmd.redrawstatus()
						end),
					},
				},
				{
					provider = function()
						local search = vim.fn.searchcount()
						return "  "
							.. string.format(
								"%" .. tostring(math.min(search.total, search.maxcount)):len() .. "d/%d",
								search.current,
								math.min(search.total, search.maxcount)
							)
					end,
					condition = function()
						return vim.v.hlsearch ~= 0
					end,
				},
				{
					flexible = 30,
					{
						provider = " %0.5(%S%)",
						condition = function()
							return vim.opt.showcmdloc:get() == "statusline"
						end,
					},
					{ provider = "" },
				},
				condition = function()
					return vim.opt.cmdheight:get() == 0
				end,
			}
			table.insert(statusline, cmd)

			table.insert(statusline, { provider = "%=" })

			if LazyVim.has("codeium.nvim") then
				local codeium = {
					provider = function(self)
						return "󰘦 " .. self.status
					end,
					hl = function(self)
						if self.status == "error" then
							return "DiagnosticError"
						elseif self.status == "pending" then
							return "DiagnosticWarn"
						end
					end,
					condition = function(self)
						if not LazyVim.is_loaded("nvim-cmp") then
							return false
						end

						local source = vim.iter(require("cmp").core.sources):find(function(source)
							return source.name == "codeium"
						end)
						if source then
							if source.source:is_available() then
								self.started = true
								if source.status == source.SourceStatus.FETCHING then
									self.status = "pending"
								else
									self.status = "okay"
								end
							else
								self.status = self.started and "error" or nil
							end
						end

						return self.status
					end,
				}
				table.insert(statusline, codeium)
			end

			if LazyVim.has("flutter-tools.nvim") then
				local flutter = {
					{
						provider = function()
							return "  " .. vim.g.flutter_tools_decorations.app_version
						end,
						condition = function()
							return vim.g.flutter_tools_decorations.app_version
						end,
					},
					{
						provider = function()
							return " 󰾰 " .. vim.g.flutter_tools_decorations.device
						end,
						condition = function()
							return vim.g.flutter_tools_decorations.device
						end,
					},
					condition = function()
						return vim.g.flutter_tools_decorations
					end,
				}
				table.insert(statusline, flutter)
			end

			if LazyVim.has("nvim-lint") then
				local linters = {
					flexible = 0,
					{
						provider = function(self)
							local string = " 󱉶"
							for _, linter in ipairs(self.linters) do
								string = string .. " " .. linter
							end
							return string
						end,
						condition = function(self)
							if not LazyVim.is_loaded("nvim-lint") then
								return false
							end

							self.linters = require("lint").get_running()

							return #self.linters ~= 0
						end,
					},
					{ provider = "" },
				}
				table.insert(statusline, linters)
			end

			if LazyVim.has("conform.nvim") then
				local formatters = {
					flexible = 10,
					{
						init = function(self)
							self.formatters = require("conform").list_formatters()
						end,
						provider = function(self)
							local string = " 󱍓"
							for _, formatter in ipairs(self.formatters) do
								string = string .. " " .. formatter.name
							end
							return string
						end,
						on_click = {
							callback = function()
								vim.cmd.ConformInfo()
							end,
							name = "heirline_formatters_callback",
						},
						condition = function()
							return LazyVim.is_loaded("conform.nvim") and #require("conform").list_formatters_for_buffer() ~= 0
						end,
						update = { "BufEnter", "BufWritePre" },
					},
				}
				table.insert(statusline, formatters)
			end

			if LazyVim.has("dap.nvim") then
				local dap = {
					flexible = 15,
					{
						provider = function(self)
							return "   " .. self.status
						end,
						on_click = {
							callback = function()
								vim.cmd.ConformInfo()
							end,
							name = "heirline_formatters_callback",
						},
						condition = function(self)
							if not LazyVim.is_loaded("dap.nvim") then
								return false
							end

							self.status = require("dap").status()

							return self.status ~= ""
						end,
					},
					{ provider = "" },
				}
				table.insert(statusline, dap)
			end

			local lsp = {
				{
					init = function(self)
						self.error_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
						self.warning_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
						self.information_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
						self.hint_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
					end,
					{
						provider = function(self)
							return "  " .. self.error_count
						end,
						hl = "DiagnosticError",
						condition = function(self)
							return self.error_count ~= 0
						end,
					},
					{
						provider = function(self)
							return "  " .. self.warning_count
						end,
						hl = "DiagnosticWarn",
						condition = function(self)
							return self.warning_count ~= 0
						end,
					},
					{
						provider = function(self)
							return "  " .. self.information_count
						end,
						hl = "DiagnosticInfo",
						condition = function(self)
							return self.information_count ~= 0
						end,
					},
					{
						provider = function(self)
							return " 󰌵 " .. self.hint_count
						end,
						hl = "DiagnosticHint",
						condition = function(self)
							return self.hint_count ~= 0
						end,
					},
					on_click = {
						callback = function()
							if LazyVim.has("telescope.nvim") then
								require("telescope.builtin").diagnostics()
							elseif LazyVim.has("fzf-lua") then
								require("fzf-lua").diagnostics_document()
							end
						end,
						name = "heirline_diagnostics_callback",
					},
					condition = function()
						return #vim.diagnostic.get(0) ~= 0
					end,
					update = { "DiagnosticChanged", "BufEnter" },
				},
				{
					flexible = 70,
					{
						provider = function()
							return "   "
								.. vim
									.iter(vim.lsp.get_clients({ bufnr = 0 }))
									:map(function(client)
										return client.name
									end)
									:join(" ")
						end,
						on_click = {
							callback = function()
								vim.schedule(vim.cmd.LspInfo)
							end,
							name = "heirline_lsp_callback",
						},
						condition = function()
							return #vim.lsp.get_clients({ bufnr = 0 }) ~= 0
						end,
						update = { "LspAttach", "LspDetach", "BufEnter" },
					},
					{ provider = "" },
				},
			}
			table.insert(statusline, lsp)

			local cursor = {
				init = function(self)
					self.line = vim.api.nvim_win_get_cursor(0)[1]
					self.lines = vim.api.nvim_buf_line_count(0)

					self.column = vim.fn.virtcol(".")
					self.columns = vim.fn.virtcol({ self.line, "$" })

					self.long_position = (
						"  %"
						.. tostring(self.lines):len()
						.. "d/%d:%"
						.. tostring(self.columns):len()
						.. "d/%d "
					):format(self.line, self.lines, self.column, self.columns)

					self.short_position = (
						"  %"
						.. tostring(self.lines):len()
						.. "d:%"
						.. tostring(self.columns):len()
						.. "d "
					):format(self.line, self.column)
				end,
				{
					flexible = 20,
					{
						{
							provider = function(self)
								return self.long_position
							end,
						},
						{
							provider = "  %P ",
						},
					},
					{
						provider = function(self)
							return self.long_position
						end,
					},
					{
						provider = function(self)
							return self.short_position
						end,
					},
				},
				{
					{
						provider = "",
						hl = function()
							return { fg = hl_utils.get_highlight("StatusLine").bg }
						end,
					},
					hl = "Normal",
				},
				hl = { bold = true },
				update = { "CursorMoved", "CursorMovedI" },
			}
			table.insert(statusline, cursor)

			local tabline = { hl = "TabLineFill" }

			local tabline_offset = {
				flexible = 70,
				{
					{
						fallthrough = false,
						{
							{
								{
									provider = "",
									hl = function()
										return { fg = hl_utils.get_highlight("Keyword").fg }
									end,
								},
								hl = "Normal",
							},
							{
								provider = function(self)
									return " " .. self.title .. " "
								end,
								hl = function()
									return {
										fg = hl_utils.get_highlight("StatusLine").bg,
										bg = hl_utils.get_highlight("Keyword").fg,
									}
								end,
							},
							{
								provider = "╱",
								hl = function()
									return { fg = hl_utils.get_highlight("Keyword").fg }
								end,
							},
							{
								provider = function(self)
									return string.rep(" ", vim.api.nvim_win_get_width(self.window) - #self.title - 5)
								end,
							},
							condition = function(self)
								return vim.api.nvim_win_get_width(self.window) - #self.title - 5 >= 0
							end,
						},
						{
							provider = function(self)
								return string.rep(" ", vim.api.nvim_win_get_width(self.window))
							end,
						},
					},
					{
						provider = "│",
						hl = "WinSeparator",
					},
					condition = function(self)
						self.window = vim.api.nvim_tabpage_list_wins(0)[1]
						local buffer = vim.api.nvim_win_get_buf(self.window)

						if vim.api.nvim_get_option_value("filetype", { buf = buffer }) == "neo-tree" then
							self.title = "Explorer"
							return true
						end
					end,
				},
				{ provider = "" },
			}
			table.insert(tabline, tabline_offset)

			local buffers = {
				{
					static = {
						buffer = {
							{
								provider = "",
								hl = function(self)
									return {
										fg = hl_utils.get_highlight(self.is_active and "TabLineSel" or "TabLine").bg,
										bg = hl_utils.get_highlight("TabLineFill").bg,
									}
								end,
							},
							{
								init = function(self)
									local name = vim.api.nvim_buf_get_name(self.buffer)
									local stat = vim.uv.fs_stat(name)
									if stat and stat.type == "directory" then
										self.icon, self.color = "", require("nvim-web-devicons").get_default_icon().color
									else
										self.icon, self.color = require("nvim-web-devicons").get_icon_color(
											vim.fn.fnamemodify(name, ":t"),
											vim.fn.fnamemodify(name, ":e")
										)
										if self.icon == nil then
											self.icon, self.color = "", require("nvim-web-devicons").get_default_icon().color
										end
									end
								end,
								{
									provider = function(self)
										return " " .. self.icon
									end,
									hl = function(self)
										return { fg = self.color, bold = false }
									end,
								},
							},
							{
								init = function(self)
									local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buffer), ":~:.")

									local separator = package.config:sub(1, 1)
									local ellipsis = "…"

									local components = vim.split(path, separator)

									local child = { flexible = 50 }

									child[1] = {
										{ provider = " " },
										{
											provider = table.concat(components, separator, 1, #components - 1)
												.. (#components > 1 and separator or ""),
											hl = { fg = hl_utils.get_highlight("TabLine").fg, bold = false },
										},
										{
											provider = components[#components],
										},
										{ provider = " " },
									}
									for i = 2, #components do
										child[i] = {
											{ provider = " " },
											{
												provider = ellipsis
													.. separator
													.. table.concat(components, separator, i, #components - 1)
													.. (#components > i and separator or ""),
												hl = { fg = hl_utils.get_highlight("TabLine").fg, bold = false },
											},
											{
												provider = components[#components],
											},
											{ provider = " " },
										}
									end
									child[#components + 1] = nil

									self[1] = self:new(child, 2)
								end,
							},
							(function()
								local diagnostics = {
									flexible = 60,
									init = function(self)
										self.error_count = #vim.diagnostic.get(self.buffer, { severity = vim.diagnostic.severity.ERROR })
										self.warning_count = #vim.diagnostic.get(self.buffer, { severity = vim.diagnostic.severity.WARN })
										self.information_count =
											#vim.diagnostic.get(self.buffer, { severity = vim.diagnostic.severity.INFO })
										self.hint_count = #vim.diagnostic.get(self.buffer, { severity = vim.diagnostic.severity.HINT })
									end,
									condition = function(self)
										return not self.is_active and #vim.diagnostic.get(self.buffer) ~= 0
									end,
									update = { "DiagnosticChanged", "BufEnter" },
								}

								local components = {
									{
										provider = function(self)
											return " " .. self.error_count .. " "
										end,
										hl = "DiagnosticError",
										condition = function(self)
											return self.error_count ~= 0
										end,
									},
									{
										provider = function(self)
											return " " .. self.warning_count .. " "
										end,
										hl = "DiagnosticWarn",
										condition = function(self)
											return self.warning_count ~= 0
										end,
									},
									{
										provider = function(self)
											return " " .. self.information_count .. " "
										end,
										hl = "DiagnosticInfo",
										condition = function(self)
											return self.information_count ~= 0
										end,
									},
									{
										provider = function(self)
											return "󰌵 " .. self.hint_count .. " "
										end,
										hl = "DiagnosticHint",
										condition = function(self)
											return self.hint_count ~= 0
										end,
									},
								}

								diagnostics[#components + 1] = { provider = "" }
								for i = #components, 1, -1 do
									diagnostics[i] = { components[i], (table.unpack or unpack)(diagnostics[i + 1]) }
								end

								return diagnostics
							end)(),
							{
								{
									provider = "●",
									hl = function()
										return {
											fg = hl_utils.get_highlight("DiagnosticOk").fg,
											bold = false,
										}
									end,
									on_click = {
										callback = function(_, buffer)
											vim.schedule(function()
												if vim.api.nvim_buf_is_valid(buffer) then
													vim.api.nvim_buf_call(buffer, vim.cmd.write)
												end
												vim.cmd.redrawtabline()
											end)
										end,
										minwid = function(self)
											return self.buffer
										end,
										name = "heirline_buffer_write_callback",
									},
								},
								{ provider = " " },
								condition = function(self)
									return vim.api.nvim_get_option_value("modified", { buf = self.buffer })
								end,
							},
							{
								provider = " ",
								hl = function()
									return {
										fg = hl_utils.get_highlight("DiagnosticWarn").fg,
										bold = false,
									}
								end,
								condition = function(self)
									return not vim.api.nvim_get_option_value("modifiable", { buf = self.buffer })
										or vim.api.nvim_get_option_value("readonly", { buf = self.buffer })
								end,
							},
							{
								{
									provider = "",
									on_click = {
										callback = function(_, buffer)
											vim.schedule(function()
												if vim.api.nvim_buf_is_valid(buffer) then
													Snacks.bufdelete(buffer)
												end
												vim.cmd.redrawtabline()
											end)
										end,
										minwid = function(self)
											return self.buffer
										end,
										name = "heirline_buffer_close_callback",
									},
								},
								{ provider = " " },
								condition = function(self)
									return not vim.api.nvim_get_option_value("modified", { buf = self.buffer })
								end,
							},
							{
								provider = "",
								hl = function(self)
									return {
										fg = hl_utils.get_highlight(self.is_active and "TabLineSel" or "TabLine").bg,
										bg = hl_utils.get_highlight("TabLineFill").bg,
									}
								end,
							},
							hl = function(self)
								return self.is_active and "TabLineSel" or "TabLine"
							end,
							on_click = {
								callback = function(_, buffer, _, button)
									if button == "l" then
										vim.api.nvim_win_set_buf(0, buffer)
									elseif button == "m" then
										vim.schedule(function()
											if vim.api.nvim_buf_is_valid(buffer) then
												Snacks.bufdelete(buffer)
											end
											vim.cmd.redrawtabline()
										end)
									end
								end,
								minwid = function(self)
									return self.buffer
								end,
								name = "heirline_buffer_callback",
							},
						},
					},
					init = function(self)
						self.buffers = vim.tbl_filter(function(buffer)
							return vim.api.nvim_buf_is_valid(buffer) and vim.api.nvim_get_option_value("buflisted", { buf = buffer })
						end, vim.api.nvim_list_bufs())

						for index, buffer in ipairs(self.buffers) do
							local child = self[index]
							if not (child and child.buffer == buffer) then
								self[index] = self:new(self.buffer, index)
								child = self[index]
								child.buffer = buffer
							end

							if buffer == tonumber(vim.g.actual_curbuf) and LazyVim.in_focus then
								child.is_active = true
							else
								child.is_active = false
							end
						end
						if #self > #self.buffers then
							for index = #self.buffers + 1, #self do
								self[index] = nil
							end
						end
					end,
				},
				{
					provider = "  ",
					on_click = {
						callback = function(_, _, _, button)
							if button == "l" then
								vim.cmd.enew()
							end
						end,
						name = "heirline_buffer_new_callback",
					},
					hl = function()
						return {
							fg = hl_utils.get_highlight("DiagnosticOk").fg,
							bold = true,
						}
					end,
				},
			}
			table.insert(tabline, buffers)

			local statuscolumn = {
				init = function(self)
					self.cursor_line = vim.api.nvim_win_get_cursor(0)[1]

					self.mode = vim.fn.mode()

					self.visual_range = nil
					if
						self.mode:sub(1, 1):lower() == "v"
						or self.mode:sub(1, 1) == "\22"
						or self.mode:sub(1, 1):lower() == "s"
						or self.mode:sub(1, 1) == "\19"
					then
						local visual_line = vim.fn.line("v")

						self.visual_range = self.cursor_line > visual_line and { visual_line, self.cursor_line }
							or { self.cursor_line, visual_line }
					end
				end,
				{
					hl = function(self)
						if self.visual_range and self.visual_range[1] <= vim.v.lnum and vim.v.lnum <= self.visual_range[2] then
							if
								self.mode:sub(1, 1) == "V"
								or self.mode:sub(1, 1) == "S"
								or ((self.mode:sub(1, 1) == "v" or self.mode:sub(1, 1) == "s") and vim.v.lnum ~= self.visual_range[1])
							then
								if vim.v.lnum == self.cursor_line then
									return { bg = "surface0" }
								else
									return { fg = "subtext0", bg = "surface0" }
								end
							else
								if vim.v.lnum ~= self.cursor_line then
									return { fg = "subtext0", bg = "mantle" }
								end
							end
						end

						if vim.v.lnum == self.cursor_line then
							if vim.opt.cursorline:get() then
								return "LineNr"
							else
								return "LineNrNC"
							end
						elseif vim.v.lnum > self.cursor_line then
							return "LineNrBelow"
						elseif vim.v.lnum < self.cursor_line then
							return "LineNrAbove"
						end
					end,
					condition = function()
						return vim.v.virtnum == 0
					end,
				},
				{
					provider = "%=",
					hl = function(self)
						if self.visual_range and self.visual_range[1] <= vim.v.lnum and vim.v.lnum < self.visual_range[2] then
							if self.mode:sub(1, 1) ~= "\22" and self.mode:sub(1, 1) ~= "\19" then
								return { bg = "surface0" }
							end
						end

						if vim.v.lnum >= self.cursor_line then
							return "LineNrBelow"
						else
							return "LineNrAbove"
						end
					end,
					condition = function()
						return vim.v.virtnum ~= 0
					end,
				},
				condition = function(self)
					if vim.opt.buftype:get() == "help" then
						return false
					end

					if vim.opt.signcolumn:get():match("yes") then
						self.signcolumn = true
					elseif vim.opt.signcolumn:get():match("no") then
						self.signcolumn = false
					else
						local signs = vim.fn.sign_getplaced(0, { group = "*" })
						for _, sign in ipairs(signs) do
							self.signcolumn = false
							if #sign.signs > 0 then
								self.signcolumn = true
								break
							end
						end
					end

					return vim.opt.number:get() or self.signcolumn
				end,
			}

			local signcolumn = {
				init = function(self)
					local extmarks = vim.api.nvim_buf_get_extmarks(
						0,
						-1,
						{ vim.v.lnum - 1, 0 },
						{ vim.v.lnum - 1, -1 },
						{ details = true, type = "sign" }
					)

					self.sign = nil
					for _, extmark in pairs(extmarks) do
						local sign = extmark[4]
						if
							sign.sign_text
							and not sign.sign_hl_group:match("^Dap")
							and (not self.sign or (self.sign.priority < sign.priority))
						then
							self.sign = sign
						end
					end
				end,
				provider = function(self)
					return self.sign and self.sign.sign_text or "  "
				end,
				hl = function(self)
					return self.sign and { fg = vim.api.nvim_get_hl(0, { name = self.sign.sign_hl_group }).fg }
				end,
				condition = function(self)
					return self.signcolumn
				end,
			}
			table.insert(statuscolumn[1], signcolumn)

			local numbercolumn = {
				init = function(self)
					local extmarks = vim.api.nvim_buf_get_extmarks(
						0,
						-1,
						{ vim.v.lnum - 1, 0 },
						{ vim.v.lnum - 1, -1 },
						{ details = true, type = "sign" }
					)

					self.sign = nil
					for _, extmark in pairs(extmarks) do
						local sign = extmark[4]
						if
							sign.sign_text
							and sign.sign_hl_group:match("^Dap")
							and (not self.sign or (self.sign.priority < sign.priority))
						then
							self.sign = sign
						end
					end
				end,
				provider = function(self)
					if self.sign then
						return "%=" .. self.sign.sign_text
					elseif vim.opt.relativenumber:get() and vim.v.relnum ~= 0 then
						return "%=" .. tostring(vim.v.relnum) .. " "
					else
						return "%=" .. tostring(vim.v.lnum) .. " "
					end
				end,
				hl = function(self)
					return self.sign and { fg = vim.api.nvim_get_hl(0, { name = self.sign.sign_hl_group }).fg }
				end,
				on_click = {
					callback = function()
						if LazyVim.has("nvim-dap") then
							vim.cmd(tostring(vim.fn.getmousepos().line))

							require("dap").toggle_breakpoint()
						end
					end,
					name = "heirline_toggle_breakpoint",
				},
				condition = function()
					return vim.opt.number:get() or vim.opt.relativenumber:get()
				end,
			}
			table.insert(statuscolumn[1], numbercolumn)

			local ffi = require("ffi")

			ffi.cdef([[
				// https://github.com/neovim/neovim/blob/b8135a76b71f1af0d708e3dc58ccb58abad59f7c/src/nvim/types_defs.h#L58
				typedef struct window_S win_T;

				// https://github.com/neovim/neovim/blob/b8135a76b71f1af0d708e3dc58ccb58abad59f7c/src/nvim/types_defs.h#L16
				typedef int handle_T;

				// https://github.com/neovim/neovim/blob/b8135a76b71f1af0d708e3dc58ccb58abad59f7c/src/nvim/api/private/defs.h#L14
				// https://github.com/neovim/neovim/blob/b8135a76b71f1af0d708e3dc58ccb58abad59f7c/src/nvim/api/private/defs.h#L84C1-L84C21
				typedef handle_T Window;

				// https://github.com/neovim/neovim/blob/b8135a76b71f1af0d708e3dc58ccb58abad59f7c/src/nvim/api/private/defs.h#L28
				typedef enum {
					kErrorTypeNone = -1,
					kErrorTypeException,
					kErrorTypeValidation,
				} ErrorType;

				// https://github.com/neovim/neovim/blob/b8135a76b71f1af0d708e3dc58ccb58abad59f7c/src/nvim/api/private/defs.h#L63
				typedef struct {
					ErrorType type;
					char *msg;
				} Error;

				// https://github.com/neovim/neovim/blob/b8135a76b71f1af0d708e3dc58ccb58abad59f7c/src/nvim/api/private/helpers.c#L316
				win_T *find_window_by_handle(Window window, Error *err);

				// https://github.com/neovim/neovim/blob/b8135a76b71f1af0d708e3dc58ccb58abad59f7c/src/nvim/pos_defs.h#L6
				typedef int32_t linenr_T;

				// https://github.com/neovim/neovim/blob/b8135a76b71f1af0d708e3dc58ccb58abad59f7c/src/nvim/fold_defs.h#L7
				typedef struct {
					linenr_T fi_lnum; 	///< line number where fold starts
					int fi_level;		///< level of the fold; when this is zero the
										///< other fields are invalid
					int fi_low_level;	///< lowest fold level that starts in the same line
					linenr_T fi_lines;
				} foldinfo_T;

				// https://github.com/neovim/neovim/blob/b8135a76b71f1af0d708e3dc58ccb58abad59f7c/src/nvim/fold.c#L308
				foldinfo_T fold_info(win_T *win, linenr_T lnum);
		  ]])

			local foldcolumn = {
				static = {
					is_fold_start = function(handle, line)
						local window = ffi.C.find_window_by_handle(handle, ffi.new("Error"))
						local fold_info = ffi.C.fold_info(window, line)
						return line == fold_info.fi_lnum
					end,
					fold_open_icon = vim.opt.fillchars:get().foldopen,
					fold_closed_icon = vim.opt.fillchars:get().foldclose,
				},
				provider = function(self)
					---@diagnostic disable-next-line: undefined-field
					if self.is_fold_start(0, vim.v.lnum) then
						if vim.fn.foldclosed(vim.v.lnum) == -1 then
							return self.fold_open_icon .. " "
						else
							return self.fold_closed_icon .. " "
						end
					else
						return "  "
					end
				end,
				on_click = {
					callback = function(self, minwid)
						local line = vim.fn.getmousepos().line

						---@diagnostic disable-next-line: undefined-field
						if not self.is_fold_start(minwid, line) then
							return
						end

						if tonumber(vim.fn.win_execute(minwid, ("noautocmd echo foldclosed(%d)"):format(line))) == -1 then
							vim.fn.win_execute(minwid, ("noautocmd %dfoldclose"):format(line))
						else
							vim.fn.win_execute(minwid, ("noautocmd %dfoldopen"):format(line))
						end
					end,
					name = "heirline_fold_callback",
					minwid = function()
						return vim.api.nvim_get_current_win()
					end,
				},
				condition = function()
					return vim.opt.foldcolumn:get() ~= "0"
				end,
			}
			table.insert(statuscolumn[1], foldcolumn)

			return {
				opts = {
					colors = vim.g.colors_name
							and vim.g.colors_name:match("catppuccin")
							and require("catppuccin.palettes").get_palette()
						or nil,
				},
				statusline = statusline,
				tabline = tabline,
				statuscolumn = statuscolumn,
			}
		end,
		config = function(_, opts)
			vim.opt.laststatus = 3
			vim.opt.showtabline = 2
			vim.opt.foldcolumn = "auto"
			vim.opt.showcmdloc = "statusline"

			require("heirline").setup(opts)

			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = function()
					if not vim.g.colors_name:match("catppuccin") then
						return
					end

					require("heirline.utils").on_colorscheme(require("catppuccin.palettes").get_palette())
				end,
			})
		end,
	},
}
