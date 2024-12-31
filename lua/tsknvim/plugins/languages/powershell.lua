---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		ft = "ps1",
	},
	{
		"williamboman/mason-lspconfig.nvim",
		---@module "mason-lspconfig"
		---@type MasonLspconfigSettings
		opts = { ensure_installed = { "powershell_es" } },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		---@module "nvim-treesitter"
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = { ensure_installed = { "powershell" } },
		ft = "ps1",
	},
}
