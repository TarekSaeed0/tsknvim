---@type LazySpec[]
return {
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		---@type TodoOptions
		opts = { keywords = {
			NOTE = { icon = " ", color = "info" },
			PERF = { icon = " " },
		} },
		---@param opts TodoOptions
		config = function(_, opts)
			require("todo-comments").setup(opts)

			vim.defer_fn(function()
				for keyword, _ in pairs(require("todo-comments.config").options.keywords) do
					vim.fn.sign_define("todo-sign-" .. keyword, { numhl = "TodoSign" .. keyword })
				end
			end, 0)
		end,
		event = { "BufReadPost", "BufNewFile" },
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next todo comment",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous todo comment",
			},
		},
	},
}
