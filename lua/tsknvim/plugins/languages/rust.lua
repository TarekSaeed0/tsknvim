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
		opts = { ensure_installed = { "rust_analyzer" } },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "rust" } },
		ft = "rust",
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
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
