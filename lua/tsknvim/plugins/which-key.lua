return {
	{
		"folke/which-key.nvim",
		opts = { window = { border = "rounded", winblend = vim.opt.winblend:get() } },
		config = function(_, opts)
			vim.opt.timeoutlen = 500

			require("which-key").setup(opts)
		end,
		event = "VeryLazy",
		cmd = "WhichKey",
	},
}
