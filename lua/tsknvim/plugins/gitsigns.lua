---@type LazySpec[]
return {
	{
		"lewis6991/gitsigns.nvim",
		enabled = vim.fn.executable("git") == 1,
		---@type Gitsigns.Config
		---@diagnostic disable: missing-fields
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "▎" },
				topdelete = { text = "▎" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			preview_config = { border = "rounded" },
		},
		---@diagnostic enable: missing-fields
		event = { "BufReadPre", "BufNewFile" },
	},
}
