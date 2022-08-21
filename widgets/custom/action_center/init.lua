local _M = {
	action_center = {},
}

local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local generics = require("widgets.generics")

local _background_color = "#222831"
local _background_color_panel = "#393E46"
local _foreground = "#EEEEEE"
local _alternate = "#00ADB5"

local _border_radius = 10
local _border_width = 1
local _border_width_panel = 2
local _border_color = beautiful.border_color_active
local _main_margin = 10

local _maximum_height = 500
local _minimum_height = 500
local _maximum_width = 500
local _minimum_width = 500

local _spacing = 10

local w = wibox.widget({
	forced_height = _maximum_height * .9,
	layout = wibox.layout.grid,
	homogeneous = true,
	expand = true,
	spacing = _spacing,
	min_cols_size = 3,
	min_rows_size = 3,
})

local ui_control = wibox.widget({
	forced_height = _maximum_height * .05,
	bg = _alternate,
	layout = wibox.layout.grid,

	homogeneous = true,
	expand = true,
	spacing = _spacing,
	min_cols_size = 3,
	min_rows_size = 3,

})

local m = wibox.widget({
	layout = wibox.layout.fixed.vertical,
	spacing = _spacing,
	ui_control,
	w
})

ui_control:add_widget_at(
	generics.generic_widget({
		text = "Action Center",
	}),
	1,
	1,
	1,
	2
)
ui_control:add_widget_at(
	generics.generic_widget({ margin = 100, text = "Close", border_width = 2 }, function()
		_M.action_center.visible = false
	end),
	1,
	3,
	1,
	1
)

local user = generics.generic_widget({ text = "user" })
local info = generics.generic_widget({ text = "info" })
local stats = generics.generic_widget({ text = "stats" })
local power = generics.generic_widget({ text = "power" })

w:add_widget_at(user, 1, 1, 1, 1)
w:add_widget_at(info, 1, 2, 1, 2)
w:add_widget_at(stats, 2, 1, 1, 3)
w:add_widget_at(power, 3, 1, 1, 3)

_M.action_center = awful.popup({
	ontop = true,
	visible = true,
	shape = generics._default_shape,
	border_width = _border_width,
	border_color = _border_color,
	maximum_height = _maximum_height,
	minimum_height = _minimum_height,
	maximum_width = _maximum_width,
	minimum_width = _minimum_width,
	placement = awful.placement.top_right,
	offset = { x = -10, y = 10 },

	bg = _background_color,
	widget = m,
})

function _M.toggle_action_center()
	_M.action_center.visible = not _M.action_center.visible
end

function _M.show_action_center()
	_M.action_center.visible = true
end

function _M.hide_action_center()
	_M.action_center.visible = false
end

return _M
