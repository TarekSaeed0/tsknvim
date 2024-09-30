---@type LazySpec[]
return {
	{
		"danymat/neogen",
		opts = {
			snippet_engine = "nvim",
		},
		cmd = "Neogen",
		keys = {
			{
				"<leader>ga",
				function()
					require("neogen").generate()
				end,
				desc = "Generate Annotations",
			},
		},
	},
}
