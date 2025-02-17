---@type LazySpec[]
return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				"garymjr/nvim-snippets",
				opts = { friendly_snippets = true },
				dependencies = { "rafamadriz/friendly-snippets" },
			},
			"onsails/lspkind.nvim",
			{
				"windwp/nvim-autopairs",
				opts = {
					disable_filetype = { "TelescopePrompt", "spectre_panel", "tex" },
				},
			},
			{
				"Exafunction/codeium.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
				config = true,
				cmd = "Codeium",
			},
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"f3fora/cmp-spell",
			"chrisgrieser/cmp-nerdfont",
		},
		---@return cmp.ConfigSchema
		opts = function()
			local cmp = require("cmp")

			return {
				window = {
					completion = cmp.config.window.bordered({
						winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
						scrollbar = false,
					}),
					documentation = cmp.config.window.bordered({
						winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
						scrollbar = false,
					}),
				},
				---@diagnostic disable-next-line: missing-fields
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = require("lspkind").cmp_format({
						mode = "symbol",
						preset = "codicons",
						maxwidth = math.floor(vim.opt.columns:get() / 2),
						ellipsis_char = "…",
						symbol_map = { Codeium = "" },
					}),
				},
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<C-S-f>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.close(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
					}),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "codeium" },
					{ name = "snippets", keyword_length = 3 },
					{ name = "path" },
				}, {
					{ name = "nerdfont" },
				}, {
					{ name = "buffer" },
					{ name = "spell" },
				}),
				---@diagnostic disable-next-line: missing-fields
				view = { entries = { follow_cursor = true } },
				---@diagnostic disable-next-line: missing-fields
				experimental = { ghost_text = {} },
			}
		end,
		---@param opts cmp.ConfigSchema
		config = function(_, opts)
			vim.opt.pumheight = math.floor(vim.opt.lines:get() / 2)

			local cmp = require("cmp")

			cmp.setup(opts)

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "buffer" },
				}),
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})

			cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
		end,
		event = { "InsertEnter", "CmdlineEnter" },
		cmd = { "CmpStatus" },
		keys = {
			{
				"<Tab>",
				function()
					if vim.snippet.active({ direction = 1 }) then
						vim.schedule(function()
							vim.snippet.jump(1)
						end)
						return
					end
					return "<Tab>"
				end,
				expr = true,
				silent = true,
				mode = "i",
			},
			{
				"<Tab>",
				function()
					vim.schedule(function()
						vim.snippet.jump(1)
					end)
				end,
				expr = true,
				silent = true,
				mode = "s",
			},
			{
				"<S-Tab>",
				function()
					if vim.snippet.active({ direction = -1 }) then
						vim.schedule(function()
							vim.snippet.jump(-1)
						end)
						return
					end
					return "<S-Tab>"
				end,
				expr = true,
				silent = true,
				mode = { "i", "s" },
			},
		},
	},
}
