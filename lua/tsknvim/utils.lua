local M = {}

M.in_focus = true
vim.api.nvim_create_autocmd("FocusGained", {
	group = vim.api.nvim_create_augroup("tsknvim_set_in_focus_on_focus_gained", { clear = true }),
	callback = function()
		M.in_focus = true
	end,
})
vim.api.nvim_create_autocmd("FocusLost", {
	group = vim.api.nvim_create_augroup("tsknvim_unset_in_focus_on_focus_lost", { clear = true }),
	callback = function()
		M.in_focus = false
	end,
})

---@param name string
---@return boolean
M.is_installed = function(name)
	local plugin = require("lazy.core.config").plugins[name]
	return plugin and plugin._.installed ~= nil
end
---@param name string
---@return boolean
M.is_loaded = function(name)
	local plugin = require("lazy.core.config").plugins[name]
	return plugin and plugin._.loaded ~= nil
end

---@param callback fun(string)
M.select_file = function(callback)
	local fb_actions = require("telescope._extensions.file_browser.actions")
	local fb_utils = require("telescope._extensions.file_browser.utils")

	local action_state = require("telescope.actions.state")
	local action_set = require("telescope.actions.set")

	require("telescope").extensions.file_browser.file_browser({
		cwd = vim.fn.expand("%:p:h"),
		attach_mappings = function()
			local entry_is_dir = function()
				local entry = action_state.get_selected_entry()
				return entry and fb_utils.is_dir(entry.Path)
			end

			action_set.select:replace(function(prompt_bufnr)
				require("telescope.actions").close(prompt_bufnr)
				callback(action_state.get_selected_entry().path)
			end)

			action_set.select:replace_if(entry_is_dir, fb_actions.open_dir)

			return true
		end,
	})
end

M.lsp = {}
M.lsp.on_attach = function(_, buffer)
	vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = buffer })

	vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<cr>", { buffer = buffer })

	vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<cr>", { buffer = buffer })
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
	vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", { buffer = buffer, desc = "Next diagnostic" })

	for key, severity in pairs({ e = "ERROR", w = "WARN", i = "INFO", h = "HINT" }) do
		vim.keymap.set("n", "[" .. key, function()
			require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity[severity] })
		end, { buffer = buffer, desc = "Previous " .. severity:lower() .. " diagnostic" })
		vim.keymap.set("n", "]" .. key, function()
			require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity[severity] })
		end, { buffer = buffer, desc = "Next " .. severity:lower() .. " diagnostic" })
	end

	vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<cr>", { buffer = buffer })

	if require("tsknvim.utils").is_loaded("nvim-ufo") then
		vim.keymap.set("n", "K", function()
			if not require("ufo").peekFoldedLinesUnderCursor(false, false) then
				vim.cmd.Lspsaga("hover_doc")
			end
		end, { buffer = buffer })
	else
		vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<cr>", { buffer = buffer })
	end
	vim.keymap.set("n", "K<space>", "<cmd>Lspsaga hover_doc ++keep<cr>", { buffer = buffer })

	vim.keymap.set("n", "<leader>ih", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buffer }), { bufnr = buffer })
	end, { buffer = buffer, desc = "Toggle inlay hints" })
	vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
end

return M
