return {
	{
		"nvim-treesitter/nvim-treesitter",
		---@module "nvim-treesitter"
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = {
			ensure_installed = {
				"doxygen",
			},
		},
	},
}
