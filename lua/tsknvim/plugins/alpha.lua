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
			local theme = require("alpha.themes.dashboard")

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

			math.randomseed(os.time())
			local header = headers[math.random(#headers)]
			if #header.big + 2 * #theme.section.buttons.val + 1 <= vim.opt.lines:get() and vim.fn.strdisplaywidth(header.big[1]) < vim.opt.columns:get() then
				theme.section.header.val = header.big
			else
				theme.section.header.val = header.small
			end
			theme.section.header.opts.hl = "AlphaHeader"

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

			local colors = require("catppuccin.palettes").get_palette()

			theme.section.buttons.val = {}
			for _, button in ipairs(buttons) do
				table.insert(theme.section.buttons.val, {
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
							{ "AlphaButtonSegment1", 0, (""):len() },
							{ "AlphaButtonSegment2", (""):len(), (" "..button.icon.." "):len() },
							{ "AlphaButtonSegment1", (" "..button.icon.." "):len(), (" "..button.icon.." "):len() },
							{ "AlphaButtonSegment3", (" "..button.icon.." "):len(), (" "..button.icon.."  "..button.text.." "):len() },
							{ "AlphaButtonSegment4", (" "..button.icon.."  "..button.text.." "):len(), (" "..button.icon.."  "..button.text.." "):len() },
						},
						position = "center",
						cursor = -2,
						width = math.min(50, vim.fn.strchars(theme.section.header.val[1])),
					}
				})
			end

			return theme.config
		end,
		cmd = "Alpha",
	}
}
