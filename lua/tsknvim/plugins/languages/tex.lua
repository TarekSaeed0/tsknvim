if vim.fn.executable("latexmk") ~= 1 then
	return {}
end

---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		ft = "tex",
	},
	{
		"williamboman/mason-lspconfig.nvim",
		---@module "mason-lspconfig"
		---@type MasonLspconfigSettings
		opts = {
			ensure_installed = { "texlab" },
			handlers = {
				texlab = function(name)
					local capabilities = vim.tbl_deep_extend(
						"force",
						{},
						vim.lsp.protocol.make_client_capabilities(),
						require("cmp_nvim_lsp").default_capabilities()
					)

					--[[ local capabilities =
						require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()) ]]

					require("lspconfig")[name].setup({
						on_attach = require("tsknvim.utils").lsp.tsknvim,
						capabilities = capabilities,
						keys = {
							{ "<leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
						},
					})
				end,
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		---@module "nvim-treesitter"
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = {
			ensure_installed = { "bibtex" },
			highlight = { disable = { "latex" } },
		},
		ft = "tex",
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				tex = { "latexindent" },
			},
			formatters = {
				latexindent = {
					args = { "-l", "-" },
				},
			},
		},
	},
	{
		"lervag/vimtex",
		lazy = false,
		config = function()
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_mappings_disable = { ["n"] = { "K" } }
			vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
			vim.g.vimtex_format_enabled = 1
			vim.g.vimtex_quickfix_enabled = 0
		end,
		keys = {
			{ "<localleader>l", "", desc = "+vimtex", ft = "tex" },
		},
	},
}
