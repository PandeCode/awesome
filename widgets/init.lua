local _M = {}

local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local generics = require("widgets.generics")
-- local tools = require("tools")

local xresources = require("beautiful.xresources")
-- local dpi = xresources.apply_dpi

local apps = require("config.apps")
local mod = require("bindings.mod")

_M.awesomemenu = {
	{
		"hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "manual", apps.manual_cmd },
	{ "edit config", apps.editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{ "quit", awesome.quit },
}

_M.mainmenu = awful.menu({
	items = {
		{ "awesome", _M.awesomemenu, beautiful.awesome_icon },
		{ "open terminal", apps.terminal },
	},
})

_M.launcher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = _M.mainmenu,
})

function _M.create_promptbox()
	return awful.widget.prompt()
end


---@class GenerateLayoutListArgs
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
---@field height                 number         default=500
---@field width                  number         default=500
---@field spacing                number         default=10
---@field position               AwfulPlacement default="top_right"
---@field x_offset               number         default=-40
---@field y_offset               number         default=40
---@field animations             boolean        default=true

---@alias Layoutlist table awful.widget.layoutlist

---Create a layoutlist
---@param args GenerateLayoutListArgs
---@return Layoutlist
function _M.create_layoutlist(args)
	if args == nil then
		args = {}
	end

	-- stylua: ignore start
	local _background_color       = args.background_color       or "#222831"
	local _border_radius          = args.border_radius          or 10
	local _border_width           = args.border_width           or 1
	local _border_color           = args.border_color           or beautiful.border_color_normal
	local _main_margin            = args.main_margin            or 10
	local _height                 = args.height                 or #awful.layout.layouts * 25
	local _width                  = args.width                  or 150
	local _position               = args.position               or "top_right"
	local _x_offset               = args.x_offset               or -1
	local _y_offset               = args.y_offset               or 25
	local _animations             = args.animations             or true
	-- stylua: ignore end

	local layoutlist = wibox({
		ontop = true,
		visible = false,

		height = _height,
		width = _width,

		-- shape = generics.generate_rounded_rect(_border_radius),
		shape = gears.shape.infobubble,
		shape_border_width = _border_width,
		shape_border_color = _border_color,

		placement = awful.placement.top_left,
		offset = { x = _x_offset, y = _y_offset },
		bg = _background_color,

		widget = generics.add_padding (
			awful.widget.layoutlist({
				screen = 1,
				base_layout = wibox.layout.flex.vertical,
				shape = generics.generate_rounded_rect(_border_radius),
			})
		)
	})

	awful.placement.align(layoutlist, {
		position = _position,
		offset = { x = _x_offset, y = _y_offset },
	})

	return generics.generate_controllers(layoutlist)
	-- return layoutlist
end
---@diagnostic disable
---next-line: unused-local
function _M.create_layoutbox(s)
	local layoutbox = awful.widget.layoutbox({ screen = s })

	local function set_last_layout()
		if s.LAST_LAUOUT ~= nil then
			_tmp = awful.layout.get(s)
			awful.layout.set(s.LAST_LAUOUT)
			s.LAST_LAUOUT = _tmp
		end
	end
	local function show_layoutlist()
		if s.LAYOUT_LIST == nil then
			s.LAYOUT_LIST = _M.create_layoutlist()
			s.LAYOUT_LIST.show()
		else
			s.LAYOUT_LIST.toggle()
		end
	end
	local function set_next_layout()
		s.LAST_LAUOUT = awful.layout.get(awful.screen.focused())
		awful.layout.inc(1)
	end
	local function set_prev_layout()
		s.LAST_LAUOUT = awful.layout.get(awful.screen.focused())
		awful.layout.inc(-1)
	end

	layoutbox.buttons = {
		awful.button({}, 1, set_last_layout),
		awful.button({}, 3, show_layoutlist),
		awful.button({}, 4, set_next_layout),
		awful.button({}, 5, set_prev_layout),
	}

	return layoutbox
end

require("config.tag_preview")

function _M.create_taglist(s)
	-- stylua: ignore
	return awful.widget.taglist({
		screen = s,
		filter =  awful.widget.taglist.filter.noempty,
		style = {
			shape = gears.shape.rectangle,
		},
		layout = {
			spacing = beautiful.taglist_spacing,
			spacing_widget = {
				color = beautiful.border_color_marked,
				shape = gears.shape.powerline,
				widget = wibox.widget.separator,
			},
			layout = wibox.layout.fixed.horizontal,
		},
		buttons = {
			awful.button({ modifiers = {}, button = 1, on_press = function(t) t:view_only() end, }),
			awful.button({ modifiers = { mod.super }, button = 1, on_press = function(t) if client.focus then client.focus:move_to_tag(t) end end, }),
			awful.button({ modifiers = {}, button = 3, on_press = awful.tag.viewtoggle, }),
			awful.button({ modifiers = { mod.super }, button = 3, on_press = function(t) if client.focus then client.focus:toggle_tag(t) end end, }),
			awful.button({ modifiers = {}, button = 4, on_press = function(t) awful.tag.viewprev(t.screen) end, }),
			awful.button({ modifiers = {}, button = 5, on_press = function(t) awful.tag.viewnext(t.screen) end, }),
		},
		widget_template = {
			{
				{
					{
						{
							{
								id = "index_role",
								widget = wibox.widget.textbox,
							},
							margins = beautiful.taglist_index_role_margins,
							widget = wibox.container.margin,
						},
						bg = "#dddddd",
						shape = gears.shape.circle,
						widget = wibox.container.background,
					},
					{
						{
							id = "icon_role",
							widget = wibox.widget.imagebox,
						},
						margins = beautiful.taglist_icon_role_margins,
						widget = wibox.container.margin,
					},
					{
						id = "text_role",
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				left =beautiful.taglist_widget_template_margins_left,
				right =beautiful.taglist_widget_template_margins_right,
				widget = wibox.container.margin,
			},
			id = "background_role",
			widget = wibox.container.background,
			-- Add support for hover colors and an index label
			create_callback = function(self, c3, index, objects)
				self:get_children_by_id("index_role")[1].markup = "<b>"..index.."</b>"
				self:connect_signal("mouse::enter", function()

					-- BLING: Only show widget when there are clients in the tag
					if #c3:clients() > 0 then
						-- BLING: Update the widget with the new tag
						awesome.emit_signal("bling::tag_preview::update", c3)
						-- BLING: Show the widget
						awesome.emit_signal("bling::tag_preview::visibility", s, true)
					end

					if self.bg ~= beautiful.taglist_bg_focus then
						self.backup	 = self.bg
						self.has_backup = true
					end
					self.bg = beautiful.taglist_bg_focus
				end)
				self:connect_signal('mouse::leave', function()

					-- BLING: Turn the widget off
					awesome.emit_signal("bling::tag_preview::visibility", s, false)

					if self.has_backup then self.bg = self.backup end
				end)
			end,
			update_callback = function(self, c3, index, objects)
				self:get_children_by_id("index_role")[1].markup = "<b>" .. c3.index .. "</b>"
			end,
		},
	})
end

function _M.create_tasklist(s)
	return awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = {
			awful.button({
				modifiers = {},
				button = 1,
				on_press = function(c)
					c:activate({ context = "tasklist", action = "toggle_minimization" })
				end,
			}),
			awful.button({
				modifiers = {},
				button = 3,
				on_press = function()
					awful.menu.client_list({ theme = { width = 250 } })
				end,
			}),
			awful.button({
				modifiers = {},
				button = 4,
				on_press = function()
					awful.client.focus.byidx(-1)
				end,
			}),
			awful.button({
				modifiers = {},
				button = 5,
				on_press = function()
					awful.client.focus.byidx(1)
				end,
			}),
		},
	})
end

function _M.create_wibox(s)
	return awful.wibar({
		screen = s,
		position = "top",
		widget = {
			layout = wibox.layout.align.horizontal,
			-- left widgets
			{
				layout = wibox.layout.fixed.horizontal,
				_M.launcher,
				s.taglist,
				s.promptbox,
			},
			-- middle widgets
			s.tasklist,
			-- right widgets
			require("widgets.custom.indicators")().indicators,
		},
	})
end

return _M
