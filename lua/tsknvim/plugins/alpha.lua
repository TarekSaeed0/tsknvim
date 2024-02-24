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

			theme.section.buttons.val = {
				theme.button("n" , " new file", "<cmd>ene<cr>"),
				theme.button("b" , " file browser", "<cmd>lua require(\"telescope\").extensions.file_browser.file_browser({ cwd = vim.fn.expand(\"%:p:h\") })<cr>"),
				theme.button("h" , " file history", "<cmd>lua require(\"telescope.builtin\").oldfiles()<cr>"),
				theme.button("s" , "󱎸 search ", "<cmd>lua require(\"telescope.builtin\").grep_string({ cwd = vim.fn.expand(\"%:p:h\") })<cr>"),
				theme.button("q" , "󰩈 quit", "<cmd>q<cr>"),
			}
			for _, button in ipairs(theme.section.buttons.val) do
				button.opts.width = math.min(button.opts.width, vim.fn.strchars(theme.section.header.val[1]))
				button.opts.hl_shortcut = "AlphaShortcut"
			end

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
			if #header.big + 2 * #theme.section.buttons.val + 1 <= vim.opt.lines:get() and vim.fn.strchars(header.big[1]) < vim.opt.columns:get() then
				theme.section.header.val = header.big
			else
				theme.section.header.val = header.small
			end
			theme.section.header.opts.hl = "AlphaHeader"

			return theme.config
		end,
		cmd = "Alpha",
	}
}
