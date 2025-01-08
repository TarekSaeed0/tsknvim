return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-cmdline" },
		opts = function(_, opts)
			local cmp = require("cmp")

			opts.window = {
				completion = cmp.config.window.bordered({
					winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
				}),
				documentation = cmp.config.window.bordered({
					winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
				}),
			}
		end,
		config = function(_, opts)
			local cmp = require("cmp")

			require("lazyvim.util.cmp").setup(opts)

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
		end,
	},
}
