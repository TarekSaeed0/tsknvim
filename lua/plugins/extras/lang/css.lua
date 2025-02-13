return {
	recommended = function()
		return LazyVim.extras.wants({
			ft = "css",
		})
	end,
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				cssls = {},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "css" } },
	},
	{
		"conform.nvim",
		opts = function(_, opts)
			if LazyVim.has_extra("formatting.prettier") then
				opts.formatters_by_ft = opts.formatters_by_ft or {}
				opts.formatters_by_ft.css = { "prettier" }
			end
		end,
	},
}
