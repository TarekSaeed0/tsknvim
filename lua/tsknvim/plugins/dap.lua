---@type LazySpec[]
return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
				---@type MasonNvimDapSettings
				opts = {
					handlers = {
						codelldb = function(config)
							if not require("tsknvim.utils").is_installed("telescope.nvim") then
								return
							end

							local pickers = require("telescope.pickers")
							local finders = require("telescope.finders")
							local conf = require("telescope.config").values
							local actions = require("telescope.actions")
							local action_state = require("telescope.actions.state")

							config.configurations[1].program = function()
								return coroutine.create(function(coro)
									local opts = {}
									pickers
										.new(opts, {
											prompt_title = "Path to executable",
											finder = finders.new_oneshot_job(
												{ "fd", "--hidden", "--no-ignore", "--type", "x" },
												{}
											),
											sorter = conf.generic_sorter(opts),
											attach_mappings = function(buffer_number)
												actions.select_default:replace(function()
													actions.close(buffer_number)
													coroutine.resume(coro, action_state.get_selected_entry()[1])
												end)
												return true
											end,
										})
										:find()
								end)
							end

							require("mason-nvim-dap").default_setup(config)
						end,
					},
				},
				cmd = { "DapInstall", "DapUninstall" },
			},
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
				config = function()
					local dap = require("dap")
					local dapui = require("dapui")

					local opts = require("dapui.config")
					opts.layouts[1].size = 0.15
					opts.layouts[2].size = 0.2

					dapui.setup(opts)
					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open({})
					end
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close({})
					end
					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close({})
					end
				end,
				keys = {
					{
						"<leader>du",
						function()
							require("dapui").toggle()
						end,
					},
					{
						"<leader>de",
						function()
							require("dapui").eval()
						end,
						mode = { "n", "v" },
					},
				},
			},
		},
		config = function()
			local dap = require("dap")

			for name, icon in pairs({
				DapBreakpoint = "●",
				DapBreakpointCondition = "●",
				DapLogPoint = "◆",
				DapStopped = "󰜴",
				DapBreakpointRejected = "󰅜",
			}) do
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = name })
			end

			local keymaps_restore = {}
			dap.listeners.after.event_initialized.hover_keymap = function()
				for _, buffer in pairs(vim.api.nvim_list_bufs()) do
					local keymaps = vim.api.nvim_buf_get_keymap(buffer, "n")
					for _, keymap in pairs(keymaps) do
						if keymap.lhs == "K" then
							table.insert(keymaps_restore, keymap)
							vim.keymap.del("n", "K", { buffer = buffer })
						end
					end
				end
				vim.keymap.set("n", "K", function()
					require("dap.ui.widgets").hover()
				end, { silent = true })
			end

			dap.listeners.after.event_terminated.hover_keymap = function()
				for _, keymap in pairs(keymaps_restore) do
					vim.keymap.set(
						keymap.mode,
						keymap.lhs,
						keymap.rhs,
						{ buffer = keymap.buffer, silent = keymap.silent == 1 }
					)
				end
				keymaps_restore = {}
			end
		end,
		keys = {
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
			},
			{
				"<leader>da",
				function()
					require("dap").continue({
						before = function(config)
							local arguments = table.concat(
								type(config.args) == "function" and (config.args() or {}) or (config.args or {}) --[=[@as string[]]=],
								" "
							)
							config = vim.deepcopy(config)
							config.args = function()
								arguments = vim.fn.expand(vim.fn.input("arguments: ", arguments)) --[[@as string]]
								return vim.split(arguments, " ")
							end
							return config
						end,
					})
				end,
			},
			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
			},
			{
				"<leader>dg",
				function()
					require("dap").goto_()
				end,
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
			},
			{
				"<leader>dj",
				function()
					require("dap").down()
				end,
			},
			{
				"<leader>dk",
				function()
					require("dap").up()
				end,
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
			},
			{
				"<leader>do",
				function()
					require("dap").step_out()
				end,
			},
			{
				"<leader>dO",
				function()
					require("dap").step_over()
				end,
			},
			{
				"<leader>dp",
				function()
					require("dap").pause()
				end,
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle()
				end,
			},
			{
				"<leader>ds",
				function()
					require("dap").session()
				end,
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
			},
		},
		cmd = {
			"DapSetLogLevel",
			"DapShowLog",
			"DapContinue",
			"DapToggleBreakpoint",
			"DapToggleRepl",
			"DapStepOver",
			"DapStepInto",
			"DapStepOut",
			"DapTerminate",
			"DapLoadLaunchJSON",
			"DapRestartFrame",
		},
	},
}
