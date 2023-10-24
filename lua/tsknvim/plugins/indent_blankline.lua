return {
	{
		"lukas-reineke/indent-blankline.nvim",
		opts = {
			indent = { char = "▏" },
			scope = { enabled = false },
		},
		config = function(_ , opts)
			require("ibl").setup(opts)

			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
		end,
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		cmd = {
			"IBLEnable",
			"IBLDisable",
			"IBLToggle",
			"IBLEnableScope",
			"IBLDisableScope",
			"IBLToggleScope",
		}
	},
}
