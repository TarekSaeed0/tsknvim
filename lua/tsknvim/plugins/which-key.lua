return {
	{
		"folke/which-key.nvim",
		opts = {
			preset = "modern",
			delay = vim.opt.timeoutlen:get(),
			win = {
				border = "rounded",
				wo = {
					winblend = vim.opt.winblend:get(),
					winhighlight = "NormalFloat:NormalFloatNC",
				},
			},
		},
		config = function(_, opts)
			vim.opt.timeoutlen = 100

			require("which-key").setup(opts)
		end,
		event = "VeryLazy",
		cmd = "WhichKey",
	},
}
