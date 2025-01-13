return {
	recommended = function()
		return LazyVim.extras.wants({
			ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
			root = {
				".clangd",
				".clang-tidy",
				".clang-format",
				"compile_commands.json",
				"compile_flags.txt",
				"configure.ac", -- AutoTools
			},
		})
	end,
	{ import = "lazyvim.plugins.extras.lang.clangd" },
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				clangd = { mason = false },
			},
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				c = { "clang-format" },
				cpp = { "clang-format" },
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				c = { "clangtidy" },
				cpp = { "clangtidy" },
			},
		},
	},
	{
		"Civitasv/cmake-tools.nvim",
		opts = {
			cmake_build_directory = "build",
			cmake_virtual_text_support = false,
		},
	},
}
