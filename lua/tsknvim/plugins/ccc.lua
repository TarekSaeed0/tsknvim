---@type LazySpec[]
return {
	{
		"uga-rosa/ccc.nvim",
		opts = function(self)
			local ccc = require("ccc")

			return {
				point_char = "▒",
				pickers = {
					ccc.picker.hex,
					ccc.picker.css_rgb,
					ccc.picker.css_hsl,
					ccc.picker.css_hwb,
					ccc.picker.css_lab,
					ccc.picker.css_lch,
					ccc.picker.css_oklab,
					ccc.picker.css_oklch,
					ccc.picker.css_name,
				},
				highlight_mode = "virtual",
				lsp = false,
				highlighter = {
					auto_enable = true,
					filetypes = self.ft,
					lsp = false,
				},
				recognize = {
					input = true,
					output = true,
				},
				mappings = {
					["<Esc>"] = ccc.mapping.quit,
					["<Right>"] = ccc.mapping.increase1,
					["<S-Right>"] = ccc.mapping.increase10,
					["<Left>"] = ccc.mapping.decrease1,
					["<S-Left>"] = ccc.mapping.decrease10,
				},
			}
		end,
		keys = { { "<M-c>", "<cmd>CccPick<cr>", desc = "Color Picker" } },
		cmd = {
			"CccPick",
			"CccConvert",
			"CccHighlighterEnable",
			"CccHighlighterDisable",
			"CccHighlighterToggle",
		},
		ft = {
			"html",
			"css",
			"javascript",
			"lua",
			"tmux",
		},
	},
}
