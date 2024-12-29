if vim.fn.executable("git") ~= 1 then
	return {}
end

---@type LazySpec[]
return {
	{
		"nvim-treesitter/nvim-treesitter",
		---@module "nvim-treesitter"
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = {
			ensure_installed = {
				"git_config",
				"gitcommit",
				"git_rebase",
				"gitignore",
				"gitattributes",
			},
		},
		ft = {
			"gitcommit",
			"gitconfig",
			"gitrebase",
			"gitignore",
			"gitattributes",
		},
	},
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				gitcommit = { "gitlint" },
			},
		},
	},
}
