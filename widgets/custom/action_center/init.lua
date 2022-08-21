-- stylua: ignore start
local awesomebuttons = require("modules.awesome-buttons.awesome-buttons")
local wibox          = require("wibox")
local beautiful      = require("beautiful")
local awful          = require("awful")
local gears          = require("gears")
local rubato         = require("modules.rubato")
local generics       = require("widgets.generics")

---@alias Path string
---@alias AwfulPlacement
---| "top_left"
---| "top_right"
---| "bottom_left"
---| "bottom_right"
---| "left"
---| "right"
---| "top"
---| "bottom"
---| "centered"
---| "center_vertical"
---| "center_horizontal"

---@class GenerateActionCenterReturn
---@field action_center        WiboxWidget
---@field hide_action_center   function
---@field show_action_center   function
---@field toggle_action_center function

---@class GenerateActionCenterArgs
---@field background_color       Color          default="#222831"
---@field background_color_panel Color          default="#393E46"
---@field foreground_color       Color          default="#EEEEEE"
---@field alternate              Color          default="#00ADB5"
---@field border_radius          number         default=10
---@field border_width           number         default=1
---@field border_width_panel     number         default=2
---@field border_color           Color          default=beautiful.border_color_active
---@field main_margin            number         default=10
---@field user_icon_size         Path           default=50
---@field height                 number         default=500
---@field width                  number         default=500
---@field spacing                number         default=10
---@field position               AwfulPlacement default="top_right"
---@field x_offset               number         default=-40
---@field y_offset               number         default=40
---@field animations             boolean        default=true

---comment
---@param args GenerateActionCenterArgs
---@return GenerateActionCenterReturn
function generate_action_center(args)
	local _M = {}

	-- stylua: ignore start
	local _background_color       = (args or {}).background_color       or "#222831"
	local _background_color_panel = (args or {}).background_color_panel or "#393E46"
	local _foreground_color       = (args or {}).foreground_color       or "#EEEEEE"
	local _alternate              = (args or {}).alternate              or "#00ADB5"
	local _border_radius          = (args or {}).border_radius          or 10
	local _border_width           = (args or {}).border_width           or 1
	local _border_width_panel     = (args or {}).border_width_panel     or 2
	local _border_color           = (args or {}).border_color           or beautiful.border_color_active
	local _main_margin            = (args or {}).main_margin            or 10
	local _user_icon_size         = (args or {}).user_icon_size         or 50
	local _height                 = (args or {}).height                 or 500
	local _width                  = (args or {}).width                  or 500
	local _spacing                = (args or {}).spacing                or 10
	local _position               = (args or {}).position               or "top_right"
	local _x_offset               = (args or {}).x_offset               or -40
	local _y_offset               = (args or {}).y_offset               or 40
	local _animations             = (args or {}).animations             or true
	-- stylua: ignore end

	function _M.set_width(width)
		if width == 0 then
			_M.action_center.width = 1
		else
			_M.action_center.width = width
		end
	end
	function _M.set_height(height)
		if height == 0 then
			_M.action_center.height = 1
		else
			_M.action_center.height = height
		end
	end
	function _M.show_action_center()
		if _M.action_center.visible then
			return
		end
		_M.action_center.visible = true

		if _animations then
			local timed_width = rubato.timed({
				intro = 0.1,
				duration = 0.5,
				easing = rubato.quadratic,
				pos = 0,
				subscribed = _M.set_width,
			})
			local timed_height = rubato.timed({
				intro = 0.1,
				duration = 0.5,
				easing = rubato.quadratic,
				pos = 0,
				subscribed = _M.set_height,
			})
			timed_height.target = _height
			timed_width.target = _width
		end
	end

	function _M.hide_action_center()
		if not _M.action_center.visible then
			return
		end

		if _animations then
			local timed_width = rubato.timed({
				intro = 0.1,
				duration = 0.5,
				easing = rubato.quadratic,
				pos = _width,
				subscribed = _M.set_width,
			})
			local timed_height = rubato.timed({
				intro = 0.1,
				duration = 0.5,
				easing = rubato.quadratic,
				pos = _height,
				subscribed = _M.set_height,
			})
			timed_height.target = 1
			timed_width.target = 1

			gears.timer({
				timeout = 0.6,
				autostart = true,
				single_shot = true,
				callback = function() _M.action_center.visible = false end,
			})
			return
		end
		_M.action_center.visible = false
	end

	function _M.toggle_action_center()
		if _M.action_center.visible then
			_M.hide_action_center()
		else
			_M.show_action_center()
		end
	end

	local body = wibox.widget({
		forced_height = _height * 0.9,
		layout = wibox.layout.grid,
		homogeneous = true,
		expand = true,
		spacing = _spacing,
		min_cols_size = 3,
		min_rows_size = 3,
	})

	local head = wibox.widget({
		height = _height * 0.05,
		bg = _alternate,
		layout = wibox.layout.align.horizontal,
		spacing = _spacing,
		wibox.widget({}),
		generics.generic_widget({ text = "Action Center", foreground_color = _foreground_color, border = false }),
		awesomebuttons.with_icon({
			onclick = _M.toggle_action_center,
			type = "outline",
			shape = "circle",
			icon = "x",
			color = _alternate,
		}),
	})

	local user = require("widgets.custom.action_center.user")({
		user_icon = os.getenv("HOME") .. "/Pictures/Wallpapers/Sakura_Nene_CPP.jpg",
		user_icon_size = _user_icon_size,
		background_color = _background_color_panel,
		border_color = _border_color_panel,
		border = false,
	})
	local info = require("widgets.custom.action_center.info")({ 
		background_color = _background_color_panel,
		border_color = _border_color_panel,
		border_width = _border_width_panel,
	})
	local stats = generics.generic_widget({ text = "stats" })
	local power = generics.generic_widget({ text = "power" })

	body:add_widget_at(user, 1, 1, 1, 1)
	body:add_widget_at(info, 1, 2, 1, 2)
	body:add_widget_at(stats, 2, 1, 1, 3)
	body:add_widget_at(power, 3, 1, 1, 3)

	_M.action_center = wibox({
		ontop = true,
		visible = false,

		height = _height,
		width = _width,

		shape = generics.generate_rounded_rect(_border_radius),
		shape_border_width = _border_width,
		shape_border_color = _border_color,

		placement = awful.placement.top_left,
		offset = { x = -100, y = 100 },
		bg = _background_color,

		widget = generics.add_padding({
			layout = wibox.layout.fixed.vertical,
			spacing = _main_margin,
			head,
			body,
		}),
	})

	awful.placement.align(_M.action_center, {
		position = _position,
		offset = { x = _x_offset, y = _y_offset },
	})

	return _M
end

return generate_action_center
