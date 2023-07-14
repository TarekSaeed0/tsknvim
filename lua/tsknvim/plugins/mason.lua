return {
	{
		"williamboman/mason.nvim",
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
