return {
	recommended = function()
		return LazyVim.extras.wants({
			ft = "html",
		})
	end,
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				html = {},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "html" } },
	},
	{
		"conform.nvim",
		opts = function(_, opts)
			if LazyVim.has_extra("formatting.prettier") then
				opts.formatters_by_ft = opts.formatters_by_ft or {}
				opts.formatters_by_ft.html = { "prettier" }
			end
		end,
	},
}
