---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		ft = { "json", "jsonc" },
	},
	{
		"williamboman/mason-lspconfig.nvim",
		---@type MasonLspconfigSettings
		opts = { ensure_installed = { "jsonls" } },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = { ensure_installed = { "json", "jsonc" } },
		ft = { "json", "jsonc" },
	},
	{

		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				json = { "prettierd", "prettier", stop_after_first = true },
				jsonc = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},
}
