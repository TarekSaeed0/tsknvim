---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		ft = { "lua" },
	},
	{
		"williamboman/mason-lspconfig.nvim",
		---@type MasonLspconfigSettings
		opts = { ensure_installed = { "lua_ls" } },
	},
	{
		"folke/lazydev.nvim",
		opts = {
			library = {
				"lazy.nvim",
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
		cmd = "LazyDev",
		ft = "lua",
	},
	{
		"hrsh7th/nvim-cmp",
		---@param opts cmp.ConfigSchema
		opts = { sources = { { name = "lazydev", group_index = 0 } } },
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		"nvim-treesitter/nvim-treesitter",
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = { ensure_installed = { "lua" } },
		ft = { "lua" },
	},
	{

		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				lua = { "luacheck" },
			},
		},
	},
}
