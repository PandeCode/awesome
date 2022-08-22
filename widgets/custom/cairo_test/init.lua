local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local tools = require("tools")
local cairo = require("lgi").cairo

M_PI = 3.14159

local function draw(cr, width, height)
	pat = cairo.Pattern.create_linear (0.0, 0.0,  0.0, 256.0);
	pat:add_color_stop_rgba( 1, 0, 0, 0, 1);
	pat:add_color_stop_rgba( 0, 1, 1, 1, 1);
	cr:rectangle( 0, 0, 256, 256);
	cr:set_source( pat);
	cr:fill();
	-- pat:destroy();

	pat = cairo.Pattern.create_radial (115.2, 102.4, 25.6,
                                   	   102.4,  102.4, 128.0);
	pat:add_color_stop_rgba( 0, 1, 1, 1, 1);
	pat:add_color_stop_rgba( 1, 0, 0, 0, 1);
	cr:set_source( pat);
	cr:arc( 128.0, 128.0, 76.8, 0, 2 * M_PI);
	cr:fill();
	-- pat:destroy();
end

local function generate_cairo_test(args)
	args = args or {}

	local _width = args.width or 500
	local _height = args.height or 500

	local _M = {}

	local img = cairo.ImageSurface.create(cairo.Format.ARGB32, _width, _height)
	local cr = cairo.Context(img)

	draw(cr, _width, _height)

	_M.cairo_test = wibox({
		visible = true,
		on_top = true,

		height = _height,
		width = _width,

		shape = gears.shape.rectangle,
		shape_border_width = 1,
		shape_border_color = "white",

		widget = {
			widget = wibox.container.background,
			bgimage = img,
		},
	})

	function _M.set_width(width)
		if width == 0 then
			_M.cairo_test.width = 1
		else
			_M.cairo_test.width = width
		end
	end
	function _M.set_height(height)
		if height == 0 then
			_M.cairo_test.height = 1
		else
			_M.cairo_test.height = height
		end
	end
	function _M.show_cairo_test()
		if _M.cairo_test.visible then
			return
		end
		_M.cairo_test.visible = true
	end

	function _M.hide_cairo_test()
		if not _M.cairo_test.visible then
			return
		end
		_M.cairo_test.visible = false
	end

	function _M.toggle_cairo_test()
		if _M.cairo_test.visible then
			_M.hide_cairo_test()
		else
			_M.show_cairo_test()
		end
	end

	awful.placement.align(_M.cairo_test, {
		position = "centered",
	})

	return _M
end

return generate_cairo_test
