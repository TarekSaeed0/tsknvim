return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = { "williamboman/mason.nvim" },
				opts = {
					ensure_installed = { "codelldb" },
					handlers = {},
				},
				cmd = { "DapInstall", "DapUninstall" },
			},
			{
				"rcarriga/nvim-dap-ui",
				config = function()
					local dap = require("dap")
					local dapui = require("dapui")

					local opts = require("dapui.config")
					opts.layouts[1].size = 0.25
					opts.layouts[2].size = 0.25

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
			},
		},
		config = function()
			for name, icon in pairs({ DapBreakpoint = "●", DapBreakpointCondition = "●", DapLogPoint = "◆" }) do
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = name })
			end
		end
	},
}
