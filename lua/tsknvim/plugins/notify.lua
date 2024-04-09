return {
	{
		"rcarriga/nvim-notify",
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.notify = function(...)
				vim.notify = require("notify")
				return vim.notify(...)
			end
		end,
		opts = {
			max_width = function()
				return math.floor(vim.opt.columns:get() / 2)
			end,
			max_height = function()
				return math.floor(vim.opt.lines:get() / 2)
			end,
			stages = "slide",
			render = "compact",
		},
		config = function(_, opts)
			if require("tsknvim.utils").is_loaded("telescope.nvim") then
				require("telescope").setup({ extensions = { notify = { prompt_title = "notifications" } } })
				require("telescope").load_extension("notify")
			end

			require("notify").setup(opts)
		end,
		cmd = "Notifications",
		keys = {
			{

				"<leader>n",
				function()
					require("telescope").extensions.notify.notify()
				end,
				desc = "Notifications",
			},
		},
	},
}
