local _M = {}

local awful = require("awful")

local machi = require("modules.layout-machi")

_M.layouts = {
	machi.default_layout,

	awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.spiral,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max,
	awful.layout.suit.max.fullscreen,
	awful.layout.suit.magnifier,
	awful.layout.suit.corner.nw,
}

-- _M.tags = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
_M.tags = { "¹ ", "² ", "³ ", "⁴ ", "⁵ ", "⁶ ", "⁷ ", "⁸", "⁹ " }

return _M
