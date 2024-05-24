return {
	{
		"David-Kunz/gen.nvim",
		enabled = vim.fn.executable("ollama") == 1,
		opts = {
			model = "codegemma:2b-code",
		},
	},
}
