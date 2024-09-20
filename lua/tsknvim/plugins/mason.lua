---@type LazySpec[]
return {
	{
		"williamboman/mason.nvim",
		---@type MasonSettings
		opts = { ui = { border = "rounded", height = 0.8 } },
		cmd = {
			"Mason",
			"MasonUpdate",
			"MasonInstall",
			"MasonUninstall",
			"MasonUninstallAll",
			"MasonLog",
		},
	},
}
