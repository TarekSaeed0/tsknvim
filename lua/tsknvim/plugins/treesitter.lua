return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			highlight = {
				enable = true,
				disable = function(language, buffer)
					return (language == "c" or language == "cpp") and vim.api.nvim_buf_line_count(buffer) > 5000
				end,
			},
			indent = { enable = true },
			incremental_selection = { enable = true },
			ensure_installed = {
				"bash",
				"c",
				"cmake",
				"cpp",
				"css",
				"html",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"rust",
				"toml",
			},
		},
		config = function(_, opts)
			if vim.fn.has("win32") == 1 then
				require("nvim-treesitter.install").prefer_git = false
			end

			require("nvim-treesitter.configs").setup(opts)
		end,
		build = ":TSUpdate",
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
		ft = {
			"c",
			"cmake",
			"cpp",
			"css",
			"html",
			"lua",
			"markdown",
			"python",
			"rust",
			"sh",
			"toml",
		},
	},
}
