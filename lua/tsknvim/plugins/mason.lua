---@type LazySpec[]
return {
	{
		"williamboman/mason.nvim",
		---@type MasonSettings
		opts = { ui = { border = "rounded" } },
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
