if vim.fn.executable("flutter") ~= 1 then
	return {}
end

---@type LazySpec[]
return {
	{
		"nvim-treesitter/nvim-treesitter",
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = { ensure_installed = { "dart" } },
		ft = "dart",
	},
	{
		"akinsho/flutter-tools.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim",
		},
		opts = {
			ui = { border = "rounded" },
			decorations = {
				statusline = {
					app_version = true,
					device = true,
				},
			},
			closing_tags = { highlight = "LspInlayHint" },
			dev_log = { enabled = false },
			debugger = { enabled = true },
			lsp = {
				color = {
					enabled = true,
					virtual_text_str = "●",
				},
				on_attach = require("tsknvim.utils").lsp.on_attach,
				capabilities = function(config)
					return vim.tbl_deep_extend("force", {}, config, require("cmp_nvim_lsp").default_capabilities())
				end,
			},
		},
		config = function(_, opts)
			if require("tsknvim.utils").is_loaded("telescope.nvim") then
				require("telescope").setup({ extensions = { notify = { prompt_title = "Flutter Commands" } } })
				require("telescope").load_extension("flutter")
			end

			require("flutter-tools").setup(opts)
		end,
	},
}
