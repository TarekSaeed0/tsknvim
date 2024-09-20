if vim.fn.executable("rustc") ~= 1 then
	return {}
end

---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		ft = "rust",
	},
	{
		"williamboman/mason-lspconfig.nvim",
		---@type MasonLspconfigSettings
		opts = { ensure_installed = { "rust_analyzer" } },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = { ensure_installed = { "rust" } },
		ft = "rust",
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
				rust = { "rustfmt" },
			},
		},
	},
}
