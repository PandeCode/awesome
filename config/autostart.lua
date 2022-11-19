local tools = require("tools")
local apps = require("config.apps")
local awful = require("awful")

tools.spawn(apps.browser,  true, apps.browser_ps_name)
tools.spawn(apps.kdeconnect_indicator,  true)
tools.spawn(apps.nm_applet,  true)
tools.spawn(apps.picom,  true, "picom")
-- tools.spawn(apps.spotify,  true, "spotify")
tools.spawn("alacritty", true)

awful.tag.viewidx(1) -- Second tag
