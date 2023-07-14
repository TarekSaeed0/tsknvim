return {
	{
		"lukas-reineke/indent-blankline.nvim",
		opts = {
			char = "▏",
			show_first_indent_level = false,
			filetype_exclude = { "help", "terminal", "lazy" }
		},
		event = { "BufReadPost", "BufNewFile" },
		cmd = {
			"IndentBlanklineRefresh",
			"IndentBlanklineRefreshScroll",
			"IndentBlanklineEnable",
			"IndentBlanklineDisable",
			"IndentBlanklineToggle",
		}
	},
}
