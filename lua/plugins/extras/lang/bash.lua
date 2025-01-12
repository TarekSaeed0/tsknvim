return {
	recommended = function()
		return LazyVim.extras.wants({
			ft = "sh",
		})
	end,
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "bash" } },
	},
	{
		"stevearc/conform.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			optional = true,
			opts = { ensure_installed = { "shfmt" } },
		},
		opts = {
			formatters_by_ft = {
				sh = { "shfmt" },
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		dependencies = {
			"williamboman/mason.nvim",
			optional = true,
			opts = { ensure_installed = { "shellcheck" } },
		},
		opts = {
			linters_by_ft = {
				sh = { "shellcheck" },
			},
		},
	},
}
