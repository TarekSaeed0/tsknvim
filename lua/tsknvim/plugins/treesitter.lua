---@type LazySpec[]
return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = { "windwp/nvim-ts-autotag" },
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = {
			highlight = {
				enable = true,
				disable = function(language, buffer)
					return (language == "c" or language == "cpp") and vim.api.nvim_buf_line_count(buffer) > 5000
				end,
			},
			indent = { enable = true },
			incremental_selection = {
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					-- https://stackoverflow.com/questions/16359878/how-to-map-shift-enter/42461580#42461580
					scope_incremental = "<C-cr>",
					node_decremental = "<C-bs>",
				},
				enable = true,
			},
			ensure_installed = {
				"json",
				"jsonc",
				"regex",
				"toml",
				"vim",
				"vimdoc",
				"yaml",
			},
		},
		---@param opts TSConfig
		config = function(_, opts)
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
			"json",
			"toml",
			"vim",
			"vimdoc",
			"yaml",
		},
	},
}
