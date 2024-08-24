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
					html = { ccc.picker.css_name },
					css = { ccc.picker.css_name },
					javascript = { ccc.picker.css_name },
					lua = {
						ccc.picker.custom_entries(require("catppuccin.palettes").get_palette()),
					},
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
		config = function(_, opts)
			local ccc = require("ccc")

			ccc.setup(opts)

			--- HACK: allow additional pickers per filetype
			require("ccc.config").options.pickers = nil
			setmetatable(require("ccc.config").options, {
				__index = function(t, k)
					if k == "pickers" then
						local filetype = vim.opt.filetype:get()
						if opts.pickers[filetype] then
							local pickers = {}
							for _, picker in ipairs(opts.pickers) do
								table.insert(pickers, picker)
							end
							for _, picker in ipairs(opts.pickers[filetype]) do
								table.insert(pickers, picker)
							end
							return pickers
						else
							return opts.pickers
						end
					end
					return t[k]
				end,
			})
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
