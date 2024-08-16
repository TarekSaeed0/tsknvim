---@type LazySpec[]
return {
	{
		"lukas-reineke/indent-blankline.nvim",
		---@type ibl.config
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
		},
	},
}
