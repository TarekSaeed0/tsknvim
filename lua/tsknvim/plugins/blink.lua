---@type LazySpec[]
return {
	{
		"saghen/blink.cmp",
		enabled = false,
		dependencies = "rafamadriz/friendly-snippets",
		version = "*",
		---@module "blink.cmp"
		---@type blink.cmp.Config
		opts = {
			keymap = { preset = "super-tab" },
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
			},
			completion = {
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},
				menu = {
					draw = {
						treesitter = { "lsp" },
					},
					border = "rounded",
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = { border = "rounded" },
				},
				ghost_text = {
					enabled = true,
				},
			},
			signature = {
				window = { border = "rounded" },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		},
		opts_extend = { "sources.default" },
	},
	{
		"saghen/blink.cmp",
		optional = true,
		dependencies = { "codeium.nvim", "saghen/blink.compat" },
		---@type blink.cmp.Config
		opts = {
			sources = {
				providers = {
					codeium = {
						name = "Codeium",
						module = "blink.compat.source",
						score_offset = 100,
						async = true,
					},
				},
			},
		},
	},
	{
		"catppuccin/nvim",
		optional = true,
		---@module "catppuccin"
		---@type CatppuccinOptions
		opts = {
			integrations = { blink_cmp = true },
		},
	},
}
