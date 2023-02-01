local tools = require("tools")

local _M                 = {
	browser              = os.getenv("browser") or "google-chrome-stable",
	browser_ps_name      = "chrome",
	click4ever           = tools.expand_path("$PERSONAL_PATH/click4ever"),
	editor               = os.getenv("EDITOR") or "nvim",
	hakuneko             = "hakuneko-desktop",
	kdeconnect_indicator = "kdeconnect-indicator",
	nm_applet            = "nm-applet",
	pavucontrol          = "pavucontrol",
	picom                = "picom -b --experimental-backend",
	spotify              = "dex /usr/share/applications/spotify-adblock.desktop",
	terminal             = "alacritty",
	-- terminal             = os.getenv("TERMINAL") or "alacritty",
	vokoscreenNG         = "vokoscreenNG",
}

_M.editor_cmd = _M.terminal .. " -e " .. _M.editor
_M.manual_cmd = _M.terminal .. " -e man awesome"

return _M
