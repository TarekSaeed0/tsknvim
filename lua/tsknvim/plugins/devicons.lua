---@type LazySpec[]
return {
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
		opts = { default = true },
		config = function(_, opts)
			local devicons = require("nvim-web-devicons")

			devicons.setup(opts)

			local icons = devicons.get_icons()

			local function apply_theme_to_icons()
				if not vim.g.colors_name or not vim.g.colors_name:match("catppuccin") then
					return
				end

				local hsluv = require("catppuccin.lib.hsluv")

				local colors = require("catppuccin.palettes").get_palette()

				local override = {}
				for key, icon in pairs(icons) do
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
						override[key] = vim.tbl_extend("keep", { color = closest_color }, icon)
					end
				end

				devicons.set_icon(override)

				devicons.set_default_icon("", colors.teal)
			end

			apply_theme_to_icons()

			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = function()
					apply_theme_to_icons()
				end,
			})
		end,
	},
}
