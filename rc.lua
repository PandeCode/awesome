-- awesome_mode: api-level=4:screen=on
local __RED = "\033[91m"
local __ENDC = "\033[0m"

local gears = require("gears")
gears.debug.print_error(__RED .. "BEGIN ERR LOG" .. __ENDC .. "\n")

-- load luarocks if installed
pcall(require, "luarocks.loader")

-- load theme
local beautiful = require("beautiful")

beautiful.init(gears.filesystem.get_configuration_dir().. "default/theme.lua")
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

local machi = require("modules.layout-machi")
beautiful.layout_machi = machi.get_icon()

local bling = require("modules.bling")
bling.module.flash_focus.enable()

-- load key and mouse bindings
require("bindings")

-- load rules
require("rules")

-- load signals
require("signals")

gears.debug.print_error(__RED .. "BEGIN ERR LOG" .. __ENDC .. "\n")
