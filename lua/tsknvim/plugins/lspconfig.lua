---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"glepnir/lspsaga.nvim",
				dependencies = {
					"nvim-tree/nvim-web-devicons",
					"nvim-treesitter/nvim-treesitter",
				},
				---@type LspsagaConfig
				opts = {
					request_timeout = 100,
					lightbulb = { enable = false },
					diagnostic = { border_follow = false },
					outline = { win_width = 25 },
					symbol_in_winbar = { enable = false },
					ui = { title = false, border = "rounded" },
				},
				cmd = "Lspsaga",
			},
			{
				"williamboman/mason-lspconfig.nvim",
				dependencies = { "williamboman/mason.nvim" },
				---@type MasonLspconfigSettings
				opts = {
					ensure_installed = {
						"bashls",
						"cmake",
						"cssls",
						"html",
						"jsonls",
						"lua_ls",
						"powershell_es",
						"pyright",
						"ts_ls",
						"taplo",
					},
				},
				---@param opts MasonLspconfigSettings
				config = function(_, opts)
					local servers = opts.ensure_installed
					opts.ensure_installed = {}
					opts.handlers = opts.handlers or {}
					for _, server in ipairs(servers) do
						local name = require("mason-core.package").Parse(server)
						local package = require("mason-registry").get_package(
							require("mason-lspconfig").get_mappings().lspconfig_to_mason[name]
						)

						local all_binaries_installed = false
						if package.spec.bin then
							all_binaries_installed = vim.iter(package.spec.bin):all(function(binary)
								return vim.fn.executable(binary) == 1
							end)
						end

						if package:is_installed() or not all_binaries_installed then
							table.insert(opts.ensure_installed, server)
						else
							opts.handlers[name] = opts.handlers[name] or true
						end
					end

					require("mason-lspconfig").setup(opts)
				end,
				cmd = { "LspInstall", "LspUninstall" },
			},
			{ "folke/neodev.nvim", config = true },
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local on_attach = function(_, buffer)
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
				vim.keymap.set("n", "<leader>wd", "<cmd>Lspsaga show_workspace_diagnostics<cr>", { buffer = buffer })
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
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buffer }), { bufnr = buffer })
				end, { buffer = buffer, desc = "Toggle inlay hints" })
				vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
			end

			require("lspconfig.ui.windows").default_options.border = "rounded"

			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			local default_handler = function(name)
				require("lspconfig")[name].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end
			local handlers = require("mason-lspconfig.settings").current.handlers or {}
			for name, handler in pairs(handlers) do
				if handler == true then
					handlers[name] = nil
					default_handler(name)
				end
			end
			require("mason-lspconfig").setup_handlers({ default_handler })
		end,
		cmd = {
			"LspInfo",
			"LspStart",
			"LspStop",
			"LspRestart",
			"LspLog",
		},
		ft = {
			"sh",
			"cmake",
			"css",
			"html",
			"json",
			"jsonc",
			"javascript",
			"lua",
			"ps1",
			"python",
			"toml",
		},
	},
}
