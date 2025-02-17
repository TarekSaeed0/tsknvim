if vim.fn.executable("python") ~= 1 then
	return {}
end

---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		ft = "python",
	},
	{
		"williamboman/mason-lspconfig.nvim",
		---@module "mason-lspconfig"
		---@type MasonLspconfigSettings
		opts = { ensure_installed = { "pyright" } },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		---@module "nvim-treesitter"
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = { ensure_installed = { "python" } },
		ft = "python",
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		opts = { ensure_installed = { "python" } },
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				python = { "isort", "black" },
			},
		},
	},
}
