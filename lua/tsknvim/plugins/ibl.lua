return {
	{
		"lukas-reineke/indent-blankline.nvim",
		opts = {
			indent = { char = "▏" },
			scope = { show_start = false },
		},
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
