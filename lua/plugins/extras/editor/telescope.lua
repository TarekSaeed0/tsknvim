return {
	{ import = "lazyvim.plugins.extras.editor.telescope" },
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
		},
		init = function()
			if vim.fn.argc() == 1 then
				---@diagnostic disable-next-line: param-type-mismatch
				local stat = vim.loop.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then
					---@diagnostic disable-next-line: param-type-mismatch
					vim.defer_fn(function()
						require("telescope").extensions.file_browser.file_browser({ cwd = vim.fn.argv(0) })
					end, 0)
				end
			end
		end,
		opts = function()
			local utils = require("telescope._extensions.file_browser.utils")
			local actions_state = require("telescope.actions.state")
			local Path = require("plenary.path")

			local function toggle_respect_gitignore(prompt_bufnr)
				local current_picker = actions_state.get_current_picker(prompt_bufnr)
				local finder = current_picker.finder

				if type(finder.respect_gitignore) == "boolean" then
					finder.respect_gitignore = not finder.respect_gitignore
				else
					if finder.files then
						---@diagnostic disable-next-line: inject-field
						finder.respect_gitignore.file_browser = not finder.respect_gitignore.file_browser
					else
						---@diagnostic disable-next-line: inject-field
						finder.respect_gitignore.folder_browser = not finder.respect_gitignore.folder_browser
					end
				end
				current_picker:refresh(finder, { reset_prompt = true, multi = current_picker._multi })
			end

			local function toggle_current_buffer_path(prompt_bufnr)
				local current_picker = actions_state.get_current_picker(prompt_bufnr)
				local finder = current_picker.finder
				local bufr_path = Path:new(vim.fn.expand("#:p"))
				local bufr_parent_path = bufr_path:parent():absolute()

				if finder.path ~= bufr_parent_path then
					finder.path = bufr_parent_path
					utils.selection_callback(current_picker, bufr_path:absolute())
				else
					finder.path = vim.uv.cwd()
				end
				utils.redraw_border_title(current_picker)
				current_picker:refresh(finder, {
					new_prefix = utils.relative_path_prefix(finder),
					reset_prompt = true,
					multi = current_picker._multi,
				})
			end

			return {
				prompt_title = "Explorer",
				mappings = {
					i = {
						["<C-h>h"] = toggle_respect_gitignore,
						["<C-e>"] = toggle_current_buffer_path,
					},
					n = { hh = toggle_respect_gitignore },
				},
				dir_icon = "",
				dir_icon_hl = "TelescopePreviewDirectory",
			}
		end,
		config = function(_, opts)
			require("telescope").setup({ extensions = { file_browser = opts } })
			require("telescope").load_extension("file_browser")
		end,
		keys = {
			{
				"<leader>e",
				function()
					require("telescope").extensions.file_browser.file_browser({ cwd = LazyVim.root() })
				end,
				desc = "Explorer (Root Dir)",
			},
			{
				"<leader>E",
				"<cmd>Telescope file_browser<cr>",
				desc = "Explorer (cwd)",
			},
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		keys = {
			{ "<leader>e", false },
			{ "<leader>E", false },
		},
	},
	{
		"debugloop/telescope-undo.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
		},
		opts = {},
		config = function(_, opts)
			require("telescope").setup({ extensions = { undo = opts } })
			require("telescope").load_extension("undo")
		end,
		keys = {
			{
				"<leader>u",
				"<cmd>Telescope undo<cr>",
				desc = "undo history",
			},
		},
	},
}
