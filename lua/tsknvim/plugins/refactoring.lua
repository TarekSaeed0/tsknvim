---@type LazySpec[]
return {
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			prompt_func_return_type = {
				go = true,
				cpp = true,
				c = true,
				java = true,
			},
			prompt_func_param_type = {
				go = true,
				cpp = true,
				c = true,
				java = true,
			},
		},
		config = function(_, opts)
			if require("tsknvim.utils").is_loaded("telescope.nvim") then
				require("telescope").setup({ extensions = { refactoring = { prompt_title = "Refactors" } } })
				require("telescope").load_extension("refactoring")
			end

			require("refactoring").setup(opts)
		end,
		event = { "BufReadPre", "BufNewFile" },
		cmd = "Refactor",
		keys = {
			{
				"<leader>rr",
				function()
					require("telescope").extensions.refactoring.refactors()
				end,
				mode = { "n", "x" },
				desc = "Refactors",
			},
		},
	},
}
