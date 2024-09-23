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
			{ "<leader>r", "", desc = "+refactor", mode = { "n", "x" } },
			{
				"<leader>rs",
				function()
					require("telescope").extensions.refactoring.refactors(require("telescope.themes").get_cursor({
						layout_config = { width = 40 },
					}))
				end,
				mode = { "n", "x" },
				desc = "Select Refactor",
			},
			{
				"<leader>rf",
				function()
					require("refactoring").refactor("Extract Function")
				end,
				mode = "x",
				desc = "Extract Function",
			},
			{
				"<leader>rF",
				function()
					require("refactoring").refactor("Extract Function To File")
				end,
				mode = "x",
				desc = "Extract Function To File",
			},
			{
				"<leader>rv",
				function()
					require("refactoring").refactor("Extract Variable")
				end,
				mode = "x",
				desc = "Extract Variable",
			},
			{
				"<leader>rI",
				function()
					require("refactoring").refactor("Inline Function")
				end,
				desc = "Inline Function",
			},
			{
				"<leader>ri",
				function()
					require("refactoring").refactor("Inline Variable")
				end,
				mode = { "n", "x" },
				desc = "Inline Variable",
			},
			{
				"<leader>rb",
				function()
					require("refactoring").refactor("Extract Block")
				end,
				desc = "Extract Block",
			},
			{
				"<leader>rB",
				function()
					require("refactoring").refactor("Extract Block To File")
				end,
				desc = "Extract Block To File",
			},
			{
				"<leader>rP",
				function()
					require("refactoring").debug.printf({ below = false })
				end,
				desc = "Debug Print",
			},
			{
				"<leader>rp",
				function()
					require("refactoring").debug.print_var({})
				end,
				mode = { "n", "x" },
				desc = "Debug Print Variable",
			},
			{
				"<leader>rc",
				function()
					require("refactoring").debug.cleanup({})
				end,
				desc = "Debug Cleanup",
			},
		},
	},
}
