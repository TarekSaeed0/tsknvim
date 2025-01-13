return {
	recommended = {
		ft = { "gitcommit", "gitconfig", "gitrebase", "gitignore", "gitattributes" },
	},
	{ import = "lazyvim.plugins.extras.lang.git" },
	{
		"mfussenegger/nvim-lint",
		dependencies = {
			"williamboman/mason.nvim",
			optional = true,
			opts = { ensure_installed = { "gitlint" } },
		},
		opts = {
			linters_by_ft = {
				gitcommit = { "gitlint" },
			},
		},
	},
}
