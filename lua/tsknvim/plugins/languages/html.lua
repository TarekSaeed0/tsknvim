---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		ft = "html",
	},
	{
		"williamboman/mason-lspconfig.nvim",
		---@type MasonLspconfigSettings
		opts = { ensure_installed = { "html" } },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = { ensure_installed = { "html" } },
		ft = "html",
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				html = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},
}
