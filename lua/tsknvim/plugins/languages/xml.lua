---@type LazySpec[]
return {
	{
		"nvim-treesitter/nvim-treesitter",
		---@module "nvim-treesitter"
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
