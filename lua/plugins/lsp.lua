return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			diagnostics = {
				float = { border = "rounded" },
			},
			servers = {
				rust_analyzer = { mason = false },
				vhdl_ls = {},
			},
		},
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		priority = 1000,
		opts = {
			signs = {
				arrow = "",
				up_arrow = " ",
			},
			hi = { background = "Normal" },
			options = {
				multiple_diag_under_cursor = true,
				multilines = true,
				show_all_diags_on_cursorline = true,
			},
		},
		config = function(_, opts)
			vim.diagnostic.config({ virtual_text = false })

			require("tiny-inline-diagnostic").setup(opts)
		end,
		event = "VeryLazy",
	},
}
