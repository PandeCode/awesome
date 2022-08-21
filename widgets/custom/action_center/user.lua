local wibox = require("wibox")
local gears = require("gears")
local generics = require("widgets.generics")

function generate_user(args)
	local user_name = args.user_name or os.getenv("USER")
	local user_icon = args.user_icon or os.getenv("HOME") .. "/Pictures/Wallpapers/Sakura_Nene_CPP.jpg"
	local user_icon_size = args.user_icon_size or 30
	local background_color = args.background_color or generics._default_background_color
	local border_color = args.border_color or generics._default_border_color
	local border_width = args.border_width or generics._default_border_width

	local user = wibox.widget({
		{
			generics.add_padding({
				{
					widget = wibox.widget.imagebox,
					image = user_icon,
					clip_shape = gears.shape.circle,
					shape_border_width = border_width,
					shape_border_color = border_color,
					forced_width = user_icon_size,
					forced_height = user_icon_size,
				},
				{
					markup = user_name,
					align = "center",
					halign = "center",
					widget = wibox.widget.textbox,
				},
				layout = wibox.layout.flex.vertical,
			}),
			widget = wibox.widget.background,
			bg = background_color,
			shape = generics._default_shape,
			shape_border_width = border_width,
			shape_border_color = border_color,
		},
		layout = wibox.layout.flex.vertical,
	})

	return user
end

return generate_user
