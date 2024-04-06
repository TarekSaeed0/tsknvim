return {
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		init = function()
			if vim.fn.argc() == 0 then
				require("alpha")
			end
			vim.api.nvim_create_autocmd("User", {
				pattern = "AlphaReady",
				callback = function(event)
					local laststatus = vim.opt.laststatus:get()
					vim.opt.laststatus = 0
					local showtabline = vim.opt.showtabline:get()
					vim.opt.showtabline = 0
					vim.api.nvim_create_autocmd("BufUnload", {
						buffer = event.buf,
						once = true,
						callback = function()
							vim.opt.laststatus = laststatus
							vim.opt.showtabline = showtabline
						end,
					})
				end,
			})
		end,
		opts = function()
			local section = {}

			local headers = {
				{
					big = {
						[[                ██  ██  ██  ██████                ]],
						[[                ██  ██  ██      ██                ]],
						[[                ██  ██  ██  ██████                ]],
						[[                ██  ██  ██  ██  ██                ]],
						[[        ██████  ██  ██  ██  ██████  ██████        ]],
						[[        ██  ██  ██  ██  ██  ██      ██  ██        ]],
						[[        ██████████████  ██  ██████  ██████        ]],
						[[                            ██      ██            ]],
						[[██████████  ██  ██  ██  ██  ██████  ██████████████]],
						[[██  ██  ██  ██  ██  ██  ██  ██      ██            ]],
						[[██  ██████████████████████  ██████  ██████████████]],
						[[                            ██                    ]],
						[[██████████████  ██████  ██  ██████  ██████████████]],
						[[                    ██                            ]],
						[[██████████████  ██████  ██████████████████████  ██]],
						[[            ██      ██  ██  ██  ██  ██  ██  ██  ██]],
						[[██████████████  ██████  ██  ██  ██  ██  ██████████]],
						[[            ██      ██                            ]],
						[[        ██████  ██████  ██  ██████████████        ]],
						[[        ██  ██      ██  ██  ██  ██  ██  ██        ]],
						[[        ██████  ██████  ██  ██  ██  ██████        ]],
						[[                ██  ██  ██  ██  ██                ]],
						[[                ██████  ██  ██  ██                ]],
						[[                ██      ██  ██  ██                ]],
						[[                ██████  ██  ██  ██                ]],
					},
					small = {
						[[        ▄ ▄ ▄ ▄▄▄        ]],
						[[        █ █ █ ▄▄█        ]],
						[[    ▄▄▄ █ █ █ █▄█ ▄▄▄    ]],
						[[    █▄█▄█▄█ █ █▄▄ █▄█    ]],
						[[▄▄▄▄▄ ▄ ▄ ▄ ▄ █▄▄ █▄▄▄▄▄▄]],
						[[█ █▄█▄█▄█▄█▄█ █▄▄ █▄▄▄▄▄▄]],
						[[▄▄▄▄▄▄▄ ▄▄▄ ▄ █▄▄ ▄▄▄▄▄▄▄]],
						[[▄▄▄▄▄▄▄ ▄▄█ ▄▄▄▄▄▄▄▄▄▄▄ ▄]],
						[[▄▄▄▄▄▄█ ▄▄█ █ █ █ █ █▄█▄█]],
						[[    ▄▄█ ▄▄█ ▄ ▄▄▄▄▄▄▄    ]],
						[[    █▄█ ▄▄█ █ █ █ █▄█    ]],
						[[        █▄█ █ █ █        ]],
						[[        █▄▄ █ █ █        ]],
					},
				},
				{
					big = {
						[[██████  ██  ██  ██  ██  ██  ██]],
						[[██  ██  ██  ██  ██  ██  ██  ██]],
						[[██████████████████████  ██  ██]],
						[[██                      ██  ██]],
						[[██  ██  ██  ██  ██  ██  ██  ██]],
						[[    ██  ██  ██  ██      ██  ██]],
						[[██████  ██  ██  ██  ██  ██  ██]],
						[[██  ██  ██  ██  ██  ██  ██  ██]],
						[[██████████████  ██  ██  ██  ██]],
						[[                    ██  ██  ██]],
						[[██  ██    ████████  ██      ██]],
						[[    ██          ██  ██  ██  ██]],
						[[██  ██████████████  ██  ██  ██]],
						[[██  ██  ██  ██      ██  ██  ██]],
						[[██████  ██████  ██████  ██  ██]],
						[[                ██      ██  ██]],
						[[██████████████████  ██  ██  ██]],
						[[                    ██  ██  ██]],
						[[██████████  ██████  ██  ██  ██]],
						[[██  ██  ██      ██  ██  ██  ██]],
						[[██████  ██████████  ██████  ██]],
						[[██                  ██      ██]],
						[[██  ██  ██  ██████████  ██████]],
					},
					small = {
						[[▄▄▄ ▄ ▄ ▄ ▄ ▄ ▄]],
						[[█▄█▄█▄█▄█▄█ █ █]],
						[[█ ▄ ▄ ▄ ▄ ▄ █ █]],
						[[▄▄█ █ █ █ ▄ █ █]],
						[[█▄█▄█▄█ █ █ █ █]],
						[[▄ ▄  ▄▄▄▄ █ ▀ █]],
						[[▄ █▄▄▄▄▄█ █ █ █]],
						[[█▄█ █▄█ ▄▄█ █ █]],
						[[▄▄▄▄▄▄▄▄█ ▄ █ █]],
						[[▄▄▄▄▄ ▄▄▄ █ █ █]],
						[[█▄█ █▄▄▄█ █▄█ █]],
						[[█ ▄ ▄ ▄▄▄▄█ ▄▄█]],
					},
				},
			}

			local message = "Select one of the following options"

			local buttons = {
				{
					shortcut = "n",
					icon = "",
					text = "new file",
					command = "<cmd>ene<cr>",
				},
				{
					shortcut = "b",
					icon = "",
					text = "file browser",
					command = "<cmd>lua require(\"telescope\").extensions.file_browser.file_browser({ cwd = vim.fn.expand(\"%:p:h\") })<cr>",
				},
				{
					shortcut = "h",
					icon = "",
					text = "file history",
					command = "<cmd>lua require(\"telescope.builtin\").oldfiles()<cr>",
				},
				{
					shortcut = "s",
					icon = "",
					text = "search",
					command = "<cmd>lua require(\"telescope.builtin\").grep_string({ cwd = vim.fn.expand(\"%:p:h\") })<cr>",
				},
				{
					shortcut = "q",
					icon = "󰩈",
					text = "quit",
					command = "<cmd>q<cr>",
				},
			}

			local footer = "Arrows - Move, Enter - Select"

			math.randomseed(os.time())
			local header = headers[math.random(#headers)]
			if #header.big + 3 + #buttons + 2 <= vim.opt.lines:get() and vim.fn.strdisplaywidth(header.big[1]) < vim.opt.columns:get() then
				header = header.big
			else
				header = header.small
			end
			section.header = {
				type = "text",
				val = header,
				opts = {
					position = "center",
					hl = "AlphaHeader",
				},
			}

			section.message = {
				type = "text",
				val = " "..message.." ",
				opts = {
					position = "center",
					hl = {
						{ "AlphaSegment4", 0, (""):len() },
						{ "AlphaSegment3", (""):len(), (" "..message.." "):len() },
						{ "AlphaSegment4", (" "..message.." "):len(), (" "..message.." "):len() },
					},
				},
			}

			local maximum_icon_length = 0
			local maximum_text_length = 0
			for _, button in ipairs(buttons) do
				maximum_icon_length = math.max(maximum_icon_length, vim.fn.strdisplaywidth(button.icon))
				maximum_text_length = math.max(maximum_text_length, vim.fn.strdisplaywidth(button.text))
			end

			for _, button in ipairs(buttons) do
				button.icon = button.icon..(" "):rep(maximum_icon_length - vim.fn.strdisplaywidth(button.icon))
				button.text = button.text..(" "):rep(maximum_text_length - vim.fn.strdisplaywidth(button.text))
			end

			section.buttons = {
				type = "group",
				val = {},
				-- opts = { spacing = 1 },
			}
			for _, button in ipairs(buttons) do
				table.insert(section.buttons.val, {
					type = "button",
					val = " "..button.icon.."  "..button.text.." ",
					on_press = function()
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(button.command, true, false, true), "t", false)
					end,
					opts = {
						keymap = {
							"n",
							button.shortcut,
							button.command,
							{ noremap = true, silent = true, nowait = true },
						},
						hl = {
							{ "AlphaSegment1", 0, (""):len() },
							{ "AlphaSegment2", (""):len(), (" "..button.icon.." "):len() },
							{ "AlphaSegment1", (" "..button.icon.." "):len(), (" "..button.icon.." "):len() },
							{ "AlphaSegment3", (" "..button.icon.." "):len(), (" "..button.icon.."  "..button.text.." "):len() },
							{ "AlphaSegment4", (" "..button.icon.."  "..button.text.." "):len(), (" "..button.icon.."  "..button.text.." "):len() },
						},
						position = "center",
						cursor = -2,
						width = math.min(50, vim.fn.strchars(section.header.val[1])),
					}
				})
			end

			section.footer = {
				type = "text",
				val = " "..footer.." ",
				opts = {
					position = "center",
					hl = {
						{ "AlphaSegment4", 0, (""):len() },
						{ "AlphaSegment3", (""):len(), (" "..footer.." "):len() },
						{ "AlphaSegment4", (" "..footer.." "):len(), (" "..footer.." "):len() },
					},
				},
			}

			return {
				layout = {
					{ type = "padding", val = math.floor((vim.opt.lines:get() - (#header + 3 + #buttons + 2)) / 2) },
					section.header,
					{ type = "padding", val = 1 },
					section.message,
					{ type = "padding", val = 1 },
					section.buttons,
					{ type = "padding", val = 1 },
					section.footer,
				},
				opts = {
					margin = 5,
				},
			}

		end,
		cmd = "Alpha",
	}
}
