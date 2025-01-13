return {
	{
		"mfussenegger/nvim-lint",
		dependencies = {
			"williamboman/mason.nvim",
			optional = true,
			opts = { ensure_installed = { "gitlint", "luacheck" } },
		},
		opts = {
			linters_by_ft = {
				c = { "clangtidy" },
				cpp = { "clangtidy" },
				gitcommit = { "gitlint" },
				lua = { "luacheck" },
			},
		},
	},
}
