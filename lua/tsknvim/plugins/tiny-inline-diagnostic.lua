return {
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		priority = 1000,
		opts = {
			signs = {
				arrow = "  ",
				up_arrow = " ",
			},
			hi = { background = "Normal" },
			options = {
				multiple_diag_under_cursor = true,
				multilines = true,
				show_all_diags_on_cursorline = true,
			},
		},
		event = "VeryLazy",
	},
}
