if vim.fn.executable("flutter") ~= 1 then
	return {}
end

---@type LazySpec[]
return {
	{
		"nvim-treesitter/nvim-treesitter",
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = { ensure_installed = { "dart" } },
		ft = { "dart" },
	},
	{
		"akinsho/flutter-tools.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim",
		},
		opts = {
			ui = { border = "rounded" },
			decorations = {
				statusline = {
					app_version = true,
					device = true,
				},
			},
			closing_tags = { highlight = "LspInlayHint" },
			dev_log = { enabled = false },
			debugger = { enabled = true },
			lsp = {
				color = {
					enabled = true,
					virtual_text_str = "●",
				},
				on_attach = function(_, buffer)
					vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = buffer })

					vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<cr>", { buffer = buffer })

					vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<cr>", { buffer = buffer })
					vim.keymap.set("n", "<F2>", "<cmd>Lspsaga rename<cr>", { buffer = buffer })
					vim.keymap.set("n", "<leader>rnp", "<cmd>Lspsaga rename ++project<cr>", { buffer = buffer })

					vim.keymap.set("n", "<leader>pd", "<cmd>Lspsaga peek_definition<cr>", { buffer = buffer })
					vim.keymap.set("n", "<leader>gd", "<cmd>Lspsaga goto_definition<cr>", { buffer = buffer })

					vim.keymap.set("n", "<leader>pt", "<cmd>Lspsaga peek_type_definition<cr>", { buffer = buffer })
					vim.keymap.set("n", "<leader>gt", "<cmd>Lspsaga goto_type_definition<cr>", { buffer = buffer })

					vim.keymap.set("n", "<leader>ld", "<cmd>Lspsaga show_line_diagnostics<cr>", { buffer = buffer })
					vim.keymap.set("n", "<leader>bd", "<cmd>Lspsaga show_buf_diagnostics<cr>", { buffer = buffer })
					vim.keymap.set(
						"n",
						"<leader>wd",
						"<cmd>Lspsaga show_workspace_diagnostics<cr>",
						{ buffer = buffer }
					)
					vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<cr>", { buffer = buffer })

					vim.keymap.set(
						"n",
						"[d",
						"<cmd>Lspsaga diagnostic_jump_prev<cr>",
						{ buffer = buffer, desc = "Previous diagnostic" }
					)
					vim.keymap.set(
						"n",
						"]d",
						"<cmd>Lspsaga diagnostic_jump_next<cr>",
						{ buffer = buffer, desc = "Next diagnostic" }
					)

					for key, severity in pairs({ e = "ERROR", w = "WARN", i = "INFO", h = "HINT" }) do
						vim.keymap.set("n", "[" .. key, function()
							require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity[severity] })
						end, { buffer = buffer, desc = "Previous " .. severity:lower() .. " diagnostic" })
						vim.keymap.set("n", "]" .. key, function()
							require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity[severity] })
						end, { buffer = buffer, desc = "Next " .. severity:lower() .. " diagnostic" })
					end

					vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<cr>", { buffer = buffer })

					vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<cr>", { buffer = buffer })
					vim.keymap.set("n", "K<space>", "<cmd>Lspsaga hover_doc ++keep<cr>", { buffer = buffer })

					vim.keymap.set("n", "<leader>ih", function()
						vim.lsp.inlay_hint.enable(
							not vim.lsp.inlay_hint.is_enabled({ bufnr = buffer }),
							{ bufnr = buffer }
						)
					end, { buffer = buffer, desc = "Toggle inlay hints" })
					vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
				end,
				capabilities = function(config)
					return vim.tbl_deep_extend("force", {}, config, require("cmp_nvim_lsp").default_capabilities())
				end,
			},
		},
		config = function(_, opts)
			if require("tsknvim.utils").is_loaded("telescope.nvim") then
				require("telescope").setup({ extensions = { notify = { prompt_title = "Flutter Commands" } } })
				require("telescope").load_extension("flutter")
			end

			require("flutter-tools").setup(opts)
		end,
	},
}
