return {
	{
		"tamton-aquib/duck.nvim",
		opts = function()
			local colors = require("catppuccin.palettes").get_palette()
			return {
				character = "󰇥 ",
				color = colors.yellow,
			}
		end,
		keys = {
			{ "<leader>dh", function() require("duck").hatch() end },
			{ "<leader>dc", function() require("duck").cook() end },
		},
	},
}
