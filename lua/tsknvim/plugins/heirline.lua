return {
	{
		"rebelot/heirline.nvim",
		opts = function()
			local colors = require("catppuccin.palettes").get_palette()

			local mode = {
				init = function(self)
					self.name = self.names[vim.api.nvim_get_mode().mode]
				end,
				static = {
					names = {
						n = "NORMAL",
						no = "O-PENDING",
						nov = "O-PENDING",
						noV = "O-PENDING",
						["no\22"] = "O-PENDING",
						niI = "NORMAL",
						niR = "NORMAL",
						niV = "NORMAL",
						nt = "NORMAL",
						ntT = "NORMAL",
						v = "VISUAL",
						vs = "VISUAL",
						V = "V-LINE",
						Vs = "V-LINE",
						["\22"] = "V-BLOCK",
						["\22s"] = "V-BLOCK",
						s = "SELECT",
						S = "S-LINE",
						["\19"] = "S-BLOCK",
						i = "INSERT",
						ic = "INSERT",
						ix = "INSERT",
						R = "REPLACE",
						Rc = "REPLACE",
						Rx = "REPLACE",
						Rv = "V-REPLACE",
						Rvc = "V-REPLACE",
						Rvx = "V-REPLACE",
						c = "COMMAND",
						cv = "EX",
						r = "REPLACE",
						rm = "MORE",
						["r?"] = "CONFIRM",
						["!"] = "SHELL",
						t = "TERMINAL",
					},
				},
				{
					provider = "",
					hl = { fg = "blue" },
				},
				{
					provider = function(self)
						return "  "..self.name.." "
					end,
					hl = { fg = "mantle", bg = "blue" },
				},
				{
					provider = "",
					hl = { fg = "blue" },
				},
				hl = { bold = true },
			}

			local cwd = {
				init = function(self)
					self.path = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
					local maximum_length = math.floor(vim.opt.columns:get() / 4)

					if self.path:len() > maximum_length then
						local separator = package.config:sub(1, 1)
						local ellipsis = "…"

						local parent, name = self.path:match("^(.-"..separator.."?)([^"..separator.."]*)$")
						self.path = ellipsis..separator..parent:sub(math.min(0, ellipsis:len() + separator:len() + name:len() - maximum_length)):match("[^"..separator.."]*"..separator.."?(.*)$")..name
					end
				end,
				{
					provider = function(self)
						return "   "..self.path
					end,
				},
			}

			local git = {
				{
					init = function(self)
						---@diagnostic disable-next-line: undefined-field
						self.branch = vim.b.gitsigns_head
					end,
					provider = function(self)
						return "  "..self.branch
					end,
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
							return "  "..self.add_count
						end,
						hl = "GitSignsAdd",
						condition = function(self)
							return self.add_count ~= 0
						end,
					},
					{
						provider = function(self)
							return "  "..self.change_count
						end,
						hl = "GitSignsChange",
						condition = function(self)
							return self.change_count ~= 0
						end,
					},
					{
						provider = function(self)
							return "  "..self.delete_count
						end,
						hl = "GitSignsDelete",
						condition = function(self)
							return self.delete_count ~= 0
						end,
					},
					condition = function()
						---@diagnostic disable-next-line: undefined-field
						return vim.b.gitsigns_status_dict
					end,
				}
			}

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
							return "  "..self.error_count
						end,
						hl = "DiagnosticError",
						condition = function(self)
							return self.error_count ~= 0
						end,
					},
					{
						provider = function(self)
							return "  "..self.warning_count
						end,
						hl = "DiagnosticWarn",
						condition = function(self)
							return self.warning_count ~= 0
						end,
					},
					{
						provider = function(self)
							return "  "..self.information_count
						end,
						hl = "DiagnosticInfo",
						condition = function(self)
							return self.information_count ~= 0
						end,
					},
					{
						provider = function(self)
							return " 󰌵 "..self.hint_count
						end,
						hl = "DiagnosticHint",
						condition = function(self)
							return self.hint_count ~= 0
						end,
					},
					condition = function()
						return #vim.diagnostic.get(0) ~= 0
					end,
					update = { "DiagnosticChanged", "BufEnter" },
				},
				{
					provider  = function()
						local names = {}
						for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
							table.insert(names, server.name)
						end
						return "   "..table.concat(names, " ")
					end,
					condition = function()
						return next(vim.lsp.get_active_clients({ bufnr = 0 })) ~= nil
					end,
					update = { "LspAttach", "LspDetach", "BufEnter" },
				}
			}

			local cursor = {
				{
					provider = " ",
					hl = { fg = "blue" },
				},
				{
					provider = function()
						local line = vim.api.nvim_win_get_cursor(0)[1]
						local lines = vim.api.nvim_buf_line_count(0)

						local column = vim.fn.virtcol(".")
						local columns = vim.fn.virtcol({ line, "$" })

						return ("  %"..tostring(lines):len().."d/%d:%"..tostring(columns):len().."d/%d  %%P "):format(line, lines, column, columns)
					end,
					hl = { fg = "mantle", bg = "blue" },
				},
				{
					provider = "",
					hl = { fg = "blue" },
				},
				hl = { bold = true },
			}

			local statusline = {
				mode, cwd, git, { provider = "%=" }, lsp, cursor,
				hl = "StatusLine",
			}

			local buffers = {
				static = {
					buffer = {
						{
							provider = function(self)
								return self.is_active and "" or " "
							end,
							hl = { fg = "base", bg = "mantle" },
						},
						{
							init = function(self)
								local name = vim.api.nvim_buf_get_name(self.buffer)
								local stat = vim.loop.fs_stat(name)
								if stat and stat.type == "directory" then
									self.icon, self.color = "", require("nvim-web-devicons").get_default_icon().color
								else
									self.icon, self.color = require("nvim-web-devicons").get_icon_color(vim.fn.fnamemodify(name, ":t"), vim.fn.fnamemodify(name, ":e"))
								end
							end,
							{
								provider = function(self)
									return " "..self.icon
								end,
							hl = function(self)
									return { fg = self.color, bold = false }
								end
							},
						},
						{
							init = function(self)
								local maximum_length = math.floor(vim.opt.columns:get() / math.max(#self.buffers, 4)) - 8

								local separator = package.config:sub(1, 1)
								local components = vim.split(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buffer), ":~:."), separator)

								local parent = ""
								local name = components[#components]

								local length = #"…" + #separator + #name
								for i = #components - 1, 1, -1 do
									local component = components[i]

									length = length + #component + #separator
									if length > maximum_length then
										parent = "…"..separator..parent
										break
									end

									parent = component..separator..parent
								end
								if name == "" then
									parent, name = name, parent
								end

								self.parent = parent
								self.name = name
							end,
							{
								provider = function(self)
									return " "..self.parent
								end,
								hl = { fg = "overlay0", bold = false },
							},
							{
								provider = function(self)
									return self.name.." "
								end,
							},
						},
						{
							provider = "● ",
							hl = { fg = "green", bold = false },
							condition = function(self)
								return vim.api.nvim_buf_get_option(self.buffer, "modified")
							end,
						},
						{
							provider = " ",
							hl = { fg = "yellow", bold = false },
							condition = function(self)
								return not vim.api.nvim_buf_get_option(self.buffer, "modifiable") or vim.api.nvim_buf_get_option(self.buffer, "readonly")
							end,
						},
						{
							{
								provider = "",
								on_click = {
									callback = function(_, buffer)
										vim.schedule(function()
											vim.api.nvim_buf_delete(buffer, { force = false })
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
								return not vim.api.nvim_buf_get_option(self.buffer, "modified")
							end,
						},
						{
							provider = function(self)
								return self.is_active and "" or " "
							end,
							hl = { fg = "base", bg = "mantle" },
						},
						hl = function(self)
							return self.is_active and "TabLineSel" or "TabLine"
						end,
						on_click = {
							callback = function(_, buffer, _, button)
								if button == "m" then
									vim.schedule(function()
										vim.api.nvim_buf_delete(buffer, { force = false })
									end)
								else
									vim.api.nvim_win_set_buf(0, buffer)
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
						return vim.api.nvim_buf_is_valid(buffer) and vim.api.nvim_buf_get_option(buffer, "buflisted")
					end, vim.api.nvim_list_bufs())

					for index, buffer in ipairs(self.buffers) do
						local child = self[index]
						if not (child and child.buffer == buffer) then
							self[index] = self:new(self.buffer, index)
							child = self[index]
							child.buffer = buffer
						end

						if buffer == tonumber(vim.g.actual_curbuf) then
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
			}

			local tabline = {
				buffers,
				hl = "TabLineFill",
			}

			return {
				opts = { colors = colors },
				statusline = statusline,
				tabline = tabline,
			}
		end,
		config = function(_, opts)
			vim.opt.laststatus = 3
			vim.opt.showtabline = 2

			require("heirline").setup(opts)
		end,
	},
}
