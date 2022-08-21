-- stylua: ignore start
local wibox    = require("wibox")
local tools    = require("tools")
local gears    = require("gears")
local generics = require("widgets.generics")
-- stylua: ignore end

---@alias Color string
---@alias GearsShape function
---@alias WiboxWidget table

---@class GenerateInfoArgs
---@field background_color Color
---@field shape GearsShape
---@field border_color Color
---@field border_width number

---Generate an info widget
---@param args GenerateInfoArgs Arguments
---@return WiboxWidget
local function generate_info(args)
	local background_color = args.background_color or generics._default_background_color
	local shape            = args.shape or generics._default_shape
	local border_width     = args.border_width or generics._default_border_width
	local border_color     = args.border_color or generics._default_border_color

	local info_battery   = generics.generic_widget({
		border           = false,
		background_color = background_color,
		shape            = gears.shape.rectangle,
		update_interval  = 1,
		update_callback  = tools.func_exec("acpi"),
	})
	local info_date      = generics.generic_widget({
		border           = false,
		background_color = background_color,
		shape            = gears.shape.rectangle,
		update_interval  = 1,
		update_callback  = function()
			return os.date("%a, %d %B %Y")
		end,
	})
	local info_kernel    = generics.generic_widget({
		border           = false,
		background_color = background_color,
		shape            = gears.shape.rectangle,
		update_interval  = 1,
		update_callback  = tools.func_exec("uname -r"),
	})
	local info_os        = generics.generic_widget({
		border           = false,
		background_color = background_color,
		shape            = gears.shape.rectangle,
		update_callback  = tools.func_exec("uname -o"),
	})
	local info_uptime    = generics.generic_widget({
		border           = false,
		background_color = background_color,
		shape            = gears.shape.rectangle,
		update_callback  = tools.func_exec("uptime -p"),
	})

	local info = wibox.widget({
		generics.add_padding({
			{ wibox.widget.textbox("Battery :"), info_battery, layout = wibox.layout.fixed.horizontal },
			{ wibox.widget.textbox("Date    :"), info_date, layout = wibox.layout.fixed.horizontal },
			{ wibox.widget.textbox("Kernel  :"), info_kernel, layout = wibox.layout.fixed.horizontal },
			{ wibox.widget.textbox("OS      :"), info_os, layout = wibox.layout.fixed.horizontal },
			{ wibox.widget.textbox("Uptime  :"), info_uptime, layout = wibox.layout.fixed.horizontal },
			layout = wibox.layout.flex.vertical,
		}, 10),
		widget = wibox.widget.background,
		bg = background_color,
		shape = shape,
		shape_border_color = border_color,
		shape_border_width = border_width,
	})
	return info
end

return generate_info
