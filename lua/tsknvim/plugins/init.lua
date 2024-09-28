if vim.g.lazy_did_setup then
	return {}
end

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazy_path) then
	vim.api.nvim_echo({
		{
			"Cloning lazy.nvim\n\n",
			"DiagnosticInfo",
		},
	}, true, {})
	local lazy_repo = "https://github.com/folke/lazy.nvim.git"
	local ok, out = pcall(vim.fn.system, {
		"git",
		"clone",
		"--filter=blob:none",
		lazy_repo,
		lazy_path,
	})
	if not ok or vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim\n", "ErrorMsg" },
			{ vim.trim(out or ""), "WarningMsg" },
			{ "\nPress any key to exit...", "MoreMsg" },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazy_path)

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

---@diagnostic disable-next-line: duplicate-set-field
require("lazy.view.float").layout = function(self)
	self.win_opts.width = vim.opt.columns:get()
		- 2 * math.floor(math.min(vim.opt.lines:get(), vim.opt.columns:get() / 2) / 4)
	self.win_opts.height = vim.opt.lines:get()
		- math.floor(math.min(vim.opt.lines:get(), vim.opt.columns:get() / 2) / 4)
	self.win_opts.row = math.floor((vim.o.lines - self.win_opts.height) / 2)
	self.win_opts.col = math.floor((vim.o.columns - self.win_opts.width) / 2)

	if self.opts.border ~= "none" then
		self.win_opts.row = self.win_opts.row - 1
		self.win_opts.col = self.win_opts.col - 1
	end

	if self.opts.margin then
		if self.opts.margin.top then
			self.win_opts.height = self.win_opts.height - self.opts.margin.top
			self.win_opts.row = self.win_opts.row + self.opts.margin.top
		end
		if self.opts.margin.right then
			self.win_opts.width = self.win_opts.width - self.opts.margin.right
		end
		if self.opts.margin.bottom then
			self.win_opts.height = self.win_opts.height - self.opts.margin.bottom
		end
		if self.opts.margin.left then
			self.win_opts.width = self.win_opts.width - self.opts.margin.left
			self.win_opts.col = self.win_opts.col + self.opts.margin.left
		end
	end
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
