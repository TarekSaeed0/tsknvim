if vim.fn.executable("R") ~= 1 then
	return {}
end

---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				r_language_server = {
					root_dir = function(fname)
						return require("lspconfig.util").root_pattern("DESCRIPTION", "NAMESPACE", ".Rbuildignore")(
							fname
						) or require("lspconfig.util").find_git_ancestor(fname) or vim.uv.os_homedir()
					end,
				},
			},
		},
		ft = "r",
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = { "R-nvim/cmp-r" },
		opts = { sources = { { name = "cmp_r" } } },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		---@diagnostic disable-next-line: missing-fields
		opts = { ensure_installed = { "r", "rnoweb" } },
		ft = "r",
	},
	{
		"R-nvim/R.nvim",
		lazy = false,
		opts = {
			R_args = { "--quiet", "--no-save" },
			hook = {
				on_filetype = function()
					vim.keymap.set("n", "<Enter>", "<Plug>RDSendLine", { buffer = true })
					vim.keymap.set("v", "<Enter>", "<Plug>RSendSelection", { buffer = true })

					local which_key = require("which-key")
					which_key.add({
						buffer = true,
						mode = { "n", "v" },
						{ "<localleader>a", group = "all" },
						{ "<localleader>b", group = "between marks" },
						{ "<localleader>c", group = "chunks" },
						{ "<localleader>f", group = "functions" },
						{ "<localleader>g", group = "goto" },
						{ "<localleader>i", group = "install" },
						{ "<localleader>k", group = "knit" },
						{ "<localleader>p", group = "paragraph" },
						{ "<localleader>q", group = "quarto" },
						{ "<localleader>r", group = "r general" },
						{ "<localleader>s", group = "split or send" },
						{ "<localleader>t", group = "terminal" },
						{ "<localleader>v", group = "view" },
					})
				end,
			},
			pdfviewer = "",
		},
		config = function(_, opts)
			vim.g.rout_follow_colorscheme = true

			require("r").setup(opts)

			require("r.pdf.generic").open = vim.ui.open
		end,
		ft = "r",
	},
}
