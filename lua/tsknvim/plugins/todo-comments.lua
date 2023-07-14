return {
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { keywords = {
			NOTE = { icon = " ", color = "info" },
			PERF = { icon = " " },
		} },
		config = function(_, opts)
			require("todo-comments").setup(opts)

			vim.defer_fn(function()
				for keyword, _ in pairs(require("todo-comments.config").options.keywords) do
					vim.fn.sign_define("todo-sign-"..keyword, { numhl = "TodoSign"..keyword })
				end
			end, 0)
		end,
		event = { "BufReadPost", "BufNewFile" },
	},
}
