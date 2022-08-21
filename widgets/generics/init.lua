local _M = {}
local wibox = require("wibox")
local gears = require("gears")

-- stylua: ignore start
_M._default_foreground_color           = "#EEEEEE"
_M._default_background_color           = "#222831"
_M._default_background_color_secondary = "#393E46"
_M._default_border_color               = "#00ADB5"
_M._default_border_width               = 1
_M._default_border_radius              = 10
_M._default_margin                     = 10
-- stylua: ignore end

---My default rounded Rect
---@param cr any
---@param width any
---@param height any
function _M._default_shape(cr, width, height)
	gears.shape.rounded_rect(cr, width, height, _M._default_border_radius)
end

---My default rounded Rect
---@param border_radius number
---@return function shape_funtion
function _M.generate_rounded_rect(border_radius)
	return function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, border_radius)
	end
end

---Add Padding to a Widget
---@param widget WiboxWidget
---@param top? number
---@param bottom? number
---@param left? number
---@param right? number
---@return WiboxWidget
function _M.add_padding(widget, top, bottom, left, right)
	if top == nil then
		top = _M._default_margin
	end
	return wibox.widget({
		widget = wibox.container.margin,
		top = top,
		left = left or top,
		right = right or top,
		bottom = bottom or top,
		widget,
	})
end

---@class GenericWidgetArgs
---@field background_color string Background Color
---@field foreground_color string Foreground Color
---@field border_color string Border Color
---@field border_width number Border Width
---@field margin number Margin Size
---@field shape function gears.shape
---@field border boolean Should display border
---@field update_interval number Update interval
---@field update_callback function Callback to return to the text

---Provide a basic highly configurable widget
---@param args GenericWidgetArgs
---@return WiboxWidget, GearsTimer
---@nodiscard
function _M.generic_widget(args)
	args.background_color = args.background_color or _M._default_background_color
	args.foreground_color = args.foreground_color or _M._default_foreground_color
	args.border_color = args.border_color or _M._default_border_color
	args.border_width = args.border_width or _M._default_border_width
	args.margin = args.margin or _M._default_margin
	args.text = args.text or "generic_widget"
	args.shape = args.shape or _M._default_shape

	if args.border == false then
		args.border_color = nil
		args.border_width = nil
	end

	local timer = {}

	local textbox = wibox.widget({
		widget = wibox.widget.textbox,
		align = "center",
		valign = "center",
		markup = "<span foreground='" .. args.foreground_color .. "'>" .. args.text .. "</span>",
	})

	local function true_callback()
		textbox:set_markup_silently(
			"<span foreground='" .. args.foreground_color .. "'>" .. tostring(args.update_callback()) .. "</span>"
		)
	end

	if args.update_callback ~= nil then
		true_callback()
	end

	if args.update_interval ~= nil then
		timer = gears.timer({ timeout = args.update_interval, call_now = true, callback = true_callback })
	end

	local widget = wibox.widget({
		{
			textbox,
			margin = args.margin,
			widget = wibox.container.margin,
		},
		shape = args.shape,
		shape_border_width = args.border_width,
		shape_border_color = args.border_color,
		widget = wibox.container.background,
		bg = args.background_color,
	})

	return widget, timer
end

return _M
