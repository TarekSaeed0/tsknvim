return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			flavour = "mocha",
			dim_inactive = { enabled = true, percentage = 0 },
			no_italic = true,
			custom_highlights = function(colors)
				return {
					Normal = { link = "NormalC" },
					NormalC = { fg = colors.text, bg = colors.base },
					NormalNC = { fg = colors.overlay0 },
					NormalFloat = { link = "NormalFloatC" },
					NormalFloatC = { fg = colors.text, bg = colors.base },
					NormalFloatNC = { fg = colors.overlay0, bg = colors.mantle },
					FloatBorder = { fg = colors.overlay0, bg = colors.mantle },
					FloatTitle = { fg = colors.mantle, bg = colors.blue, bold = true },
					StatusLine = { fg = colors.overlay0 },
					TabLine = { fg = colors.overlay0 },
					TabLineSel = { fg = colors.text, bg = colors.base, bold = true },
					TabLineFill = { fg = colors.overlay0, bg = colors.mantle },
					WinBar = { bg = colors.mantle },
					MsgArea = { bg = colors.mantle },
					VertSplit = { link = "NormalNC" },
					SignColumn = { bg = colors.mantle },
					LineNr = { fg = colors.text, bg = colors.mantle, bold = true },
					LineNrAbove = { fg = colors.overlay0, bg = colors.mantle },
					LineNrBelow = { fg = colors.overlay0, bg = colors.mantle },
					Folded = { bg = colors.surface0 },
					UfoFoldedEllipsis = { fg = colors.overlay0, bg = "NONE" },
					DiagnosticSignError = { bg = colors.mantle },
					DiagnosticSignWarn = { bg = colors.mantle },
					DiagnosticSignInfo = { bg = colors.mantle },
					DiagnosticSignHint = { bg = colors.mantle },
					DiagnosticSignOk = { bg = colors.mantle },
					IndentBlanklineChar = { nocombine = true },
					IndentBlanklineContextChar = { nocombine = true },
					CmpItemAbbr = { fg = colors.overlay0 },
					NotifyDEBUGBody = { link = "NormalFloat" },
					NotifyERRORBody = { link = "NormalFloat" },
					NotifyINFOBody = { link = "NormalFloat" },
					NotifyTRACEBody = { link = "NormalFloat" },
					NotifyWARNBody = { link = "NormalFloat" },
					NotifyDEBUGBorder = { link = "FloatBorder" },
					NotifyERRORBorder = { link = "FloatBorder" },
					NotifyINFOBorder = { link = "FloatBorder" },
					NotifyTRACEBorder = { link = "FloatBorder" },
					NotifyWARNBorder = { link = "FloatBorder" },
					TelescopeNormal = { fg = colors.text, bg = colors.base },
					TelescopeTitle = { link = "FloatTitle" },
					SagaNormal = { link = "NormalFloat" },
					SagaBorder = { link = "FloatBorder" },
					DiagnosticShowBorder = { link = "SagaBorder" },
					FidgetTask = { link = "NormalFloat" },
					GitSignsAdd = { bg = colors.mantle },
					GitSignsChange = { bg = colors.mantle },
					GitSignsDelete = { bg = colors.mantle },
					GitSignsChangedelete = { bg = colors.mantle },
					GitSignsTopdelete = { bg = colors.mantle },
					GitSignsUntracked = { bg = colors.mantle },
					GitSignsUntrackedNr = { link  = "GitSignsUntracked" },
					GitSignsUntrackedLn = { link  = "GitSignsUntracked" },
					DapBreakpoint = { fg = colors.red, bg = colors.mantle },
					DapBreakpointCondition = { fg = colors.yellow, bg = colors.mantle },
					DapLogPoint = { fg = colors.sky, bg = colors.mantle },
					DapStopped = { fg = colors.maroon, bg = colors.mantle },
					DapBreakPointRejected = { fg = colors.red, bg = colors.mantle },
					DapUIUnavailable = { bg = colors.mantle },
					DapUIUnavailableNC = { link = "DapUIUnavailable" },
					DapUIPlayPause = { bg = colors.mantle },
					DapUIPlayPauseNC = { link = "DapUIPlayPause" },
					DapUIStepInto = { bg = colors.mantle },
					DapUIStepIntoNC = { link = "DapUIStepInto" },
					DapUIStepOver = { bg = colors.mantle },
					DapUIStepOverNc = { link = "DapUIStepOver" },
					DapUIStepOut = { bg = colors.mantle },
					DapUIStepOutNC = { link = "DapUIStepOut" },
					DapUIStepBack = { bg = colors.mantle },
					DapUIStepBackNC = { link = "DapUIStepBack" },
					DapUIRestart = { bg = colors.mantle },
					DapUIRestartNC = { link = "DapUIRestart" },
					DapUIStop = { bg = colors.mantle },
					DapUIStopNC = { link = "DapUIStop" },
					CodeWindowBorder = { link = "FloatBorder" },
				}
			end,
			integrations = {
				dap = {
					enabled = true,
					enable_ui = true,
				},
				fidget = true,
          		lsp_saga = true,
				mason = true,
				notify = true,
				which_key = true
			},
			compile_path = vim.fn.stdpath("cache").."/catppuccin",
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)

			vim.defer_fn(function()
				vim.api.nvim_set_decoration_provider(vim.api.nvim_create_namespace("tsknvim_highlight_non_current_floating_windows"), {
					on_start = function()
						local current_window = vim.api.nvim_get_current_win()
						for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
							local highlights = {}
							for highlight_from, highlight_to in vim.api.nvim_win_get_option(window, "winhighlight"):gmatch("([^,]+):([^,]+)") do
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

								highlights.NormalFloat = window == current_window and "NormalFloatC" or "NormalFloatNC"
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

								highlights.Normal = window == current_window and "NormalC" or "NormalNC"
							end

							vim.api.nvim_win_set_option(window, "winhighlight", table.concat(vim.tbl_map(function(highlight_from)
								return highlight_from..":"..highlights[highlight_from]
							end, vim.tbl_keys(highlights)), ","))

							::skip_window::
						end
					end,
				})
			end, 0)

			vim.cmd.colorscheme("catppuccin")
		end,
		priority = 1000,
	},
}
