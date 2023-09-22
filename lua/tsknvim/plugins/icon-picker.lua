return {
	{
		"ziontee113/icon-picker.nvim",
		dependencies = {
			{
				"stevearc/dressing.nvim",
				opts = { select = { telescope = { layout_strategy = "fit" } } },
			},
		},
		opts = { disable_legacy_commands = true },
		cmd = {
			"IconPickerNormal",
			"IconPickerInsert",
			"IconPickerYank",
		},
	},
}
