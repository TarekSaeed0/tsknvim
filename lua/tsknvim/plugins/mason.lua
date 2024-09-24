---@type LazySpec[]
return {
	{
		"williamboman/mason.nvim",
		---@type MasonSettings
		opts = { ui = { border = "rounded", height = 0.8 } },
		config = function(_, opts)
			require("mason").setup(opts)

			local function resize(window)
				local width = vim.opt.columns:get()
					- 2 * math.floor(math.min(vim.opt.lines:get(), vim.opt.columns:get() / 2) / 4)
				local height = vim.opt.lines:get()
					- math.floor(math.min(vim.opt.lines:get(), vim.opt.columns:get() / 2) / 4)

				vim.api.nvim_win_set_config(window, {
					relative = "editor",
					row = math.floor((vim.o.lines - height) / 2) - 1,
					col = math.floor((vim.o.columns - width) / 2) - 1,
					width = width,
					height = height,
				})
			end

			local window
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "mason",
				callback = function()
					window = vim.api.nvim_get_current_win()
					resize(window)
				end,
			})
			vim.api.nvim_create_autocmd("WinResized", {
				callback = function()
					if window and vim.api.nvim_win_is_valid(window) and window == vim.api.nvim_get_current_win() then
						resize(window)
					end
				end,
			})
		end,
		cmd = {
			"Mason",
			"MasonUpdate",
			"MasonInstall",
			"MasonUninstall",
			"MasonUninstallAll",
			"MasonLog",
		},
	},
}
