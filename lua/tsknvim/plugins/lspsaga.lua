return {
	{
		"glepnir/lspsaga.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			request_timeout = 100,
			lightbulb = { enable = false },
			diagnostic = { border_follow = false },
			outline = { win_width = 25 },
			symbol_in_winbar = { enable = false },
			ui = { title = false, border = "rounded" },
		},
		event = "LspAttach",
		cmd = "Lspsaga",
	},
}
