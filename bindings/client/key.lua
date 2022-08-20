-- stylua: ignore start
local awful = require("awful")

local mod = require("bindings.mod")

local close_client                 = function(c) c:kill()                                                      end

local move_to_master               = function(c) c:swap(awful.client.getmaster())                              end

local move_to_screen               = function(c) c:move_to_screen()                                            end

local toggle_fullscreen            = function(c) c.fullscreen           = not c.fullscreen c:raise()           end
local toggle_keep_on_top           = function(c) c.ontop                = not c.ontop                          end

local toggle_maximize_horizontally = function(c) c.maximized_horizontal = not c.maximized_horizontal c:raise() end
local toggle_maximize_veritcally   = function(c) c.maximized_vertical   = not c.maximized_vertical c:raise()   end
local toggle_unmaximize            = function(c) c.maximized            = not c.maximized c:raise()            end
local minimize                     = function(c) c.minimized            = true                                 end

client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings({
		awful.key({ mod.super            }, "f",      toggle_fullscreen,            nil, { description = "toggle fullscreen",         group = "client" }),
		awful.key({ mod.alt              }, "F4",     close_client,                 nil, { description = "close",                     group = "client" }),
		awful.key({ mod.super, mod.ctrl  }, "space",  awful.client.floating.toggle, nil, { description = "toggle floating",           group = "client" }),
		awful.key({ mod.super, mod.ctrl  }, "Return", move_to_master,               nil, { description = "move to master",            group = "client" }),
		awful.key({ mod.super            }, "o",      move_to_screen,               nil, { description = "move to screen",            group = "client" }),
		awful.key({ mod.super            }, "t",      toggle_keep_on_top,           nil, { description = "toggle keep on top",        group = "client" }),
		awful.key({ mod.super            }, "n",      minimize,                     nil, { description = "minimize",                  group = "client" }),
		awful.key({ mod.super            }, "m",      toggle_unmaximize,            nil, { description = "(un)maximize",              group = "client" }),
		awful.key({ mod.super, mod.ctrl  }, "m",      toggle_maximize_veritcally,   nil, { description = "(un)maximize vertically",   group = "client" }),
		awful.key({ mod.super, mod.shift }, "m",      toggle_maximize_horizontally, nil, { description = "(un)maximize horizontally", group = "client" }),
	})
end)

