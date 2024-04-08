return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				config = function()
					require("telescope").load_extension("fzf")
				end,
				build = "make",
			},
		},
		opts = {
			defaults = {
				layout_strategy = "fit",
				layout_config = { preview_cutoff = 0, flip_ratio = 2.2 },
				results_title = false,
			},
			pickers = {
				find_files = { prompt_title = "Files" },
				grep_string = { prompt_title = "Search" },
				live_grep = { prompt_title = "Search live" },
				buffers = { prompt_title = "Buffers" },
				oldfiles = { prompt_title = "File history" },
				commands = { prompt_title = "Commands" },
				tags = { prompt_title = "Tags" },
				command_history = { prompt_title = "Command history" },
				search_history = { prompt_title = "Search history" },
				help_tags = { prompt_title = "Help" },
				man_pages = { prompt_title = "Manual", sections = { "ALL" } },
				marks = { prompt_title = "Marks" },
				colorscheme = { prompt_title = "Color schemes" },
				quickfix = { prompt_title = "Quick fixes" },
				quickfixhistory = { prompt_title = "Quick fix history" },
				loclist = { prompt_title = "Location list" },
				jumplist = { prompt_title = "Jump list" },
				vim_options = { prompt_title = "Options" },
				registers = { prompt_title = "Registers" },
				autocommands = { prompt_title = "Automatic commands" },
				spell_suggest = { prompt_title = "Spelling suggestions" },
				keymaps = { prompt_title = "Key mappings" },
				filetypes = { prompt_title = "File types" },
				highlights = { prompt_title = "Highlights" },
				current_buffer_fuzzy_find = { prompt_title = "Current buffer search" },
				current_buffer_tags = { prompt_title = "Current buffer tags" },
				lsp_references = { prompt_title = "References" },
				lsp_incoming_calls = { prompt_title = "Incoming calls" },
				lsp_outgoing_calls = { prompt_title = "Outgoing calls" },
				lsp_document_symbols = { prompt_title = "Document symbols" },
				lsp_workspace_symbols = { prompt_title = "Workspace symbols" },
				lsp_dynamic_workspace_symbols = { prompt_title = "Dynamic workspace symbols" },
				diagnostics = { prompt_title = "Diagnostics" },
				lsp_implementations = { prompt_title = "Implementations" },
				lsp_definitions = { prompt_title = "Definitions" },
				lsp_type_definitions = { prompt_title = "Type definitions" },
			},
		},
		config = function(_, opts)
			if require("tsknvim.utils").is_loaded("nvim-notify") then
				require("telescope").setup({ extensions = { notify = { prompt_title = "Notifications" } } })
				require("telescope").load_extension("notify")
			end

			if require("tsknvim.utils").is_loaded("project.nvim") then
				require("telescope").setup({ extensions = { projects = { prompt_title = "Project history" } } })
				require("telescope").load_extension("projects")
			end

			local layout_strategies = require("telescope.pickers.layout_strategies")
			layout_strategies.fit = function(picker, columns, lines, layout_config)
				layout_config = vim.F.if_nil(layout_config, require("telescope.config").values.layout_config)
				local flip_ratio = vim.F.if_nil(layout_config.flip_ratio, 2)
				local ratio = columns / lines
				picker.layout_config.flip_ratio = nil
				if ratio >= flip_ratio then
					return layout_strategies.horizontal(picker, columns, lines, layout_config.horizontal)
				else
					return layout_strategies.vertical(picker, columns, lines, layout_config.vertical)
				end
			end

			require("telescope").setup(opts)
		end,
		cmd = "Telescope",
		keys = {
			{
				"<leader>f",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Files",
			},
			{
				"<leader>s",
				function()
					require("telescope.builtin").grep_string()
				end,
				desc = "Search",
			},
			{
				"<leader>sl",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Search live",
			},
			{
				"<leader>b",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>fh",
				function()
					require("telescope.builtin").oldfiles()
				end,
				desc = "File history",
			},
			{
				"<leader>C",
				function()
					require("telescope.builtin").commands()
				end,
				desc = "Commands",
			},
			{
				"<leader>T",
				function()
					require("telescope.builtin").tags()
				end,
				desc = "Tags",
			},
			{
				"<leader>Ch",
				function()
					require("telescope.builtin").command_history()
				end,
				desc = "Command history",
			},
			{
				"<leader>sh",
				function()
					require("telescope.builtin").search_history()
				end,
				desc = "Search history",
			},
			{
				"<leader>h",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "Help",
			},
			{
				"<leader>m",
				function()
					require("telescope.builtin").man_pages()
				end,
				desc = "Manual",
			},
			{
				"<leader>M",
				function()
					require("telescope.builtin").marks()
				end,
				desc = "Marks",
			},
			{
				"<leader>cs",
				function()
					require("telescope.builtin").colorscheme()
				end,
				desc = "Color schemes",
			},
			{
				"<leader>qf",
				function()
					require("telescope.builtin").quickfix()
				end,
				desc = "Quick fixes",
			},
			{
				"<leader>qfh",
				function()
					require("telescope.builtin").quickfixhistory()
				end,
				desc = "Quick fix history",
			},
			{
				"<leader>ll",
				function()
					require("telescope.builtin").loclist()
				end,
				desc = "Location list",
			},
			{
				"<leader>jl",
				function()
					require("telescope.builtin").jumplist()
				end,
				desc = "Jump list",
			},
			{
				"<leader>O",
				function()
					require("telescope.builtin").vim_options()
				end,
				desc = "Options",
			},
			{
				"<leader>r",
				function()
					require("telescope.builtin").registers()
				end,
				desc = "Registers",
			},
			{
				"<leader>ac",
				function()
					require("telescope.builtin").autocommands()
				end,
				desc = "Automatic commands",
			},
			{
				"<leader>ss",
				function()
					require("telescope.builtin").spell_suggest()
				end,
				desc = "Spelling suggestions",
			},
			{
				"<leader>km",
				function()
					require("telescope.builtin").keymaps()
				end,
				desc = "Key mappings",
			},
			{
				"<leader>ft",
				function()
					require("telescope.builtin").filetypes()
				end,
				desc = "File types",
			},
			{
				"<leader>hl",
				function()
					require("telescope.builtin").highlights()
				end,
				desc = "Highlights",
			},
			{
				"<leader>cbs",
				function()
					require("telescope.builtin").current_buffer_fuzzy_find()
				end,
				desc = "Current buffer search",
			},
			{
				"<leader>cbt",
				function()
					require("telescope.builtin").current_buffer_tags()
				end,
				desc = "Current buffer tags",
			},
			{
				"<leader>R",
				function()
					require("telescope.builtin").lsp_references()
				end,
				desc = "References",
			},
			{
				"<leader>ic",
				function()
					require("telescope.builtin").lsp_incoming_calls()
				end,
				desc = "Incoming calls",
			},
			{
				"<leader>oc",
				function()
					require("telescope.builtin").lsp_outgoing_calls()
				end,
				desc = "Outgoing calls",
			},
			{
				"<leader>ds",
				function()
					require("telescope.builtin").lsp_document_symbols()
				end,
				desc = "Document symbols",
			},
			{
				"<leader>ws",
				function()
					require("telescope.builtin").lsp_workspace_symbols()
				end,
				desc = "Workspace symbols",
			},
			{
				"<leader>dws",
				function()
					require("telescope.builtin").lsp_dynamic_workspace_symbols()
				end,
				desc = "Dynamic workspace symbols",
			},
			{
				"<leader>d",
				function()
					require("telescope.builtin").diagnostics()
				end,
				desc = "Diagnostics",
			},
			{
				"<leader>i",
				function()
					require("telescope.builtin").lsp_implementations()
				end,
				desc = "Implementations",
			},
			{
				"<leader>D",
				function()
					require("telescope.builtin").lsp_definitions()
				end,
				desc = "Definitions",
			},
			{
				"<leader>td",
				function()
					require("telescope.builtin").lsp_type_definitions()
				end,
				desc = "Type definitions",
			},
			{
				"<leader>n",
				function()
					require("telescope").extensions.notify.notify()
				end,
				desc = "Notifications",
			},
			{
				"<leader>ph",
				function()
					require("telescope").extensions.projects.projects()
				end,
				desc = "Project history",
			},
		},
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
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
			local function toggle_respect_gitignore(prompt_bufnr)
				local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
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
			return {
				prompt_title = "File browser",
				mappings = {
					i = { ["<C-h>h"] = toggle_respect_gitignore },
					n = { hh = toggle_respect_gitignore },
				},
				dir_icon = "",
				dir_icon_hl = "DevIconDefault",
			}
		end,
		config = function(_, opts)
			require("telescope").setup({ extensions = { file_browser = opts } })
			require("telescope").load_extension("file_browser")
		end,
		cmd = "Telescope",
		keys = {
			{
				"<leader>fb",
				function()
					require("telescope").extensions.file_browser.file_browser()
				end,
				desc = "File browser",
			},
		},
	},
	{
		"debugloop/telescope-undo.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		opts = { prompt_title = "Undo" },
		config = function(_, opts)
			require("telescope").setup({ extensions = { undo = opts } })
			require("telescope").load_extension("undo")
		end,
		cmd = "Telescope",
		keys = {
			{
				"<leader>u",
				function()
					require("telescope").extensions.undo.undo()
				end,
				desc = "Undo",
			},
		},
	},
}
