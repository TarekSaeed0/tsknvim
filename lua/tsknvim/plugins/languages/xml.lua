---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		ft = "xml",
	},
	{
		"williamboman/mason-lspconfig.nvim",
		---@type MasonLspconfigSettings
		opts = { ensure_installed = { "lemminx" } },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = { ensure_installed = { "xml" } },
		ft = "xml",
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				xml = { "xmlformat" },
			},
			formatters = {
				xmlformat = {
					prepend_args = { "--indent", "1", "--indent-char", "\t" },
				},
			},
		},
	},
}
