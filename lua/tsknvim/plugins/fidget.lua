return {
	{
		"j-hui/fidget.nvim",
		opts = {
			text = {
				spinner = "arc",
				done = "",
			},
			window = {
				relative = "editor",
				blend = vim.opt.winblend:get(),
				border = "rounded",
			},
		},
		tag = "legacy",
		event = "LspAttach",
		cmd = "FidgetClose",
	},
}
