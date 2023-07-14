return {
	{
		"akinsho/toggleterm.nvim",
		opts = {
			size = 10,
			highlights = {
				NormalFloat = { link = "NormalFloat" },
				FloatBorder = { link = "FloatBorder" },
			},
			shade_terminals = false,
			direction = "float",
			float_opts = {
				border = "rounded",
				width = function()
					return vim.opt.columns:get() - 2 * math.floor(math.min(vim.opt.lines:get(), vim.opt.columns:get()) * 1 / 4)
				end,
				height = function()
					return vim.opt.lines:get() - math.floor(math.min(vim.opt.lines:get(), vim.opt.columns:get()) * 1 / 4)
				end,
				winblend = vim.opt.winblend:get(),
			},
		},
		cmd = "ToggleTerm",
		keys = { { "<leader>t", "<cmd>ToggleTerm dir=%:p:h<cr>", desc = "terminal" } },
	},
}
