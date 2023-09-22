return {
	{
		"stevearc/dressing.nvim",
		init = function()
			local select = vim.ui.select
			local input = vim.ui.input
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				vim.ui.select = select
				vim.ui.input = input
				require("dressing")
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				vim.ui.select = select
				vim.ui.input = input
				require("dressing")
				return vim.ui.input(...)
			end
		end,
		opts = { select = { telescope = { layout_strategy = "fit" } } },
	},
}
