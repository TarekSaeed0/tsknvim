---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		ft = { "cmake" },
	},
	{
		"williamboman/mason-lspconfig.nvim",
		---@type MasonLspconfigSettings
		opts = { ensure_installed = { "cmake" } },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = { ensure_installed = { "cmake" } },
		ft = { "cmake" },
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				cmake = { "cmake_format" },
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		opts = {
			formatters_by_ft = {
				cmake = { "cmakelint" },
			},
		},
	},
}
