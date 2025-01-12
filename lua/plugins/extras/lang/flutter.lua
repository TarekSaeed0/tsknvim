return {
	recommended = function()
		return LazyVim.extras.wants({
			ft = "dart",
			root = { "pubspec.yaml" },
		})
	end,
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				dartls = {
					mason = false,
					keys = {
						{ "<localleader>f", "<cmd>Telescope flutter commands<cr>", desc = "Flutter Commands" },
					},
				},
			},
			setup = {
				dartls = function()
					return true
				end,
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "dart" } },
	},
	{
		"akinsho/flutter-tools.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim",
		},
		opts = {
			ui = { border = "rounded" },
			decorations = {
				statusline = {
					app_version = true,
					device = true,
				},
			},
			closing_tags = { highlight = "LspInlayHint" },
			dev_log = { enabled = false },
			debugger = { enabled = true },
			lsp = {
				color = {
					enabled = true,
					virtual_text_str = "󱓻",
				},
			},
			on_attach = require("lazyvim.plugins.lsp.keymaps").on_attach,
			capabilities = function(config)
				local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
				local has_blink, blink = pcall(require, "blink.cmp")

				return vim.tbl_deep_extend(
					"force",
					{},
					config,
					has_cmp and cmp_nvim_lsp.default_capabilities() or {},
					has_blink and blink.get_lsp_capabilities() or {}
				)
			end,
		},
		config = function(_, opts)
			if LazyVim.has("telescope.nvim") then
				require("telescope").setup({ extensions = { flutter = { prompt_title = "Flutter Commands" } } })
				require("telescope").load_extension("flutter")
			end

			require("flutter-tools").setup(opts)
		end,
	},
}
