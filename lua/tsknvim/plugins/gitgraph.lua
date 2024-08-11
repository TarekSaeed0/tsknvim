return {
	{
		"isakbm/gitgraph.nvim",
		config = true,
		keys = {
			{
				"<leader>gg",
				function()
					require("gitgraph").draw({}, { all = true, max_count = 5000 })
				end,
				desc = "Git Graph",
			},
		},
	},
}
