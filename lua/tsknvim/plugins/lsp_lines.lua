return {
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			require("lsp_lines").setup()

			vim.diagnostic.config({ virtual_lines = { highlight_whole_line = false } })
			vim.diagnostic.config({ virtual_lines = false }, vim.api.nvim_create_namespace("lazy"))
		end,
		event = { "BufReadPost", "BufNewFile" },
	}
}
