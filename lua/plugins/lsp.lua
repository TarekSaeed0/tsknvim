return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			diagnostics = {
				float = { border = "rounded" },
			},
			servers = {
				clangd = { mason = false },
				rust_analyzer = { mason = false },
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
	{
		"Civitasv/cmake-tools.nvim",
		opts = {
			cmake_build_directory = "build",
			cmake_virtual_text_support = false,
		},
	},
}
