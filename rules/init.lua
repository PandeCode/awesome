local awful = require("awful")
local ruled = require("ruled")
local vars = require("config.vars")

ruled.client.connect_signal("request::rules", function()
	-- All clients will match this rule.
	ruled.client.append_rule({
		id = "global",
		rule = { },
		properties = {
			titlebars_enabled = false,
			focus = awful.client.focus.filter,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
			raise = true,
			screen = awful.screen.preferred,
		},
	})

	-- Floating clients.
	ruled.client.append_rule({
		id = "floating",
		rule_any = {
			instance = { "copyq", "pinentry" },
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"Sxiv",
				"Tor Browser",
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
				"Vimb",
				"Xmessage",
				"Gimp",
				"Open File",
				"leagueclientux.exe",
				"riotclientux.exe",
				"riotclientservices.exe",
				"League of Legends",
			},
			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	})

	-- Add titlebars to normal clients and dialogs
	ruled.client.append_rule({
		id = "titlebars",
		rule_any = { type = { "dialog" } },
		properties = { titlebars_enabled = true },
	})

	for key, classes in pairs(vars.tag_rules) do
		for _, class in pairs(classes) do
			ruled.client.append_rule({ rule = { class = class }, properties = { screen = 1, tag = vars.tags[key] } })
		end
	end
	

	-- Normally we'd do this with a rule, but some programs like spotify doesn't set its class or name
	-- until after it starts up, so we need to catch that signal.
	client.connect_signal("property::class", function(c)
		if c.class == "Spotify" then
			-- Check if Spotify is already open
			local app = function(c)
				return ruled.client.match(c, { class = "Spotify" })
			end

			local app_count = 0
			for c in awful.client.iterate(app) do
				app_count = app_count + 1
			end

			-- If Spotify is already open, don't open a new instance
			if app_count > 1 then
				c:kill()
				-- Switch to previous instance
				for c in awful.client.iterate(app) do
					c:jump_to(false)
				end
			else
				local t = awful.tag.find_by_name(awful.screen.focused(), vars.tags[5])
				c:move_to_tag(t)
				c.fullscreen = true
			end
			elseif tool then
		end
	end)

	-- Set Firefox to always map on the tag named '2' on screen 1.
	-- ruled.client.append_rule {
	--    rule       = {class = 'Firefox'},
	--    properties = {screen = 1, tag = '2'}
	-- }
end)
