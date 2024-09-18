if vim.g.lazy_did_setup then
	return {}
end

load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()

vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "lazy" })

vim.diagnostic.config({ virtual_text = { prefix = "●" } }, vim.api.nvim_create_namespace("lazy"))

local util = require("lazy.core.util")

local function can_merge_table(v)
	return type(v) == "table" and (vim.tbl_isempty(v) or not util.is_list(v))
end
local function can_merge_list(v)
	return type(v) == "table" and util.is_list(v)
end

-- HACK: to allow merging lists in plugin's opts
---@diagnostic disable-next-line: duplicate-set-field
util.merge = function(...)
	local ret = select(1, ...)
	if ret == vim.NIL then
		ret = nil
	end
	for i = 2, select("#", ...) do
		local value = select(i, ...)
		if can_merge_table(ret) and can_merge_table(value) then
			for k, v in pairs(value) do
				ret[k] = util.merge(ret[k], v)
			end
		elseif can_merge_list(ret) and can_merge_list(value) then
			ret = util.extend(ret, value)
		elseif value == vim.NIL then
			ret = nil
		elseif value ~= nil then
			ret = value
		end
	end
	return ret
end

require("lazy").setup({
	{ import = "tsknvim.plugins" },
	{ import = "tsknvim.plugins.languages" },
}, {
	install = { colorscheme = { "catppuccin" } },
	ui = { border = "rounded", backdrop = 100 },
	checker = { enabled = true },
	performance = {
		rtp = {
			disabled_plugins = {
				"2html_plugin",
				"editorconfig",
				"tohtml",
				"getscript",
				"getscriptPlugin",
				"gzip",
				"logipat",
				"netrw",
				"netrwPlugin",
				"netrwSettings",
				"netrwFileHandlers",
				"matchit",
				"tar",
				"tarPlugin",
				"rrhelper",
				"spellfile_plugin",
				"vimball",
				"vimballPlugin",
				"zip",
				"zipPlugin",
				"tutor",
				"rplugin",
				"spellfile",
				"syntax",
				"synmenu",
				"optwin",
				"compiler",
				"bugreport",
				"ftplugin",
			},
		},
	},
})

local report = require("lazy.manage.checker").report
---@diagnostic disable-next-line: duplicate-set-field
require("lazy.manage.checker").report = function(notify)
	local timer = vim.uv.new_timer()
	local tcp = vim.uv.new_tcp()

	timer:start(1000, 0, function()
		tcp:close()
	end)

	tcp:connect("8.8.8.8", 53, function(error)
		timer:stop()

		if not error then
			vim.defer_fn(function()
				require("lazy.core.loader").load({ "nvim-treesitter" }, {})
				report(notify)
			end, 0)
		end
	end)
end
