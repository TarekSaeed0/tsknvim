---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		ft = "cpp",
	},
	{
		"williamboman/mason-lspconfig.nvim",
		---@type MasonLspconfigSettings
		opts = { ensure_installed = { "clangd" } },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = { ensure_installed = { "cpp" } },
		ft = "cpp",
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		---@type MasonNvimDapSettings
		---@diagnostic disable-next-line: missing-fields
		opts = { ensure_installed = { "codelldb" } },
	},
	{

		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				cpp = { "clang-format" },
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				cpp = { "clangtidy" },
			},
		},
	},
}
