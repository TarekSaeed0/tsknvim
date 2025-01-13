return {
	{
		import = "lazyvim.plugins.extras.lang.cmake",
		enabled = function()
			return vim.fn.executable("cmake") == 1
		end,
	},
	{
		import = "plugins.extras.lang.flutter",
		enabled = function()
			return vim.fn.executable("flutter") == 1
		end,
	},
	{
		import = "plugins.extras.lang.git",
		enabled = function()
			return vim.fn.executable("git") == 1
		end,
	},
	{
		import = "lazyvim.plugins.extras.lang.java",
		enabled = function()
			return vim.fn.executable("java") == 1
		end,
	},
	{
		import = "lazyvim.plugins.extras.lang.python",
		enabled = function()
			return vim.fn.executable("python") == 1
		end,
	},
	{
		import = "lazyvim.plugins.extras.lang.rust",
		enabled = function()
			return vim.fn.executable("rustc") == 1
		end,
	},
	{
		import = "lazyvim.plugins.extras.lang.r",
		enabled = function()
			return vim.fn.executable("R") == 1
		end,
	},
	{
		import = "lazyvim.plugins.extras.lang.tex",
		enabled = function()
			return vim.fn.executable("latexmk") == 1
		end,
	},
}
