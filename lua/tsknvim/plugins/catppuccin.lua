---@type LazySpec[]
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		---@type CatppuccinOptions
		---@diagnostic disable-next-line: missing-fields
		opts = {
			flavour = "mocha",
			dim_inactive = { enabled = true, percentage = 0 },
			no_italic = true,
			custom_highlights = function(colors)
				return {
					Normal = { link = "NormalC" },
					NormalC = { fg = colors.text, bg = colors.base },
					NormalNC = { fg = colors.overlay0 },
					NormalFloat = {
						link = require("tsknvim.utils").is_performance() and "NormalFloatNC" or "NormalFloatC",
					},
					NormalFloatC = { fg = colors.text, bg = colors.base },
					NormalFloatNC = { fg = colors.overlay0, bg = colors.mantle },
					FloatBorder = { fg = colors.overlay0, bg = colors.mantle },
					FloatTitle = { fg = colors.mantle, bg = colors.mauve, bold = true },
					StatusLine = { fg = colors.overlay0 },
					TabLine = { fg = colors.overlay0, bg = colors.mantle },
					TabLineSel = { fg = colors.text, bg = colors.base, bold = true },
					TabLineFill = { fg = colors.overlay0, bg = colors.mantle },
					WinBar = { bg = colors.mantle },
					WinSeparator = { link = "NormalNC" },
					MsgArea = { bg = colors.mantle },
					MsgSeparator = { link = "WinSeparator" },
					SignColumn = { bg = colors.mantle },
					LineNr = { link = "LineNrC" },
					LineNrC = { fg = colors.text, bg = colors.mantle, bold = true },
					LineNrNC = { fg = colors.overlay0, bg = colors.mantle },
					LineNrAbove = { link = "LineNrNC" },
					LineNrBelow = { link = "LineNrNC" },
					Folded = { bg = colors.surface0 },
					UfoFoldedEllipsis = { fg = colors.overlay0, bg = "NONE" },
					CmpItemAbbr = { fg = colors.overlay0 },
					TelescopeNormal = { fg = colors.text, bg = colors.base },
					TelescopeTitle = { link = "FloatTitle" },
					SagaNormal = { link = "NormalFloat" },
					SagaBorder = { link = "FloatBorder" },
					DiagnosticShowBorder = { link = "SagaBorder" },
					FidgetTask = { link = "NormalFloat" },
					FidgetTitle = { fg = colors.mauve },
					GitSignsUntrackedNr = { link = "GitSignsUntracked" },
					GitSignsUntrackedLn = { link = "GitSignsUntracked" },
					DapBreakpoint = { fg = colors.red },
					DapBreakpointCondition = { fg = colors.yellow },
					DapLogPoint = { fg = colors.sky },
					DapStopped = { fg = colors.maroon },
					DapBreakPointRejected = { fg = colors.red },
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
					AlphaHeader = { fg = colors.teal },
					AlphaShortcut = { fg = colors.mauve },
					AlphaSegment1 = { fg = colors.mauve },
					AlphaSegment2 = { fg = colors.mantle, bg = colors.mauve },
					AlphaSegment3 = { link = "NormalNC" },
					AlphaSegment4 = { fg = colors.mantle },
					WhichKeyDesc = { fg = colors.mauve, bg = colors.mantle },
					WhichKeyGroup = { fg = colors.teal, bg = colors.mantle },
					LazyNormal = { link = "NormalFloatC" },
					LazyProgressDone = { fg = colors.sapphire },
					LazyProgressTodo = { fg = colors.mantle },
					Directory = { fg = colors.teal },
					DevIconDefault = { fg = colors.teal },
					TelescopePreviewDate = { fg = colors.sky },
					TelescopePreviewUser = { fg = colors.mauve },
					TelescopePreviewGroup = { fg = colors.mauve },
					TelescopePreviewDirectory = { fg = colors.teal },
					TelescopePreviewRead = { fg = colors.sky },
					TelescopePreviewWrite = { fg = colors.sapphire },
					TelescopePreviewExecute = { fg = colors.mauve },
					TelescopePromptPrefix = { fg = colors.teal },
					TelescopeSelectionCaret = { fg = colors.teal },
					TelescopeMatching = { fg = colors.pink, bold = true },
					LspInlayHint = { bg = "NONE" },
					MasonNormal = { link = "NormalFloatC" },
					MasonHeader = { link = "FloatTitle" },
					MasonHighlightBlockBold = { bg = colors.sapphire, bold = true },
					GitGraphHash = { fg = colors.red },
					GitGraphTimestamp = { fg = colors.mauve },
					GitGraphAuthor = { fg = colors.sky },
					GitGraphBranchName = { fg = colors.peach },
					GitGraphBranchTag = { fg = colors.yellow },
					GitGraphBranchMsg = { fg = colors.green },
					GitGraphBranch1 = { fg = colors.sky },
					GitGraphBranch2 = { fg = colors.red },
					GitGraphBranch3 = { fg = colors.yellow },
					GitGraphBranch4 = { fg = colors.mauve },
					GitGraphBranch5 = { fg = colors.peach },
					NoiceCmdlinePopup = { link = "MsgArea" },
					NoiceCmdlinePopupBorder = { link = "FloatBorder" },
					NoiceCmdlinePopupBorderSearch = { link = "NoiceCmdlinePopupBorder" },
					NoiceCmdlineIcon = { fg = colors.teal },
					Pmenu = { link = "NormalFloatNC" },
				}
			end,
			integrations = {
				fidget = true,
				lsp_saga = true,
				mason = true,
				noice = true,
				notify = true,
				which_key = true,
			},
			compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
		},
		---@param opts CatppuccinOptions
		config = function(_, opts)
			require("catppuccin").setup(opts)

			local utils = require("tsknvim.utils")

			if not utils.is_performance() then
				vim.defer_fn(function()
					vim.api.nvim_set_decoration_provider(
						vim.api.nvim_create_namespace("tsknvim_highlight_non_current_floating_windows"),
						{
							on_start = function()
								local current_window = vim.api.nvim_get_current_win()
								for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
									local highlights = {}
									for highlight_from, highlight_to in
										vim.api
											.nvim_get_option_value("winhighlight", { win = window })
											:gmatch("([^,]+):([^,]+)")
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

										highlights.NormalFloat = (window == current_window and utils.in_focus)
												and "NormalFloatC"
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

										highlights.Normal = (window == current_window and utils.in_focus) and "NormalC"
											or "NormalNC"
									end

									highlights.LineNr = (window == current_window and utils.in_focus) and "LineNrC"
										or "LineNrNC"
									if vim.api.nvim_get_option_value("number", { win = window }) then
										vim.api.nvim_set_option_value(
											"relativenumber",
											(window == current_window and utils.in_focus),
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
			end

			vim.cmd.colorscheme("catppuccin")
		end,
		priority = 1000,
	},
}
