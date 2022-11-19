-- awesome_mode: api-level=4:screen=on
local __RED = "\033[91m"
local __ENDC = "\033[0m"

GLOBAL_UI = {}
local gears = require("gears")
gears.debug.print_error(
	__RED
		.. "--------------------------------BEGIN ERR LOG--------------------------------------------"
		.. __ENDC
		.. "\n"
)

-- load luarocks if installed
pcall(require, "luarocks.loader")

-- load theme
local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/default/theme.lua")

-- load signals
require("signals")

-- load rules
require("rules")

local machi = require("modules.layout-machi")
beautiful.layout_machi = machi.get_icon()

local bling = require("modules.bling")
bling.module.flash_focus.enable()

-- load key and mouse bindings
require("bindings")

GLOBAL_UI.action_center = require("widgets.custom.action_center")({user_icon = beautiful.user_icon, opacity = .9})
GLOBAL_UI.action_center.show()

-- local _cairo_test = require("widgets.custom.cairo_test")()
-- _cairo_test.show()

-- autostart
require("config.autostart")


gears.debug.print_error(
	__RED .. "--------------------------------END ERR LOG--------------------------------------------" .. __ENDC .. "\n"
)
