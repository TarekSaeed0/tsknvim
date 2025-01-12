-- HACK: diagnostic floating windows not dimming correctly
local open_float = vim.diagnostic.open_float
---@diagnostic disable-next-line: duplicate-set-field
vim.diagnostic.open_float = function(opts)
	local float_bufnr, win_id = open_float(opts)
	vim.api.nvim_set_option_value("winhighlight", "NormalFloat:NormalFloat", { win = win_id })
	return float_bufnr, win_id
end

return {
	{
		"folke/tokyonight.nvim",
		enabled = false,
	},
	{
		"catppuccin",
		optional = true,
		---@module "catppuccin"
		---@type CatppuccinOptions
		opts = {
			custom_highlights = function(colors)
				return {
					Normal = { link = "NormalC" },
					NormalC = { fg = colors.text, bg = colors.base },
					NormalNC = { fg = colors.overlay0, bg = colors.mantle },

					NormalFloat = { link = "NormalFloatC" },
					NormalFloatC = { fg = colors.text, bg = colors.base },
					NormalFloatNC = { fg = colors.overlay0, bg = colors.mantle },

					FloatBorder = { fg = colors.overlay0, bg = colors.mantle },
					FloatTitle = { fg = colors.mantle, bg = colors.mauve, bold = true },

					WinSeparator = { fg = colors.overlay0, bg = colors.mantle },
					MsgSeparator = { link = "WinSeparator" },

					LineNr = { link = "LineNrC" },
					LineNrC = { fg = colors.text, bg = colors.base, bold = true },
					LineNrNC = { fg = colors.overlay0, bg = colors.mantle },
					LineNrAbove = { fg = colors.overlay0, bg = colors.mantle },
					LineNrBelow = { fg = colors.overlay0, bg = colors.mantle },

					SignColumn = { bg = colors.mantle },

					StatusLine = { fg = colors.overlay0 },

					TabLine = { fg = colors.overlay0, bg = colors.mantle },
					TabLineSel = { fg = colors.text, bg = colors.base, bold = true },
					TabLineFill = { fg = colors.overlay0 },

					WinBar = { bg = colors.mantle },

					Pmenu = { link = "NormalFloat" },

					LspInlayHint = { bg = "NONE" },

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

					SnacksNormalC = { fg = colors.text, bg = colors.base },
					SnacksNormalNC = { fg = colors.overlay0, bg = colors.mantle },
					SnacksNotifierError = { link = "NormalFloatNC" },
					SnacksNotifierWarn = { link = "NormalFloatNC" },
					SnacksNotifierInfo = { link = "NormalFloatNC" },
					SnacksNotifierDebug = { link = "NormalFloatNC" },
					SnacksNotifierTrace = { link = "NormalFloatNC" },
					SnacksNotifierBorderError = { link = "FloatBorder" },
					SnacksNotifierBorderWarn = { link = "FloatBorder" },
					SnacksNotifierBorderInfo = { link = "FloatBorder" },
					SnacksNotifierBorderDebug = { link = "FloatBorder" },
					SnacksNotifierBorderTrace = { link = "FloatBorder" },
					SnacksNotifierTitleError = { fg = colors.mantle, bg = colors.red, bold = true },
					SnacksNotifierTitleWarn = { fg = colors.mantle, bg = colors.yellow, bold = true },
					SnacksNotifierTitleInfo = { fg = colors.mantle, bg = colors.mauve, bold = true },
					SnacksNotifierTitleDebug = { fg = colors.mantle, bg = colors.peach, bold = true },
					SnacksNotifierTitleTrace = { fg = colors.mantle, bg = colors.rosewater, bold = true },
					SnacksNotifierFooterError = { link = "SnacksNotifierTitleError" },
					SnacksNotifierFooterWarn = { link = "SnacksNotifierTitleWarn" },
					SnacksNotifierFooterInfo = { link = "SnacksNotifierTitleInfo" },
					SnacksNotifierFooterDebug = { link = "SnacksNotifierTitleDebug" },
					SnacksNotifierFooterTrace = { link = "SnacksNotifierTitleTrace" },
					SnacksIndentScope = { fg = colors.text },
					SnacksDashboardHeader = { fg = colors.teal },
					SnacksDashboardIcon = { fg = colors.mauve },
					SnacksDashboardDesc = { fg = colors.text },
					SnacksDashboardKey = { fg = colors.mauve },
					SnacksDashboardFooter = { fg = colors.mauve },
					SnacksDashboardSpecial = { fg = colors.teal },

					NoiceCmdlinePopup = { link = "MsgArea" },
					NoiceCmdlinePopupBorder = { link = "FloatBorder" },
					NoiceCmdlinePopupBorderSearch = { link = "NoiceCmdlinePopupBorder" },

					NeoTreeNormal = { bg = colors.base },
					NeoTreeWinSeparator = { link = "WinSeparator" },
					NeoTreeDirectoryName = { fg = colors.teal },
					NeoTreeDirectoryIcon = { fg = colors.teal },
					NeoTreeRootName = { fg = colors.teal },
					NeoTreeModified = { fg = colors.green },
					NeoTreeDotfile = { link = "Comment" },

					TelescopeNormal = { fg = colors.text, bg = colors.base },
					TelescopeTitle = { link = "FloatTitle" },
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

					LazyProgressDone = { fg = colors.sapphire },
					LazyProgressTodo = { fg = colors.mantle },

					MasonHeader = { link = "FloatTitle" },
					MasonHighlightBlockBold = { bg = colors.sapphire, bold = true },

					UfoFoldedEllipsis = { fg = colors.overlay0, bg = "NONE" },
				}
			end,
		},
	},
}
