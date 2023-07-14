return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = { enable = true },
			ensure_installed = { "bash", "c", "cmake", "cpp", "lua", "markdown", "markdown_inline", "python" },
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		cmd = {
			"TSInstall",
			"TSInstallSync",
			"TSInstallInfo",
			"TSUpdate",
			"TSUpdateSync",
			"TSUninstall",
			"TSBufEnable",
			"TSBufDisable",
			"TSBufToggle",
			"TSEnable",
			"TSDisable",
			"TSToggle",
			"TSModuleInfo",
			"TSEditQuery",
			"TSEditQueryUserAfter",
		},
	},
}
