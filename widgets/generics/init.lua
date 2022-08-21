local _M = {}
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

_M._default_foreground = "#EEEEEE"
_M._default_background_color = "#222831"
_M._default_background_color_secondary = "#393E46"
_M._default_border_color = "#00ADB5"
_M._default_border_width = 1
_M._default_margin = 10

function _M._default_shape(cr, width, height)
	gears.shape.rounded_rect(cr, width, height, 10)
end

function _M.generate_rounded_rect(border_radius)
	return function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, border_radius)
	end
end

function _M.generic_widget(args)
	return wibox.widget({
		{
			{
				widget = wibox.widget.textbox,
				align = "center",
				valign = "center",
				markup = "<span foreground='"
					.. (args.foreground or _M._default_foreground)
					.. "'>"
					.. (args.text or "generic_widget")
					.. "</span>",
			},
			margin = args.margin or _M._default_margin,
			widget = wibox.container.margin,
		},
		shape = _M._default_shape,
		shape_border_width = args.border_width or _M._default_border_width,
		shape_border_color = args.border_color or _M._default_border_color,
		widget = wibox.container.background,
		bg = args.background or _M._default_background_color_secondary,
	})
end

function _M.generic_button(args, callback)
	local widget = _M.generic_widget(args)
	widget:add_button({ awful.button({}, 1, callback, nil) })

	local old_color = widget.bg

	widget:connect_signal("button::press", function()
		widget.bg = _M._default_background_color
	end)
	widget:connect_signal("button::release", function()
		widget.bg = old_color
	end)
	widget:connect_signal("mouse::enter", function()
		widget.bg = _M._default_border_color
	end)
	widget:connect_signal("mouse::leave", function()
		widget.bg = old_color
	end)

	return widget
end

return _M
