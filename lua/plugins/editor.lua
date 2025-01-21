return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		opts = {
			default_component_configs = {
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "",
				},
				modified = {
					symbol = "●",
				},
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			worktrees = {
				{
					toplevel = vim.env.HOME,
					gitdir = vim.env.HOME .. "/.dotfiles",
				},
			},
			preview_config = { border = "rounded" },
		},
	},
	{
		"tpope/vim-abolish",
	},
}
