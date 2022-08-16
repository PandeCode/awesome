local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
local menubar = require("menubar")

local apps = require("config.apps")
local mod = require("bindings.mod")
local widgets = require("widgets")

local bling = require("modules.bling")

local machi = require("modules.layout-machi")
local layouts = require("config.vars").layouts

menubar.utils.terminal = apps.terminal

local modalbind = require("modules.awesome-modalbind")
modalbind.init()

local awesome_map = {
	{ "r", awesome.restart, "Restart" },
	{ "q", awesome.quit, "Quit" },
}

local machi_map = {
	{ "e", machi.default_editor.start_interactive, "edit the current layout if it is a machi layout" },
	{
		"s",
		function()
			machi.switcher.start(client.focus)
		end,
		"switch between windows for a machi layout",
	},
}

local layout_map = {
	{
		"machi",
		function()
			modalbind.grab({ keymap = machi_map, name = "Machi", stay_in_mode = false })
		end,
	},
}

for _, value in pairs(layouts) do
	table.insert(layout_map, {
		value.name,
		function()
			awful.layout.set(value)
		end,
	})
end

local tabbed_map = {
	{ "p", bling.module.tabbed.pick, "picks a client with your cursor to add to the tabbing group" },
	{ "r", bling.module.tabbed.pop, "removes the focused client from the tabbing group" },
	{ "i", bling.module.tabbed.iter, "iterates through the currently focused tabbing group" },
	{
		"d",
		bling.module.tabbed.pick_with_dmenu,
		"picks a client with a dmenu application (defaults to rofi, other options can be set with a string parameter like 'dmenu')",
	},
	{
		"k",
		function()
			bling.module.tabbed.pick_by_direction("up")
		end,
		"picks a client based on direction",
	},
	{
		"j",
		function()
			bling.module.tabbed.pick_by_direction("down")
		end,
		"picks a client based on direction",
	},
	{
		"h",
		function()
			bling.module.tabbed.pick_by_direction("left")
		end,
		"picks a client based on direction",
	},
	{
		"l",
		function()
			bling.module.tabbed.pick_by_direction("right")
		end,
		"picks a client based on direction",
	},
}
local window_swallowing_map = {
	{ "s", bling.module.window_swallowing.start, "activates window swallowing" },
	{
		"e",
		bling.module.window_swallowing.stop,
		"deactivates window swallowing",
	},
	{
		"t",
		bling.module.window_swallowing.toggle,
		"toggles window swallowing",
	},
}
local term_scratch = require("config.term_scratch").term_scratch
local term_scratch_map = {
	{
		"t",
		function()
			term_scratch:toggle()
		end,
		"toggles visibility",
	},
	{
		"o",
		function()
			term_scratch:turn_on()
		end,
		"visibility on",
	},
	{
		"s",
		function()
			term_scratch:turn_off()
		end,
		"visibility off",
	},
}
local wallpaper_map = {
	{
		"r",
		function()
			awful.spawn("~/dotfiles/PERSONAL_PATH/randbg")
		end,
		"Random Wallpaper",
	},
	{
		"p",
		function()
			awful.spawn("~/dotfiles/PERSONAL_PATH/prevbg")
		end,
		"Previous Wallpaper",
	},
	{
		"n",
		function()
			awful.spawn("~/dotfiles/PERSONAL_PATH/nextbg")
		end,
		"Next Wallpaper",
	},
	{
		"l",
		function()
			awful.spawn("~/dotfiles/PERSONAL_PATH/lastbg")
		end,
		"Last Wallpaper",
	},
}

local media_map = {
	{
		"i",
		function()
			awful.spawn("~/dotfiles/scripts/dwm/media.sh")
		end,
		"Info",
	},
	{ "separator", "Playback" },
	{
		"p",
		function()
			awful.spawn("~/dotfiles/scripts/dwm/media.sh play")
		end,
		"Play",
	},
	{
		"P",
		function()
			awful.spawn("~/dotfiles/scripts/dwm/media.sh pause")
		end,
		"Pause",
	},
	{
		" ",
		function()
			awful.spawn("~/dotfiles/scripts/dwm/media.sh play-pause")
		end,
		"Play-Pause",
	},
	{
		"n",
		function()
			awful.spawn("~/dotfiles/scripts/dwm/media.sh next")
		end,
		"Next",
	},
	{
		"N",
		function()
			awful.spawn("~/dotfiles/scripts/dwm/media.sh previous")
		end,
		"Prev",
	},
}

local spawn_map = {
	{
		"b",
		function()
			awful.spawn("~/dotfiles/PERSONAL_PATH/chrome")
		end,
		"chrome",
	},
	{
		"c",
		function()
			awful.spawn("~/dotfiles/PERSONAL_PATH/click4ever", true)
		end,
		"click4ever",
	},
	{
		"h",
		function()
			awful.spawn("hakuneko-desktop", true)
		end,
		"hakuneko-desktop",
	},
	{
		"p",
		function()
			awful.spawn("pavucontrol", true)
		end,
		"pavucontrol",
	},
	{
		"r",
		function()
			awful.spawn("vokoscreenNG", true)
		end,
		"vokoscreenNG",
	},
	{
		"s",
		function()
			awful.spawn("dex /usr/share/applications/spotify-adblock.desktop", "spotify", true)
		end,
		"spotify",
	},
}

local toggle_map = {
	{ "t", awful.client.floating.toggle, "floating" },
	{
		"f",
		function()
			client.focus.fullscreen = not client.focus.fullscreen
		end,
		"Fullscreen",
	},
	{
		"i",
		function()
			awful.titlebar.toggle(client.focus)
		end,
		"titlebars",
	},
	{
		"b",
		function()
			mouse.screen.mywibox.visible = not mouse.screen.mywibox.visible
		end,
		"bar",
	},
	{
		"l",
		function()
			awful.spawn("betterlockscreen -l", true)
		end,
		"lock screen",
	},
}

local info_map = {
	{
		"b",
		function()
			awful.spawn("~/dotfiles/scripts/xmobar/battery.sh 1")
		end,
		"battery",
	},
	{
		"c",
		function()
			awful.spawn("~/dotfiles/scripts/xmobar/cpu.sh 1")
		end,
		"cpu",
	},
	{
		"m",
		function()
			awful.spawn("~/dotfiles/scripts/xmobar/mem.sh 1")
		end,
		"mem",
	},
	{
		"p",
		function()
			awful.spawn("~/dotfiles/scripts/xmobar/ping.sh 1")
		end,
		"ping",
	},
}

-- general awesome keys
awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { mod.super },
		key = "t",
		description = "term_scratch commands",
		group = "term_scratch",
		on_press = function()
			modalbind.grab({ keymap = term_scratch_map, name = "term_scratch", stay_in_mode = false })
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.ctrl },
		key = "t",
		description = "tabbed commands",
		group = "tabbed",
		on_press = function()
			modalbind.grab({ keymap = tabbed_map, name = "tabbed", stay_in_mode = false })
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "w",
		description = "window_swallowing commands",
		group = "window_swallowing",
		on_press = function()
			modalbind.grab({ keymap = window_swallowing_map, name = "window_swallowing", stay_in_mode = false })
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "/",
		description = "show help",
		group = "awesome",
		on_press = hotkeys_popup.show_help,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "m",
		description = "show main menu",
		group = "awesome",
		on_press = function()
			widgets.mainmenu:show()
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.ctrl },
		key = "a",
		description = "awesome commands",
		group = "awesome",
		on_press = function()
			modalbind.grab({ keymap = awesome_map, name = "AWESOME", stay_in_mode = false })
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "x",
		description = "lua execute prompt",
		group = "awesome",
		on_press = function()
			awful.prompt.run({
				prompt = "Run Lua code: ",
				textbox = awful.screen.focused().promptbox.widget,
				exe_callback = awful.util.eval,
				history_path = awful.util.get_cache_dir() .. "/history_eval",
			})
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "Return",
		description = "open a terminal",
		group = "launcher",
		on_press = function()
			awful.spawn(apps.terminal)
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "s",
		description = "Spawn",
		group = "launcher",
		on_press = function()
			modalbind.grab({ keymap = spawn_map, name = "Spawn", stay_in_mode = true })
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "r",
		description = "run prompt",
		group = "launcher",
		on_press = function()
			awful.screen.focused().promptbox:run()
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "p",
		description = "show the menubar",
		group = "launcher",
		on_press = function()
			menubar.show()
		end,
	}),
})

-- tags related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { mod.super },
		key = "Left",
		description = "view preivous",
		group = "tag",
		on_press = awful.tag.viewprev,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "Right",
		description = "view next",
		group = "tag",
		on_press = awful.tag.viewnext,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "Escape",
		description = "go back",
		group = "tag",
		on_press = awful.tag.history.restore,
	}),
})

-- focus related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { mod.super },
		key = "j",
		description = "focus next by index",
		group = "client",
		on_press = function()
			awful.client.focus.byidx(1)
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "k",
		description = "focus previous by index",
		group = "client",
		on_press = function()
			awful.client.focus.byidx(-1)
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "Tab",
		description = "go back",
		group = "client",
		on_press = function()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.ctrl },
		key = "j",
		description = "focus the next screen",
		group = "screen",
		on_press = function()
			awful.screen.focus_relative(1)
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.ctrl },
		key = "n",
		description = "restore minimized",
		group = "client",
		on_press = function()
			local c = awful.client.restore()
			if c then
				c:active({ raise = true, context = "key.unminimize" })
			end
		end,
	}),
})

-- layout related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { mod.super },
		key = "=",
		description = "Layouts",
		group = "client",
		on_press = function()
			modalbind.grab({ keymap = layout_map, name = "Layout", stay_in_mode = true })
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "j",
		description = "swap with next client by index",
		group = "client",
		on_press = function()
			awful.client.swap.byidx(1)
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "k",
		description = "swap with previous client by index",
		group = "client",
		on_press = function()
			awful.client.swap.byidx(-1)
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "u",
		description = "jump to urgent client",
		group = "client",
		on_press = awful.client.urgent.jumpto,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "l",
		description = "increase master width factor",
		group = "layout",
		on_press = function()
			awful.tag.incmwfact(0.05)
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "h",
		description = "decrease master width factor",
		group = "layout",
		on_press = function()
			awful.tag.incmwfact(-0.05)
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "h",
		description = "increase the number of master clients",
		group = "layout",
		on_press = function()
			awful.tag.incnmaster(1, nil, true)
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "l",
		description = "decrease the number of master clients",
		group = "layout",
		on_press = function()
			awful.tag.incnmaster(-1, nil, true)
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.ctrl },
		key = "h",
		description = "increase the number of columns",
		group = "layout",
		on_press = function()
			awful.tag.incnmaster(1, nil, true)
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.ctrl },
		key = "l",
		description = "decrease the number of columns",
		group = "layout",
		on_press = function()
			awful.tag.incnmaster(-1, nil, true)
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "space",
		description = "select next",
		group = "layout",
		on_press = function()
			awful.layout.inc(1)
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "space",
		description = "select previous",
		group = "layout",
		on_press = function()
			awful.layout.inc(-1)
		end,
	}),
})

awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { mod.super },
		keygroup = "numrow",
		description = "only view tag",
		group = "tag",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				tag:view_only(tag)
			end
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.ctrl },
		keygroup = "numrow",
		description = "toggle tag",
		group = "tag",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				tag:viewtoggle(tag)
			end
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.shift },
		keygroup = "numrow",
		description = "move focused client to tag",
		group = "tag",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.ctrl, mod.shift },
		keygroup = "numrow",
		description = "toggle focused client on tag",
		group = "tag",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		keygroup = "numpad",
		description = "select layout directrly",
		group = "layout",
		on_press = function(index)
			local tag = awful.screen.focused().selected_tag
			if tag then
				tag.layout = tag.layouts[index] or tag.layout
			end
		end,
	}),
})
