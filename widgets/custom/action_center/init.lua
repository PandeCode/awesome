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
---@field hide                 function
---@field show                 function
---@field toggle               function

---@class GenerateActionCenterArgs
---@field background_color       Color          default="#222831"
---@field background_color_panel Color          default="#393E46"
---@field foreground_color       Color          default="#EEEEEE"
---@field alternate              Color          default="#00ADB5"
---@field border_radius          number         default=10
---@field border_width           number         default=1
---@field border_width_panel     number         default=2
---@field border_color           Color          default=beautiful.border_color_normal
---@field border_color_panel     Color          default=beautiful.border_color_active
---@field main_margin            number         default=10
---@field user_icon_size         number         default=50
---@field user_icon              Path           default=~/.user_icon
---@field opacity                number         default=1 range(0..1)
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
	if args == nil then
		args = {}
	end

	-- stylua: ignore start
	local _background_color       = args.background_color       or beautiful.bg_normal
	local _background_color_panel = args.background_color_panel or beautiful.bg_focused
	local _foreground_color       = args.foreground_color       or beautiful.fg_normal
	local _alternate              = args.alternate              or beautiful.alternate_color
	local _border_radius          = args.border_radius          or beautiful.border_width
	local _border_width           = args.border_width           or beautiful.border_width
	local _border_width_panel     = args.border_width_panel     or beautiful.border_width
	local _border_color           = args.border_color           or beautiful.border_color_normal
	local _border_color_panel     = args.border_color_panel     or beautiful.border_color_active
	local _main_margin            = args.main_margin            or 10
	local _user_icon              = args.user_icon              or os.getenv("HOME") .. "/.user_icon"
	local _user_icon_size         = args.user_icon_size         or 70
	local _opacity                = args.opacity                or 1
	local _height                 = args.height                 or 500
	local _width                  = args.width                  or 500
	local _spacing                = args.spacing                or 10
	local _position               = args.position               or "top_right"
	local _x_offset               = args.x_offset               or -40
	local _y_offset               = args.y_offset               or 40
	local _animations             = args.animations             or true
	-- stylua: ignore end

	_M.action_center = awful.popup({
		ontop = true,
		visible = false,

		opacity = _opacity,
		height = _height,
		width = _width,

		shape = generics.generate_rounded_rect(_border_radius),
		shape_border_width = _border_width,
		shape_border_color = _border_color,

		placement = awful.placement.top_left,
		offset = { x = -100, y = 100 },
		bg = _background_color,

		widget = wibox.widget({})
	})


	local body = wibox.widget({
		forced_height = _height * 0.9,
		layout = wibox.layout.grid,
		homogeneous = true,
		expand = true,
		spacing = _spacing,
		min_cols_size = 3,
		min_rows_size = 3,
	})

	local controllers = generics.generate_controllers(_M.action_center)
	_M.show           = controllers.show
	_M.hide           = controllers.hide
	_M.toggle         = controllers.toggle

	local head = wibox.widget({
		height = _height * 0.05,
		bg = _alternate,
		layout = wibox.layout.align.horizontal,
		spacing = _spacing,
		wibox.widget({}),
		generics.generic_widget({ text = "Action Center", foreground_color = _foreground_color, border = false }),
		awesomebuttons.with_icon({
			onclick = _M.toggle,
			type = "outline",
			shape = "circle",
			icon = "x",
			color = _alternate,
		}),
	})

	local user = require("widgets.custom.action_center.user")({
		user_icon = _user_icon,
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

	_M.action_center:setup({
		layout = wibox.layout.manual,
		(generics.add_padding({
			layout = wibox.layout.fixed.vertical,
			spacing = _main_margin,
			head,
			body,
		})),
	})

	awful.placement.align(_M.action_center, {
		position = _position,
		offset = { x = _x_offset, y = _y_offset },
	})

	return _M
end

return generate_action_center
