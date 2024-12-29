---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		ft = "toml",
	},
	{
		"williamboman/mason-lspconfig.nvim",
		---@module "mason-lspconfig"
		---@type MasonLspconfigSettings
		opts = { ensure_installed = { "taplo" } },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		---@module "nvim-treesitter"
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = { ensure_installed = { "toml" } },
		ft = "toml",
	},
	{

		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				toml = { "taplo" },
			},
		},
	},
}
