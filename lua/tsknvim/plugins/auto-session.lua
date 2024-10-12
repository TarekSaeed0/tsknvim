---@type LazySpec[]
return {
	{
		"rmagatti/auto-session",
		enabled = false,
		lazy = false,
		dependencies = { "nvim-telescope/telescope.nvim" },
		opts = {
			bypass_save_filetypes = { "alpha" },
		},
		config = function(_, opts)
			vim.opt.sessionoptions = {
				"blank",
				"buffers",
				"curdir",
				"folds",
				"help",
				"tabpages",
				"winsize",
				"winpos",
				"terminal",
				"localoptions",
			}

			require("auto-session").setup(opts)
		end,
		cmd = {
			"SessionSave",
			"SessionRestore",
			"SessionDelete",
			"SessionDisableAutoSave",
			"SessionToggleAutoSave",
			"SessionSearch",
			"Autosession",
		},
		keys = {
			{ "<leader>ss", "<cmd>SessionSearch<cr>", desc = "Sessions" },
			{ "<leader>sS", "<cmd>SessionSave<cr>", desc = "Save session" },
			{ "<leader>st", "<cmd>SessionToggleAutoSave<cr>", desc = "Toggle session autosave" },
		},
	},
}
