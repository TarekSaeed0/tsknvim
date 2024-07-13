return {
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		init = function()
			if vim.fn.argc() == 0 then
				vim.api.nvim_create_autocmd("User", {
					pattern = "LazyVimStarted",
					once = true,
					callback = function()
						if vim.opt.buftype:get() == "" then
							require("alpha").start(false)
						end
					end,
				})
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

			local stats = require("lazy").stats()
			local message = ("󰏗 Loaded %d/%d plugins  Startup time %gms"):format(
				stats.loaded + 1,
				stats.count,
				stats.startuptime
			)

			local buttons = {
				{
					shortcut = "n",
					icon = "",
					text = "New File",
					command = "<cmd>ene<cr>",
				},
				{
					shortcut = "b",
					icon = "",
					text = "File Browser",
					command = '<cmd>lua require("telescope").extensions.file_browser.file_browser({ cwd = vim.fn.expand("%:p:h") })<cr>',
				},
				{
					shortcut = "h",
					icon = "",
					text = "File History",
					command = '<cmd>lua require("telescope.builtin").oldfiles()<cr>',
				},
				{
					shortcut = "s",
					icon = "",
					text = "Search",
					command = '<cmd>lua require("telescope.builtin").grep_string({ cwd = vim.fn.expand("%:p:h") })<cr>',
				},
				{
					shortcut = "q",
					icon = "󰩈",
					text = "Quit",
					command = "<cmd>q<cr>",
				},
			}

			local version = vim.version()
			local footer = (" Neovim" .. (version.prerelease and " nightly" or "") .. " v%d.%d.%d"):format(
				version.major,
				version.minor,
				version.patch
			)

			math.randomseed(os.time())
			local header = headers[math.random(#headers)]
			if
				#header.big + 3 + #buttons + 2 <= vim.opt.lines:get()
				and vim.fn.strdisplaywidth(header.big[1]) < vim.opt.columns:get()
			then
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

			--[[ local curl = require("plenary.curl")
			local ok, response = pcall(curl.get, "https://zenquotes.io/api/random")
			if ok and response.status == 200 then
				local body = vim.json.decode(response.body)

				vim.notify(('"%s" - %s'):format(body[1].q, body[1].a))
			end ]]

			section.message = {
				type = "text",
				val = " " .. message .. " ",
				opts = {
					position = "center",
					hl = {
						{ "AlphaSegment4", 0, (""):len() },
						{ "AlphaSegment3", (""):len(), (" " .. message .. " "):len() },
						{ "AlphaSegment4", (" " .. message .. " "):len(), (" " .. message .. " "):len() },
					},
				},
			}

			local maximum_shortcut_length = 0
			local maximum_icon_length = 0
			local maximum_text_length = 0
			for _, button in ipairs(buttons) do
				maximum_shortcut_length = math.max(maximum_shortcut_length, vim.fn.strdisplaywidth(button.shortcut))
				maximum_icon_length = math.max(maximum_icon_length, vim.fn.strdisplaywidth(button.icon))
				maximum_text_length = math.max(maximum_text_length, vim.fn.strdisplaywidth(button.text))
			end

			section.buttons = {
				type = "group",
				val = {},
			}
			for _, button in ipairs(buttons) do
				local shortcut = button.shortcut
					.. (" "):rep(maximum_shortcut_length - vim.fn.strdisplaywidth(button.shortcut))
				local icon = button.icon .. (" "):rep(maximum_icon_length - vim.fn.strdisplaywidth(button.icon))
				local text = button.text .. (" "):rep(maximum_text_length - vim.fn.strdisplaywidth(button.text))
				table.insert(section.buttons.val, {
					type = "button",
					val = " " .. icon .. "  " .. text .. " ",
					on_press = function()
						vim.api.nvim_feedkeys(
							vim.api.nvim_replace_termcodes(button.command, true, false, true),
							"t",
							false
						)
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
							{ "AlphaSegment2", (""):len(), (" " .. icon .. " "):len() },
							{ "AlphaSegment1", (" " .. icon .. " "):len(), (" " .. icon .. " "):len() },
							{
								"AlphaSegment3",
								(" " .. icon .. " "):len(),
								(" " .. icon .. "  " .. text .. " "):len(),
							},
							{
								"AlphaSegment4",
								(" " .. icon .. "  " .. text .. " "):len(),
								(" " .. icon .. "  " .. text .. " "):len(),
							},
						},
						shortcut = " " .. shortcut .. " ",
						align_shortcut = "right",
						hl_shortcut = {
							{ "AlphaSegment4", 0, (""):len() },
							{ "AlphaSegment3", (""):len(), (" " .. shortcut .. " "):len() },
							{
								"AlphaSegment4",
								(" " .. shortcut .. " "):len(),
								(" " .. shortcut .. " "):len(),
							},
						},
						position = "center",
						cursor = -2,
						width = math.max(
							2 + maximum_icon_length + 4 + maximum_text_length + 4 + maximum_shortcut_length + 2,
							vim.fn.strchars(section.header.val[1])
						),
					},
				})
			end

			section.footer = {
				type = "text",
				val = " " .. footer .. " ",
				opts = {
					position = "center",
					hl = {
						{ "AlphaSegment4", 0, (""):len() },
						{ "AlphaSegment3", (""):len(), (" " .. footer .. " "):len() },
						{ "AlphaSegment4", (" " .. footer .. " "):len(), (" " .. footer .. " "):len() },
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
	},
}
