return {
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				c = { "clangtidy" },
				cpp = { "clangtidy" },
				gitcommit = { "gitlint" },
				lua = { "luacheck" },
				sh = { "shellcheck" },
			},
		},
	},
}
