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
						"powershell_es",
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
		},
		config = function()
			local on_attach = require("tsknvim.utils").lsp.on_attach

			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				require("cmp_nvim_lsp").default_capabilities()
			)

			--[[ local capabilities =
						require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()) ]]

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
			"ps1",
		},
	},
}
