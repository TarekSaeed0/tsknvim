---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		ft = "sh",
	},
	{
		"williamboman/mason-lspconfig.nvim",
		---@type MasonLspconfigSettings
		opts = { ensure_installed = { "bashls" } },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = { ensure_installed = { "bash" } },
		ft = "sh",
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				sh = { "shfmt" },
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				sh = { "shellcheck" },
			},
		},
	},
}
