return {
	{
		"ibhagwan/fzf-lua",
		opts = {
			winopts = {
				backdrop = 100,
			},
		},
	},
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
}
