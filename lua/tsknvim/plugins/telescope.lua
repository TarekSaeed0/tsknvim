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
				find_files = { prompt_title = "files" },
				grep_string = { prompt_title = "search" },
				live_grep = { prompt_title = "search live" },
				buffers = { prompt_title = "buffers" },
				oldfiles = { prompt_title = "file history" },
				commands = { prompt_title = "commands" },
				tags = { prompt_title = "tags" },
				command_history = { prompt_title = "command history" },
				search_history = { prompt_title = "search history" },
				help_tags = { prompt_title = "help" },
				man_pages = {
					prompt_title = "manual",
					sections = { "ALL" },
					man_cmd = { "apropos", "." },
					entry_maker = (function()
						local display
						return function(line)
							if not display then
								local displayer = require("telescope.pickers.entry_display").create({
									separator = " ",
									items = {
										{ width = 30 },
										{ remaining = true },
									},
								})

								display = function(entry)
									return displayer({
										{ entry.keyword, "TelescopeResultsFunction" },
										entry.description,
									})
								end
							end

							local keyword, value, section, description = line:match("^((.-)%s*%(([^)]+)%).-)%s+%-%s+(.*)$")
							if keyword then
								value = vim.split(value, ",")[1]
								section = vim.split(section, ",")[1]:sub(1, 1)

								return require("telescope.make_entry").set_default_entry_mt({
									value = value,
									description = description,
									ordinal = value,
									display = display,
									section = section,
									keyword = keyword,
								})
							end
						end
					end)(),
				},
				marks = { prompt_title = "marks" },
				colorscheme = { prompt_title = "color schemes" },
				quickfix = { prompt_title = "quick fixes" },
				quickfixhistory = { prompt_title = "quick fix history" },
				loclist = { prompt_title = "location list" },
				jumplist = { prompt_title = "jump list" },
				vim_options = { prompt_title = "options" },
				registers = { prompt_title = "registers" },
				autocommands = { prompt_title = "automatic commands" },
				spell_suggest = { prompt_title = "spelling suggestions" },
				keymaps = { prompt_title = "key mappings" },
				filetypes = { prompt_title = "file types" },
				highlights = { prompt_title = "highlights" },
				current_buffer_fuzzy_find = { prompt_title = "current buffer search" },
				current_buffer_tags = { prompt_title = "current buffer tags" },
				lsp_references = { prompt_title = "references"  },
				lsp_incoming_calls = { prompt_title = "incoming calls"  },
				lsp_outgoing_calls = { prompt_title = "outgoing calls"  },
				lsp_document_symbols = { prompt_title = "document symbols"  },
				lsp_workspace_symbols = { prompt_title = "workspace symbols"  },
				lsp_dynamic_workspace_symbols = { prompt_title = "dynamic workspace symbols"  },
				diagnostics = { prompt_title = "diagnostics"  },
				lsp_implementations = { prompt_title = "implementations"  },
				lsp_definitions = { prompt_title = "definitions"  },
				lsp_type_definitions = { prompt_title = "type definitions"  },
			},
		},
		config = function(_, opts)
			if vim.tbl_filter(function(plugin)
				return plugin.name == "nvim-notify"
			end, require("lazy").plugins())[1]._.loaded ~= nil then
				require("telescope").setup({ extensions = { notify = { prompt_title = "notifications" } } })
				require("telescope").load_extension("notify")
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
			{ "<leader>f", function() require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") }) end, desc = "files" },
			{ "<leader>s", function() require("telescope.builtin").grep_string({ cwd = vim.fn.expand("%:p:h") }) end, desc = "search" },
			{ "<leader>sl", function() require("telescope.builtin").live_grep({ cwd = vim.fn.expand("%:p:h") }) end, desc = "search live" },
			{ "<leader>b", function() require("telescope.builtin").buffers() end, desc = "buffers" },
			{ "<leader>fh", function() require("telescope.builtin").oldfiles() end, desc = "file history" },
			{ "<leader>C", function() require("telescope.builtin").commands() end, desc = "commands" },
			{ "<leader>T", function() require("telescope.builtin").tags() end, desc = "tags" },
			{ "<leader>Ch", function() require("telescope.builtin").command_history() end, desc = "command history" },
			{ "<leader>sh", function() require("telescope.builtin").search_history() end, desc = "search history" },
			{ "<leader>h", function() require("telescope.builtin").help_tags() end, desc = "help" },
			{ "<leader>m", function() require("telescope.builtin").man_pages() end, desc = "manual" },
			{ "<leader>M", function() require("telescope.builtin").marks() end, desc = "marks" },
			{ "<leader>cs", function() require("telescope.builtin").colorscheme() end, desc = "color schemes" },
			{ "<leader>qf", function() require("telescope.builtin").quickfix() end, desc = "quick fixes" },
			{ "<leader>qfh", function() require("telescope.builtin").quickfixhistory() end, desc = "quick fix history" },
			{ "<leader>ll", function() require("telescope.builtin").loclist() end, desc = "location list" },
			{ "<leader>jl", function() require("telescope.builtin").jumplist() end, desc = "jump list" },
			{ "<leader>O", function() require("telescope.builtin").vim_options() end, desc = "options" },
			{ "<leader>r", function() require("telescope.builtin").registers() end, desc = "registers" },
			{ "<leader>ac", function() require("telescope.builtin").autocommands() end, desc = "automatic commands" },
			{ "<leader>ss", function() require("telescope.builtin").spell_suggest() end, desc = "spelling suggestions" },
			{ "<leader>km", function() require("telescope.builtin").keymaps() end, desc = "key mappings" },
			{ "<leader>ft", function() require("telescope.builtin").filetypes() end, desc = "file types" },
			{ "<leader>hl", function() require("telescope.builtin").highlights() end, desc = "highlights" },
			{ "<leader>cbs", function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "current buffer search" },
			{ "<leader>cbt", function() require("telescope.builtin").current_buffer_tags() end, desc = "current buffer tags" },
			{ "<leader>R", function() require("telescope.builtin").lsp_references() end, desc = "references" },
			{ "<leader>ic", function() require("telescope.builtin").lsp_incoming_calls() end, desc = "incoming calls" },
			{ "<leader>oc", function() require("telescope.builtin").lsp_outgoing_calls() end, desc = "outgoing calls" },
			{ "<leader>ds", function() require("telescope.builtin").lsp_document_symbols() end, desc = "document symbols" },
			{ "<leader>ws", function() require("telescope.builtin").lsp_workspace_symbols() end, desc = "workspace symbols" },
			{ "<leader>dws", function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end, desc = "dynamic workspace symbols" },
			{ "<leader>d", function() require("telescope.builtin").diagnostics() end, desc = "diagnostics" },
			{ "<leader>i", function() require("telescope.builtin").lsp_implementations() end, desc = "implementations" },
			{ "<leader>D", function() require("telescope.builtin").lsp_definitions() end, desc = "definitions" },
			{ "<leader>td", function() require("telescope.builtin").lsp_type_definitions() end, desc = "type definitions" },
			{ "<leader>n", function() require("telescope").extensions.notify.notify() end, desc = "notifications" },
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
				prompt_title = "file browser",
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
		keys = { { "<leader>fb", function() require("telescope").extensions.file_browser.file_browser({ cwd = vim.fn.expand("%:p:h") }) end, desc = "file browser" } },
	},
	{
		"debugloop/telescope-undo.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		opts = { prompt_title = "undo" },
		config = function(_, opts)
			require("telescope").setup({ extensions = { undo = opts } })
			require("telescope").load_extension("undo")
		end,
		cmd = "Telescope",
		keys = { { "<leader>u", function() require("telescope").extensions.undo.undo() end, desc = "undo" } },
	},
}
