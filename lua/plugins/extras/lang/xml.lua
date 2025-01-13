return {
	recommended = function()
		return LazyVim.extras.wants({
			ft = "xml",
		})
	end,
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "xml" } },
	},
	{
		"stevearc/conform.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			optional = true,
			opts = { ensure_installed = { "xmlformatter" } },
		},
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
