return {
	{
		"snacks.nvim",
		---@module "snacks"
		---@type snacks.Config
		opts = {
			dashboard = {
				preset = {
					header = [[                ██  ██  ██  ██████                
                ██  ██  ██      ██                
                ██  ██  ██  ██████                
                ██  ██  ██  ██  ██                
        ██████  ██  ██  ██  ██████  ██████        
        ██  ██  ██  ██  ██  ██      ██  ██        
        ██████████████  ██  ██████  ██████        
                            ██      ██            
██████████  ██  ██  ██  ██  ██████  ██████████████
██  ██  ██  ██  ██  ██  ██  ██      ██            
██  ██████████████████████  ██████  ██████████████
                            ██                    
██████████████  ██████  ██  ██████  ██████████████
                    ██                            
██████████████  ██████  ██████████████████████  ██
            ██      ██  ██  ██  ██  ██  ██  ██  ██
██████████████  ██████  ██  ██  ██  ██  ██████████
            ██      ██                            
        ██████  ██████  ██  ██████████████        
        ██  ██      ██  ██  ██  ██  ██  ██        
        ██████  ██████  ██  ██  ██  ██████        
                ██  ██  ██  ██  ██                
                ██████  ██  ██  ██                
                ██      ██  ██  ██                
                ██████  ██  ██  ██                ]],
				},
			},
		},
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ui = {
				border = "rounded",
				height = 0.8,
			},
		},
	},
	{
		"folke/snacks.nvim",
		---@module "snacks"
		---@type snacks.Config
		opts = {
			indent = {
				indent = {
					char = "▏",
				},
				scope = {
					char = "▏",
				},
			},
			input = { enabled = false },
			notifier = {
				margin = { right = 0 },
			},
			statuscolumn = { enabled = false },
			styles = {
				---@diagnostic disable-next-line: missing-fields
				---@diagnostic disable-next-line: missing-fields
				float = { backdrop = false },
				---@diagnostic disable-next-line: missing-fields
				notification = {
					wo = {
						winblend = 0,
						wrap = true,
					},
				},
				---@diagnostic disable-next-line: missing-fields
				zen = {
					backdrop = { bg = "#11111b", transparent = false, blend = 0 },
				},
			},
		},
	},
	{
		"folke/noice.nvim",
		opts = {
			presets = {
				bottom_search = false,
				command_palette = false,
				lsp_doc_border = true,
			},
			routes = {},
			popupmenu = {
				backend = "cmp",
			},
			lsp = {
				progress = {
					view = "notify",
				},
			},
			views = {
				notify = { replace = true },
			},
		},
	},
}
