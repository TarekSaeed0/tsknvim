---@type LazySpec[]
return {
	{
		"folke/noice.nvim",
		enabled = not require("tsknvim.utils").is_performance(),
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		opts = {
			messages = { view_search = false },
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				progress = { enabled = false },
				signature = { enabled = false },
			},
			presets = {
				long_message_to_split = true,
				lsp_doc_border = false,
			},
		},
		config = function(_, opts)
			if vim.opt.filetype:get() == "lazy" then
				vim.cmd([[messages clear]])
			end

			require("noice").setup(opts)
		end,
		event = "VeryLazy",
	},
}
