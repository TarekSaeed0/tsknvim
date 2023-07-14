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
					NormalNC = { fg = colors.overlay0 },
					NormalFloat = { link = "FloatNormal" },
					FloatNormal = { fg = colors.text, bg = colors.mantle },
					FloatNormalNC = { fg = colors.overlay0, bg = colors.mantle },
					FloatBorder = { fg = colors.overlay0, bg = colors.mantle },
					FloatTitle = { fg = colors.mantle, bg = colors.blue, bold = true },
					StatusLine = { fg = colors.overlay0 },
					TabLine = { fg = colors.overlay0 },
					TabLineSel = { fg = colors.text, bg = colors.base, bold = true },
					TabLineFill = { fg = colors.overlay0, bg = colors.mantle },
					MsgArea = { bg = colors.mantle },
					VertSplit = { link = "NormalNC" },
					SignColumn = { bg = colors.mantle },
					LineNr = { fg = colors.text, bg = colors.mantle, bold = true },
					LineNrAbove = { fg = colors.overlay0, bg = colors.mantle },
					LineNrBelow = { fg = colors.overlay0, bg = colors.mantle },
					Folded = { bg = colors.surface0 },
					DiagnosticSignError = { bg = colors.mantle },
					DiagnosticSignWarn = { bg = colors.mantle },
					DiagnosticSignInfo = { bg = colors.mantle },
					DiagnosticSignHint = { bg = colors.mantle },
					DiagnosticSignOk = { bg = colors.mantle },
					IndentBlanklineChar = { nocombine = true },
					IndentBlanklineContextChar = { nocombine = true },
					CmpItemAbbr = { fg = colors.overlay0 },
					NotifyDEBUGBody = { link = "FloatNormal" },
					NotifyERRORBody = { link = "FloatNormal" },
					NotifyINFOBody = { link = "FloatNormal" },
					NotifyTRACEBody = { link = "FloatNormal" },
					NotifyWARNBody = { link = "FloatNormal" },
					NotifyDEBUGBorder = { link = "FloatBorder" },
					NotifyERRORBorder = { link = "FloatBorder" },
					NotifyINFOBorder = { link = "FloatBorder" },
					NotifyTRACEBorder = { link = "FloatBorder" },
					NotifyWARNBorder = { link = "FloatBorder" },
					TelescopeNormal = { link = "FloatNormal" },
					TelescopeTitle = { link = "FloatTitle" },
					SagaNormal = { link = "FloatNormal" },
					SagaBorder = { link = "FloatBorder" },
					DiagnosticShowBorder = { link = "SagaBorder" },
					FidgetTask = { link = "FloatNormalNC" },
					GitSignsAdd = { bg = colors.mantle },
					GitSignsChange = { bg = colors.mantle },
					GitSignsDelete = { bg = colors.mantle },
					GitSignsChangedelete = { bg = colors.mantle },
					GitSignsTopdelete = { bg = colors.mantle },
					GitSignsUntracked = { bg = colors.mantle },
					GitSignsUntrackedNr = { link  = "GitSignsUntracked" },
					GitSignsUntrackedLn = { link  = "GitSignsUntracked" },
				}
			end,
			integrations = {
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

			vim.api.nvim_set_decoration_provider(vim.api.nvim_create_namespace("tsknvim_non_current_floating_windows"), {
				on_start = function()
					local current_window = vim.api.nvim_get_current_win()
					for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
						local config = vim.api.nvim_win_get_config(window)
						if config and (config.external or config.relative ~= "") then
							local highlights = {}
							for highlight_from, highlight_to in vim.api.nvim_win_get_option(window, "winhighlight"):gmatch("([^,]+):([^,]+)") do
								highlights[highlight_from] = highlight_to
							end

							local highlight = highlights.NormalFloat or highlights.Normal
							if highlight then
								while highlight ~= "FloatNormal" do
									highlight = vim.api.nvim_get_hl(0, { name = highlight }).link
									if not highlight then
										goto skip_window
									end
								end
							end

							highlights.FloatNormal = (window == current_window or config.focusable == false) and "FloatNormal" or "FloatNormalNC"

							vim.api.nvim_win_set_option(window, "winhighlight", table.concat(vim.tbl_map(function(highlight_from)
								return highlight_from..":"..highlights[highlight_from]
							end, vim.tbl_keys(highlights)), ","))
						end
						::skip_window::
					end
				end,
			})

			vim.cmd.colorscheme("catppuccin")
		end,
		priority = 1000,
	},
}
