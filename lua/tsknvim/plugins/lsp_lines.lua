---@type LazySpec[]
return {
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		lazy = true,
		init = function()
			vim.api.nvim_create_autocmd("DiagnosticChanged", {
				callback = function(args)
					if #args.data.diagnostics ~= 0 then
						require("lazy.core.loader").load({ "lsp_lines.nvim" }, { event = "DiagnosticChanged" })
						return true
					end
				end,
			})
		end,
		config = function()
			require("lsp_lines").setup()

			vim.diagnostic.config({ virtual_lines = { highlight_whole_line = false } })
			vim.diagnostic.config({ virtual_lines = false }, vim.api.nvim_create_namespace("lazy"))
		end,
	},
}
