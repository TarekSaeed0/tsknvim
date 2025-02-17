---@type LazySpec[]
return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@module "snacks"
		---@type snacks.Config
		opts = {
			scroll = { enabled = true },
			quickfile = { enabled = true },
			toggle = {
				map = function(mode, lhs, rhs, opts)
					local keys = require("lazy.core.handler").handlers.keys
					---@cast keys LazyKeysHandler
					local modes = type(mode) == "string" and { mode } or mode

					---@param m string
					modes = vim.tbl_filter(function(m)
						return not (keys.have and keys:have(lhs, m))
					end, modes)

					-- do not create the keymap if a lazy keys handler exists
					if #modes > 0 then
						opts = opts or {}
						opts.silent = opts.silent ~= false
						if opts.remap and not vim.g.vscode then
							---@diagnostic disable-next-line: no-unknown
							opts.remap = nil
						end
						vim.keymap.set(modes, lhs, rhs, opts)
					end
				end,
			},
			styles = {
				notification = {
					wo = { winblend = vim.opt.winblend:get() },
				},
			},
		},
	},
}
