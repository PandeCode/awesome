-- awesome_mode: api-level=4:screen=on

-- load luarocks if installed
pcall(require, "luarocks.loader")

-- load theme
local beautiful = require("beautiful")
local gears = require("gears")
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

local machi = require("modules.layout-machi")
beautiful.layout_machi = machi.get_icon()

-- load key and mouse bindings
require("bindings")

-- load rules
require("rules")

-- load signals
require("signals")
