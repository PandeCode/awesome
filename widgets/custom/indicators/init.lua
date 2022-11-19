local wibox = require("wibox")
local awful = require("awful")
-- local beautiful = require("beautiful")
local tools = require("tools")
local gears = require("gears")
local generics = require("widgets.generics")

---@class GenerateIndicatorsArgs
---@field indicators WiboxWidget
---@field toggle_indicators function
---@field show_indicators function
---@field hide_indicators function

---@class GenerateIndicatorsReturn

---comment
---@param args any
---@return GenerateIndicatorsArgs
function generate_indicators(args)
	---@type GenerateIndicatorsArgs
	local _M = {}

	if args == nil then
		args = {}
	end

	local function generic_indicator(update_callback, update_interval)
		return generics.generic_widget({
			shape = gears.shape.rectangle,
			border = false,
			update_callback = update_callback,
			update_interval = update_interval,
		})
	end

	local ping= generic_indicator(tools.get_formatted_ping, 5)
	local cpu= generic_indicator(tools.get_formatted_cpu, 5)
	local ram= generic_indicator(tools.get_formatted_ram, 5)
	local swap= generic_indicator(tools.get_formatted_swap, 5)
	local clock= generic_indicator(os.date, 1)
	local battery= generic_indicator(tools.get_formatted_battery, 5)

	local sep = wibox.widget({ widget = wibox.widget.separator, orientation = "vertical", forced_width = 4 })

	_M.indicators = wibox.widget({
		layout = wibox.layout.fixed.horizontal,

		generics.wrap_margin({
			layout = wibox.layout.fixed.horizontal,
			ping, sep, cpu, sep, ram, swap, sep, clock, sep, battery,
		}),

		awful.screen.focused().layoutbox,

		sep,

		generics.wrap_margin(wibox.widget.systray())
	})

	function _M.hide_indicators()
		if not _M.indicators.visible then
			return
		end
		_M.visible = false
	end

	function _M.show_indicators()
		if _M.indicators.visible then
			return
		end
		_M.visible = true
	end

	function _M.toggle_indicators()
		if _M.indicators.visible then
			_M.hide_indicators()
		else
			_M.show_indicators()
		end
	end

	return _M
end

return generate_indicators
