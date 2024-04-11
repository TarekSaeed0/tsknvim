return {
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
		opts = { default = true },
		config = function(_, opts)
			local devicons = require("nvim-web-devicons")

			local colors = require("catppuccin.palettes").get_palette()
			local hsluv = require("catppuccin.lib.hsluv")

			local icons = devicons.get_icons()
			for _, icon in pairs(icons) do
				local closest_color
				local closest_distance = math.huge
				local r1, g1, b1 = unpack(hsluv.hex_to_rgb(icon.color))
				for _, color in pairs(colors) do
					local r2, g2, b2 = unpack(hsluv.hex_to_rgb(color))
					local distance = (r1 - r2) ^ 2 + (g1 - g2) ^ 2 + (b1 - b2) ^ 2
					if distance < closest_distance then
						closest_distance = distance
						closest_color = color
					end
				end
				if closest_color then
					icon.color = closest_color
				end
			end

			devicons.set_default_icon("", colors.teal)

			devicons.setup(opts)
		end,
	},
}
