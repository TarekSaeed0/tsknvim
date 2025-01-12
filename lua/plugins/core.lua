return {
	{
		"LazyVim/LazyVim",
		---@class LazyVimOptions
		opts = {
			colorscheme = "catppuccin",
			icons = {
				diagnostics = {
					Hint = "󰌵 ",
				},
			},
		},
		config = function(_, opts)
			require("lazyvim.config")

			LazyVim.extras.sources = {
				{
					name = "LazyVim",
					desc = "LazyVim extras",
					module = "lazyvim.plugins.extras",
				},
				{
					name = "User",
					desc = "User extras",
					module = "plugins.extras",
				},
			}

			require("lazyvim").setup(opts)
		end,
	},
}
