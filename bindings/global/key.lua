-- stylua: ignore start
local awful = require("awful")
local menubar = require("menubar")

local apps = require("config.apps")
local mod = require("bindings.mod")
local widgets = require("widgets")

local bling = require("modules.bling")
local beautiful = require("beautiful")

local machi = require("modules.layout-machi")
local layouts = require("config.vars").layouts

local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

menubar.utils.terminal = apps.terminal

local modalbind = require("modules.awesome-modalbind")
modalbind.init()
if beautiful.modalbind_show_default_options then
	modalbind.show_default_options()
else
	modalbind.hide_default_options()
end

if beautiful.modalbind_show_options then
	modalbind.show_options()
else
	modalbind.hide_options()
end

modalbind.set_location(beautiful.modalbind_location)
modalbind.set_opacity(beautiful.modalbind_opacity)
modalbind.set_x_offset(beautiful.modalbind_x_offset)
modalbind.set_y_offset(beautiful.modalbind_y_offset)

local awesome_map = {
	{ "r", awesome.restart, "Restart" },
	{ "q", awesome.quit, "Quit" },
}

local machi_map = {
	{ "e", machi.default_editor.start_interactive, "edit the current layout if it is a machi layout" },
	{ "s", function() machi.switcher.start(client.focus) end, "switch between windows for a machi layout", },
}

local layout_map = {
	{ "machi", function() modalbind.grab({ keymap = machi_map, name = "Machi", stay_in_mode = false }) end, },
}

for _, value in pairs(layouts) do
	table.insert(layout_map, { value.name, function() awful.layout.set(value) end, })
end

local term_scratch = require("config.term_scratch").term_scratch
local term_scratch_map = {
	{ "t", function() term_scratch:toggle() end, "toggles visibility", },
	{ "o", function() term_scratch:turn_on() end, "visibility on", },
	{ "s", function() term_scratch:turn_off() end, "visibility off", },
}

local tabbed_map = {
	{ "p", bling.module.tabbed.pick,            "picks a client with your cursor to add to the tabbing group" },
	{ "r", bling.module.tabbed.pop,             "removes the focused client from the tabbing group" },
	{ "i", bling.module.tabbed.iter,            "iterates through the currently focused tabbing group" },
	{ "d", bling.module.tabbed.pick_with_dmenu, "picks a client with a dmenu application (defaults to rofi, other options can be set with a string parameter like 'dmenu')", },
	{ "k", function() bling.module.tabbed.pick_by_direction("up") end, "picks a client based on direction", },
	{ "j", function() bling.module.tabbed.pick_by_direction("down") end, "picks a client based on direction", },
	{ "h", function() bling.module.tabbed.pick_by_direction("left") end, "picks a client based on direction", },
	{ "l", function() bling.module.tabbed.pick_by_direction("right") end, "picks a client based on direction", },
}

local window_swallowing_map = {
	{ "s", bling.module.window_swallowing.start, "activates window swallowing" },
	{ "e", bling.module.window_swallowing.stop, "deactivates window swallowing", },
	{ "t", bling.module.window_swallowing.toggle, "toggles window swallowing", },
}

local wallpaper_map = {
	{ "r", function() awful.spawn("~/dotfiles/PERSONAL_PATH/randbg") end, "Random Wallpaper", },
	{ "p", function() awful.spawn("~/dotfiles/PERSONAL_PATH/prevbg") end, "Previous Wallpaper", },
	{ "n", function() awful.spawn("~/dotfiles/PERSONAL_PATH/nextbg") end, "Next Wallpaper", },
	{ "l", function() awful.spawn("~/dotfiles/PERSONAL_PATH/lastbg") end, "Last Wallpaper", },
}

local media_map = {
	{ "i", function() awful.spawn("~/dotfiles/scripts/dwm/media.sh") end, "Info", },
	{ "separator", "Playback" }, { "p", function() awful.spawn("~/dotfiles/scripts/dwm/media.sh play") end, "Play", },
	{ "P", function() awful.spawn("~/dotfiles/scripts/dwm/media.sh pause") end, "Pause", },
	{ " ", function() awful.spawn("~/dotfiles/scripts/dwm/media.sh play-pause") end, "Play-Pause", },
	{ "n", function() awful.spawn("~/dotfiles/scripts/dwm/media.sh next") end, "Next", },
	{ "N", function() awful.spawn("~/dotfiles/scripts/dwm/media.sh previous") end, "Prev", },
}

local spawn_map = {
	{ "b", function() awful.spawn("~/dotfiles/PERSONAL_PATH/chrome") end, "chrome", },
	{ "c", function() awful.spawn("~/dotfiles/PERSONAL_PATH/click4ever", true) end, "click4ever", },
	{ "h", function() awful.spawn("hakuneko-desktop", true) end, "hakuneko-desktop", },
	{ "p", function() awful.spawn("pavucontrol", true) end, "pavucontrol", },
	{ "r", function() awful.spawn("vokoscreenNG", true) end, "vokoscreenNG", },
	{ "s", function() awful.spawn("dex /usr/share/applications/spotify-adblock.desktop", "spotify", true) end, "spotify", },
}

local info_map = {
	{ "b", function() awful.spawn("~/dotfiles/scripts/xmobar/battery.sh 1") end, "battery", },
	{ "c", function() awful.spawn("~/dotfiles/scripts/xmobar/cpu.sh 1")     end, "cpu", },
	{ "m", function() awful.spawn("~/dotfiles/scripts/xmobar/mem.sh 1")     end, "mem", },
	{ "p", function() awful.spawn("~/dotfiles/scripts/xmobar/ping.sh 1")    end, "ping", },
}

local client_focus_next                 = function() awful.client.focus.byidx(1) end
local client_focus_previous             = function() awful.client.focus.byidx(-1) end
local client_focus_back                 = function() awful.client.focus.history.previous() if client.focus then client.focus:raise() end end
local screen_focus_next                 = function() awful.screen.focus_relative(1) end
local restore_minimized                 = function() local c = awful.client.restore() if c then c:active({ raise = true, context = "key.unminimize" }) end end


local run_prompt                        = function() awful.screen.focused().promptbox:run() end
local launcher                          = function() menubar.show() end
local lua_exec_prompt                   = function() awful.prompt.run({ prompt = "Run Lua code: ", textbox = awful.screen.focused().promptbox.widget, exe_callback = awful.util.eval, history_path = awful.util.get_cache_dir() .. "/history_eval", }) end

local show_main_menu                    = function() widgets.mainmenu:show() end

local modalbind_awesome                 = function() modalbind.grab({ keymap = awesome_map,           name = "AWESOME",           stay_in_mode = false }) end
local modalbind_layout                  = function() modalbind.grab({ keymap = layout_map,            name = "Layout",            stay_in_mode = true }) end
local modalbind_spawn                   = function() modalbind.grab({ keymap = spawn_map,             name = "Spawn",             stay_in_mode = true }) end
local modalbind_tabbed                  = function() modalbind.grab({ keymap = tabbed_map,            name = "tabbed",            stay_in_mode = false }) end
local modalbind_term_scratch            = function() modalbind.grab({ keymap = term_scratch_map,      name = "term_scratch",      stay_in_mode = false }) end
local modalbind_window_swallowing       = function() modalbind.grab({ keymap = window_swallowing_map, name = "window_swallowing", stay_in_mode = false }) end

local spawn_terminal                    = function() awful.spawn(apps.terminal) end

local only_view_tag                     = function(index) local screen = awful.screen.focused() local tag = screen.tags[index] if tag then tag:view_only(tag) end end
local toggle_tag                        = function(index) local screen = awful.screen.focused() local tag = screen.tags[index] if tag then tag:viewtoggle(tag) end end
local move_focused_client_to_tag        = function(index) if client.focus then local tag = client.focus.screen.tags[index] if tag then client.focus:move_to_tag(tag) end end end
local toggle_focused_client_to_tag      = function(index) if client.focus then local tag = client.focus.screen.tags[index] if tag then client.focus:toggle_tag(tag) end end end
local select_layout_directly            = function(index) local tag = awful.screen.focused().selected_tag if tag then tag.layout = tag.layouts[index] or tag.layout end end

local layout_select_next                = function() awful.layout.inc(1) end
local layout_select_previous            = function() awful.layout.inc(-1) end

local increase_number_of_columns        = function() awful.tag.incnmaster(1, nil, true) end
local decrease_the_number_of_columns    = function() awful.tag.incnmaster(-1, nil, true) end

local swap_client_with_next             = function() awful.client.swap.byidx(1) end
local swap_client_with_previous         = function() awful.client.swap.byidx(-1) end

local increase_number_of_master_clients = function() awful.tag.incnmaster(1, nil, true) end
local decrease_number_of_master_clients = function() awful.tag.incnmaster(-1, nil, true) end

local incresae_master_width_factor      = function() awful.tag.incmwfact(0.05) end
local decrease_master_width_factor      = function() awful.tag.incmwfact(-0.05) end

local toggle_fullscreen = function() client.focus.fullscreen = not client.focus.fullscreen end
local toggle_titlebars = function() awful.titlebar.toggle(client.focus) end
local toggle_bar =function() mouse.screen.mywibox.visible = not mouse.screen.mywibox.visible end
local toggle_lock_screen =function() awful.spawn("betterlockscreen -l", true) end

local modalbind_toggle = function()
	modalbind.grab({
		name = "Toggle",
		stay_in_mode = true,
		keymap = {
			{ "l", awful.client.floating.toggle, "floating" },
			{ "f", toggle_fullscreen, "Fullscreen" },
			{ "i", toggle_titlebars, "titlebars" },
			{ "b", toggle_bar, "bar" },
			{ "l", toggle_lock_screen, "lock screen" },
			{ "t", modalbind_term_scratch, "Term scratch" },
		},
	})
end

-- @type awful.key[]
local keybindings = {
	-- general awesome keys
	awful.key({ mod.super, mod.shift  }, "/",      hotkeys_popup.show_help,          nil, { description = "show help",                             group =  "awesome"}),

	awful.key({ mod.super             }, "m",      show_main_menu,                   nil, { description = "show main menu",                        group =  "awesome"}),
	awful.key({ mod.super             }, "a",      modalbind_awesome,                nil, { description = "awesome commands",                      group =  "awesome"}),

	awful.key({ mod.super             }, "p",      launcher,                         nil, { description = "show the menubar",                      group =  "awesome"}),

	awful.key({ mod.super             }, "x",      lua_exec_prompt,                  nil, { description = "lua execute prompt",                    group =  "awesome"}),
	awful.key({ mod.super             }, "r",      run_prompt,                       nil, { description = "run prompt",                            group =  "awesome"}),

	awful.key({ mod.super             }, "s",      modalbind_spawn,                  nil, { description = "Spawn",                                 group =  "launcher"}),
	awful.key({ mod.super             }, "t",      modalbind_toggle,           nil, { description = "term_scratch commands",                 group =  "term_scratch"}),

	awful.key({ mod.super             }, "w",      modalbind_window_swallowing,      nil, { description = "window_swallowing commands",            group =  "window_swallowing"}),

	awful.key({ mod.super             }, "Return", spawn_terminal,                   nil, { description = "open a terminal",                       group =  "launcher"}),

	-- tags related keybindings
	awful.key({ mod.super             }, "Left",   awful.tag.viewprev,               nil, { description = "view preivous",                         group =  "tag"}),
	awful.key({ mod.super             }, "Right",  awful.tag.viewnext,               nil, { description = "view next",                             group =  "tag"}),
	awful.key({ mod.super             }, "Escape", awful.tag.history.restore,        nil, { description = "go back",                               group =  "tag"}),

	-- focus related keybindings
	awful.key({ mod.super             }, "j",      client_focus_next,                nil, { description = "focus next by index",                   group =  "client"}),
	awful.key({ mod.super             }, "k",      client_focus_previous,            nil, { description = "focus previous by index",               group =  "client"}),
	awful.key({ mod.super             }, "Tab",    client_focus_back,                nil, { description = "go back",                               group =  "client"}),
	awful.key({ mod.super, mod.ctrl   }, "j",      screen_focus_next,                nil, { description = "focus the next screen",                 group =  "screen"}),
	awful.key({ mod.super, mod.ctrl   }, "n",      restore_minimized,                nil, { description = "restore minimized",                     group =  "client"}),

	-- layout related keybindings
	awful.key({ mod.super             }, "=",      modalbind_layout,                 nil, { description = "Layouts",                               group =  "client"}),
	awful.key({ mod.super, mod.ctrl   }, "t",      modalbind_tabbed,                 nil, { description = "tabbed commands",                       group =  "tabbed"}),

	awful.key({ mod.super, mod.shift  }, "j",     swap_client_with_next,             nil, { description = "swap with next client by index",        group =  "client"}),
	awful.key({ mod.super, mod.shift  }, "k",     swap_client_with_previous,         nil, { description = "swap with previous client by index",    group =  "client"}),
	awful.key({ mod.super             }, "u",     awful.client.urgent.jumpto,        nil, { description = "jump to urgent client",                group =  "client" }),

	awful.key({ mod.super             }, "l",     incresae_master_width_factor,      nil, { description = "increase master width factor",          group =  "layout"}),
	awful.key({ mod.super             }, "h",     decrease_master_width_factor,      nil, { description = "decrease master width factor",          group =  "layout"}),

	awful.key({ mod.super, mod.shift  }, "h",     increase_number_of_master_clients, nil, { description = "increase the number of master clients", group =  "layout"}),
	awful.key({ mod.super, mod.shift  }, "l",     decrease_number_of_master_clients, nil, { description = "decrease the number of master clients", group =  "layout"}),

	awful.key({ mod.super, mod.ctrl   }, "h",     increase_number_of_columns,        nil, { description = "increase the number of columns",        group =  "layout"}),
	awful.key({ mod.super, mod.ctrl   }, "l",     decrease_the_number_of_columns,    nil, { description = "decrease the number of columns",        group =  "layout"}),

	awful.key( { mod.super            }, "space", layout_select_next,                nil, { description = "select next",                          group =  "layout"}),
	awful.key( { mod.super, mod.shift }, "space", layout_select_previous,            nil, { description = "select previous",                      group =  "layout"}),

	awful.key({ modifiers = { mod.super                      }, keygroup = "numrow", description = "only view tag", group = "tag", on_press = only_view_tag, }),
	awful.key({ modifiers = { mod.super, mod.ctrl            }, keygroup = "numrow", description = "toggle tag", group = "tag", on_press =toggle_tag, }),
	awful.key({ modifiers = { mod.super, mod.shift           }, keygroup = "numrow", description = "move focused client to tag", group = "tag", on_press = move_focused_client_to_tag, }),
	awful.key({ modifiers = { mod.super, mod.ctrl, mod.shift }, keygroup = "numrow", description = "toggle focused client on tag", group = "tag", on_press = toggle_focused_client_to_tag, }),
	awful.key({ modifiers = { mod.super                      }, keygroup = "numpad", description = "select layout directrly", group = "layout", on_press = select_layout_directly, }),

}

awful.keyboard.append_global_keybindings(keybindings)

return {
	appended_keybindings = keybindings
}
