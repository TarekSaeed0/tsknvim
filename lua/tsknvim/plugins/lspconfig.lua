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
				opts = {
					request_timeout = 100,
					lightbulb = { enable = false },
					diagnostic = { border_follow = false },
					outline = { win_width = 25 },
					symbol_in_winbar = { enable = false },
					ui = {
						title = false,
						border = "rounded",
						winblend = vim.opt.winblend:get(),
					},
				},
			},
			{
				"williamboman/mason-lspconfig.nvim",
				opts = { ensure_installed = { "bashls", "clangd", "cmake", "lua_ls", "pyright" } },
				config = function(_, opts)
					local servers = opts.ensure_installed
					opts.ensure_installed = {}
					opts.handlers = opts.handlers or {}
					for _, server in ipairs(servers) do
						local name = require("mason-core.package").Parse(server)
						local package = require("mason-registry").get_package(require("mason-lspconfig").get_mappings().lspconfig_to_mason[name])
						if package:is_installed() or #vim.tbl_filter(function(binary)
							return vim.fn.executable(binary) ~= 1
						end, vim.tbl_keys(package.spec.bin or {})) ~= 0 then
							table.insert(opts.ensure_installed, server)
						else
							opts.handlers[name] = opts.handlers[name] or true
						end
					end

					require("mason-lspconfig").setup(opts)
				end,
				cmd = { "LspInstall", "LspUninstall" }
			},
			{ "folke/neodev.nvim", config = true },
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local on_attach = function(_, buffer)
				vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc")

				vim.keymap.set({ "n","v" }, "<leader>ca", "<cmd>Lspsaga code_action<cr>", { buffer = buffer })
				vim.keymap.set("n", "rn", "<cmd>Lspsaga rename<cr>", { buffer = buffer })
				vim.keymap.set("n", "<space>rn", "<cmd>Lspsaga rename ++project<cr>", { buffer = buffer })
				vim.keymap.set("n", "<space>pd", "<cmd>Lspsaga peek_definition<cr>", { buffer = buffer })
				vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<cr>", { buffer = buffer })
				vim.keymap.set("n", "<space>pt", "<cmd>Lspsaga peek_type_definition<cr>", { buffer = buffer })
				vim.keymap.set("n", "gt", "<cmd>Lspsaga goto_type_definition<cr>", { buffer = buffer })
				vim.keymap.set("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<cr>", { buffer = buffer })
				vim.keymap.set("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<cr>", { buffer = buffer })
				vim.keymap.set("n", "<leader>sw", "<cmd>Lspsaga show_workspace_diagnostics<cr>", { buffer = buffer })
				vim.keymap.set("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<cr>", { buffer = buffer })
				vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", { buffer = buffer })
				vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", { buffer = buffer })
				vim.keymap.set("n", "[E", function() require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, { buffer = buffer })
				vim.keymap.set("n", "]E", function() require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR }) end, { buffer = buffer })
				vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<cr>", { buffer = buffer })
				vim.keymap.set("n", "H", "<cmd>Lspsaga hover_doc<cr>", { buffer = buffer })
				vim.keymap.set("n", "<space>H", "<cmd>Lspsaga hover_doc ++keep<cr>", { buffer = buffer })

				vim.opt.updatetime = 250
				vim.api.nvim_create_autocmd("CursorHold", {
					group = vim.api.nvim_create_augroup("tsknvim_open_diagnostic_window_on_hover", { clear = true }),
					buffer = buffer,
					command = "Lspsaga show_cursor_diagnostics ++unfocus",
				})
			end

			require("lspconfig.ui.windows").default_options.border = "rounded"

			for name, icon in pairs({ Error = "", Warn = "", Info =  "", Hint = "󰌵" }) do
				name = "DiagnosticSign"..name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = name })
			end

			vim.diagnostic.config({
				virtual_text = false,
				severity_sort = true,
			})
			vim.diagnostic.config({ virtual_text = { prefix = "●" } }, vim.api.nvim_create_namespace("lazy"))

			local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			local default_handler = function(name)
				require("lspconfig")[name].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end
			require("mason-lspconfig.settings").current.handlers = vim.tbl_map(function(handler)
				return handler == true and default_handler or handler
			end, require("mason-lspconfig.settings").current.handlers)
			require("mason-lspconfig").setup_handlers({ default_handler })
		end,
		event = { "BufReadPre", "BufNewFile" },
		cmd = {
			"LspInfo",
			"LspStart",
			"LspStop",
			"LspRestart",
		},
	},
}
