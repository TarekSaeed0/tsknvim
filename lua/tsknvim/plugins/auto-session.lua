return {
	{
		"rmagatti/auto-session",
		lazy = false,
		dependencies = { "nvim-telescope/telescope.nvim" },
		opts = {
			session_lens = {
				theme_conf = {
					layout_strategy = "fit",
					layout_config = {
						width = 0.8,
						height = 0.9,
					},
				},
			},
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
	},
}
