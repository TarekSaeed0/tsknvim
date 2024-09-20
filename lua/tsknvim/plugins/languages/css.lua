---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		ft = "css",
	},
	{
		"williamboman/mason-lspconfig.nvim",
		---@type MasonLspconfigSettings
		opts = { ensure_installed = { "cssls" } },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = { ensure_installed = { "css" } },
		ft = "css",
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				css = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},
}
