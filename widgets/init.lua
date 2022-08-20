local _M = {}

local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

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
	-- items = {
	--     { "awesome", _M.awesomemenu, beautiful.awesome_icon },
	--     { "open terminal", awesome.spawn(apps.terminal) },
	-- },
})

_M.launcher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = _M.mainmenu,
})

_M.keyboardlayout = awful.widget.keyboardlayout()
_M.textclock = wibox.widget.textclock()

function _M.create_promptbox()
	return awful.widget.prompt()
end

function _M.create_layoutbox(s)
	return awful.widget.layoutbox({
		screen = s,
		buttons = {
			awful.button({
				modifiers = {},
				button = 1,
				on_press = function()
					awful.layout.inc(1)
				end,
			}),
			awful.button({
				modifiers = {},
				button = 3,
				on_press = function()
					awful.layout.inc(-1)
				end,
			}),
			awful.button({
				modifiers = {},
				button = 4,
				on_press = function()
					awful.layout.inc(-1)
				end,
			}),
			awful.button({
				modifiers = {},
				button = 5,
				on_press = function()
					awful.layout.inc(1)
				end,
			}),
		},
	})
end

require("config.tag_preview")

function _M.create_taglist(s)
	-- stylua: ignore
	return awful.widget.taglist({
		screen = s,
		filter =  awful.widget.taglist.filter.noempty,
		style = {
			shape = gears.shape.powerline,
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
			{
				layout = wibox.layout.fixed.horizontal,
				_M.keyboardlayout,
				wibox.widget.systray(),
				_M.textclock,
				s.layoutbox,
			},
		},
	})
end

return _M
