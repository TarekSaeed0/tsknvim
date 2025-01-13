return {
	{
		"mfussenegger/nvim-lint",
		dependencies = {
			"williamboman/mason.nvim",
			optional = true,
			opts = { ensure_installed = { "luacheck" } },
		},
		opts = {
			linters_by_ft = {
				lua = { "luacheck" },
			},
		},
	},
}
