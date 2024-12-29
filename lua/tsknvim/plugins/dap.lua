---@type LazySpec[]
return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
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
					opts.layouts[1].size = 0.2
					opts.layouts[2].size = 0.25
					opts.floating.border = "rounded"

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
						desc = "Dap UI",
					},
					{
						"<leader>de",
						function()
							require("dapui").eval()
						end,
						desc = "Evaluate",
						mode = { "n", "v" },
					},
				},
			},
		},
		config = function()
			for name, icon in pairs({
				DapBreakpoint = "",
				DapBreakpointCondition = "",
				DapLogPoint = ".>",
				DapStopped = "󰁕",
				DapBreakpointRejected = "",
			}) do
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = name })
			end
		end,
		keys = {
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Breakpoint Condition",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Run/Continue",
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
				desc = "Run with Args",
			},
			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to Cursor",
			},
			{
				"<leader>dg",
				function()
					require("dap").goto_()
				end,
				desc = "Go to Line (No Execute)",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>dj",
				function()
					require("dap").down()
				end,
				desc = "Down",
			},
			{
				"<leader>dk",
				function()
					require("dap").up()
				end,
				desc = "Up",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>do",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>dP",
				function()
					require("dap").pause()
				end,
				desc = "Pause",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle()
				end,
				desc = "Toggle REPL",
			},
			{
				"<leader>ds",
				function()
					require("dap").session()
				end,
				desc = "Session",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>dw",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Widgets",
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
