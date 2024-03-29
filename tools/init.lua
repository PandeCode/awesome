local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local generics = require("widgets.generics")

local _M = {}

---Execute a command
---@param prog string
---@return string
function _M.exec(prog)
	f = io.popen(prog)
	local ret = f:read("*all")
	f:close()
	return ret
end

---Return a function that will execute a command when called
---@param prog string
---@return function
function _M.func_exec(prog)
	return function()
		return _M.exec(prog)
	end
end

---Expand paths like '~' and environment vairables like '$HOME'
---@param path string
---@return string
function _M.expand_path(path)
	return _M.exec("echo " .. path)
end

---Create a file
---@param filepath string
function _M.create_file(filepath)
	filepath = _M.expand_path(filepath)
	local dir = _M.exec("dirname " .. filepath)
	_M.exec("mkdir -p " .. dir)
	_M.exec("touch " .. filepath)
end

---Write To File
---@param filepath string
---@param str any
function _M.write_to_file(filepath, str)
	filepath = _M.expand_path(filepath)
	if not _M.file_exists(filepath) then
		_M.create_file(filepath)
	end

	local file, err = io.open(filepath, "w")
	if file then
		file:write(_M.any_to_string(str))
		file:close()
	else
		local msg = "Error opening file: " .. err
		gears.debug.print_error(msg)
		_M.notify(msg)
	end
end

---Truncate String
---@param text string
---@param length integer
---@return string
function _M.truncate(text, length)
	return (text:len() > length and length > 0) and text:sub(0, length - 3) .. "..." or text
end

-- Converts seconds to “time ago” represenation, like ‘1 hour ago’
---@param seconds integer
---@return string
function _M.to_time_ago(seconds)
	local days = seconds / 86400
	if days > 1 then
		days = math.floor(days + 0.5)
		return days .. (days == 1 and " day" or " days") .. " ago"
	end

	local hours = (seconds % 86400) / 3600
	if hours > 1 then
		hours = math.floor(hours + 0.5)
		return hours .. (hours == 1 and " hour" or " hours") .. " ago"
	end

	local minutes = ((seconds % 86400) % 3600) / 60
	if minutes > 1 then
		minutes = math.floor(minutes + 0.5)
		return minutes .. (minutes == 1 and " minute" or " minutes") .. " ago"
	end
	return tonumber(seconds) .. " seconds ago"
end

---A helper function to print a table's contents.
---@param tbl any @The table to print.
---@param depth? integer @The depth of sub-tables to traverse through and print.
---@param n? integer @Do NOT manually set this. This controls formatting through recursion.
function _M.any_to_string(tbl, depth, n)
	if type(tbl) ~= "table" then
		return tostring(tbl)
	end

	final = ""
	n = n or 0
	depth = depth or 5

	if depth == 0 then
		final = final .. string.rep(" ", n) .. "..." .. "\n"
	end

	if n == 0 then
		final = final .. " " .. "\n"
	end

	for key, value in pairs(tbl) do
		if key and type(key) == "number" or type(key) == "string" then
			key = string.format('["%s"]', key)

			if type(value) == "table" then
				if next(value) then
					final = final .. string.rep(" ", n) .. key .. " = {" .. "\n"
					final = final .. _M.any_to_string(value, depth - 1, n + 4) .. "\n"
					final = final .. string.rep(" ", n) .. "}," .. "\n"
				else
					final = final .. string.rep(" ", n) .. key .. " = {}," .. "\n"
				end
			else
				if type(value) == "string" then
					value = string.format('"%s"', value)
				else
					value = tostring(value)
				end

				final = final .. string.rep(" ", n) .. key .. " = " .. value .. "," .. "\n"
			end
		end
	end

	if n == 0 then
		final = final .. " " .. "\n"
	end

	return final
end

---Awesome Notification
---@param str any
function _M.notify(str)
	naughty.notify({
		text = _M.any_to_string(str),
		shape = generics._default_shape,
		timeout = 0,
	})
end

---A helper function to spawn with logging
---@param command string @Command to execute
---@param single_instance? boolean @Launch Single Instance
---@param ps_name? string @Launch Assumed process name
---@param log? boolean @Should log false
function _M.spawn(command, single_instance, ps_name, log)
	ps_name = ps_name
		or (function()
			found = command:find(" ")
			return found and command:sub(1, found - 1) or command
		end)()

	local true_cmd = "sh -c '"
		.. command
		.. (log and (" 2> ~/log/" .. ps_name .. ".err.log > ~/log/" .. ps_name .. ".log") or " 2>&1 > /dev/null")
		.. "'"

	if single_instance then
		if not _M.is_process_running(ps_name) then
			awful.spawn(true_cmd)
		else
			-- gears.debug.print_warning("Process '" .. ps_name .. "'  is already running")
		end
	else
		awful.spawn(true_cmd)
	end
end

---A helper function to spawn with logging
---@param command string @Command to execute
---@param single_instance? boolean @Launch Single Instance
---@param ps_name? string @Launch Assumed process name
---@param log? boolean @Should log false
---@return function function when executed runs tools.spawn
function _M.spawn_func(command, single_instance, ps_name, log)
	return function()
		_M.spawn(command, single_instance, ps_name, log)
	end
end

-- see if the file exists
function _M.file_exists(file)
	local f = io.open(file, "rb")
	if f then
		f:close()
	end
	return f ~= nil
end

-- get all lines from a file, returns an empty
-- list/table if the file does not exist
---@param file string
---@return string[]
function _M.lines_from(file)
	if not _M.file_exists(file) then
		return {}
	end
	lines = {}
	for line in io.lines(file) do
		lines[#lines + 1] = line
	end
	return lines
end

function _M.is_process_running(ps)
	return _M.exec("pidof " .. ps) ~= ""
end

-- Average CPU
function _M.get_cpu()
	return tonumber(_M.exec([[ $DOTFILES/scripts/sysstat/cpu.sh | grep -Po '\[fg=.*]\K.*(?=%#\[)' ]])) or 404
end

function _M.read_file(filename)
	local file = io.open(filename, "r")
	if file then
		local text = file:read("*all")
		file:close()
		return text
	else
		gears.debug.print_error("File '" .. filename .. "' not found.")
		return ""
	end
end

function _M.get_ram()
	return tonumber(_M.exec([[$DOTFILES/scripts/sysstat/mem.sh | grep -Po '\[fg=.*]\K.*(?=%#\[)']])) or 404
	-- local lines = _M.lines_from("/proc/meminfo")
	--
	-- local total = tonumber(lines[1]:match("[%d]+"))
	-- local free = tonumber(lines[2]:match("[%d]+"))
	--
	-- local percent = math.floor(((total - free) / total) * 100)
	-- return percent
end

function _M.get_swap()
	return tonumber(_M.exec([[$DOTFILES/scripts/sysstat/swap.sh | grep -Po '\[fg=.*]\K.*(?=%#\[)']])) or 404
	-- local lines = _M.lines_from("/proc/meminfo")
    --
	-- local total = tonumber(lines[15]:match("[%d]+"))
	-- local free = tonumber(lines[16]:match("[%d]+"))
    --
	-- local percent = math.floor(((total - free) / total) * 100)
	-- return percent
end

---Check if plugged in
---@param sys_file? string
---@return boolean
function _M.is_plugged(sys_file)
	if sys_file == nil then
		if _M.file_exists("/sys/class/power_supply/ACAD/online") then
			sys_file = "/sys/class/power_supply/ACAD/online"
		elseif _M.file_exists("/sys/class/power_supply/AC/online") then
			sys_file = "/sys/class/power_supply/AC/online"
		else
			gears.debug.print_error("No power supply found")
			return false
		end
	end

	return _M.read_file(sys_file) == "1"
end

---get battery percentage
---@param sys_file? string /sys/class/power_supply/BAT{?}/capacity
---@return integer
function _M.get_battery(sys_file)
	if sys_file == nil then
		if _M.file_exists("/sys/class/power_supply/BAT0/capacity") then
			sys_file = "/sys/class/power_supply/BAT0/capacity"
		elseif _M.file_exists("/sys/class/power_supply/BAT1/capacity") then
			sys_file = "/sys/class/power_supply/BAT1/capacity"
		else
			gears.debug.print_error("No battery found")
			return 0
		end
	end
	return tonumber(_M.read_file(sys_file)) or 0
end

function _M.get_volume()
	return tonumber(_M.exec([[pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\\/\\s\\K\\d+(?=%\\s\\/)' | head -n r]]))
end

function _M.get_ping()
	return tonumber(_M.exec("SB=3 $DOTFILES/scripts/ping"))
end

function _M.get_storage(drive)
	drive = drive or "/dev/sda3"
	return tonumber(_M.exec("df " .. drive .. [[ | awk 'FNR==2 { printf ($3*100)/($3+$4) }']]))
end

---Warning This runs on the main thread
---@param n integer
function _M.sleep(n) -- seconds
	local t0 = os.clock()
	while os.clock() - t0 <= n do
	end
end

---Call a function after a delay async
---@param callback function
---@param seconds number
function _M.delayed_run(callback, seconds)
	gears.timer({
		timeout = seconds,
		autostart = true,
		single_shot = true,
		callback = callback,
	})
end

function _M.starts_with(str, start)
	return str:sub(1, #start) == start
end

function _M.ends_with(str, ending)
	return ending == "" or str:sub(-#ending) == ending
end

---Add padding to string
---@param str string
---@param desired_len integer
---@return string
function _M.add_padding_if_not_len(str, desired_len)
	if #str < desired_len then
		return string.rep(" ", desired_len - #str) .. str
	else
		return str
	end
end

_M.okay_color = beautiful.okay_color or "green"
_M.warning_color = beautiful.warning_color or "yellow"
_M.error_color = beautiful.error_color or "red"

function _M.get_formatted_ping()
	local val = _M.get_ping()
	local color = _M.okay_color
	if val == nil or val > 300 then
		color = _M.error_color
	elseif val > 100 then
		color = _M.error_color
	end

	local padded_val = _M.add_padding_if_not_len(tostring(val or "N/A"), 3)
	return "<span foreground='" .. color .. "'>" .. padded_val .. "ms</span>"
end
function _M.get_formatted_cpu()
	local val = _M.get_cpu()
	local color = _M.okay_color
	if val > 80 then
		color = _M.error_color
	elseif val > 50 then
		color = _M.warning_color
	end

	local padded_val = _M.add_padding_if_not_len(tostring(val), 3)
	return "<span foreground='" .. color .. "'>" .. padded_val .. "</span>"
end
function _M.get_formatted_ram()
	local val = _M.get_ram()
	local color = _M.okay_color
	if val > 80 then
		color = _M.error_color
	elseif val > 50 then
		color = _M.warning_color
	end

	local padded_val = _M.add_padding_if_not_len(tostring(val), 3)
	return "<span foreground='" .. color .. "'>" .. padded_val .. "</span>"
end
function _M.get_formatted_swap()
	local val = _M.get_swap()
	local color = _M.okay_color
	if val > 80 then
		color = _M.error_color
	elseif val > 50 then
		color = _M.warning_color
	end

	local padded_val = _M.add_padding_if_not_len(tostring(val), 3)
	return "<span foreground='" .. color .. "'>" .. padded_val .. "</span>"
end

function _M.get_formatted_battery()
	local val = _M.get_battery()
	local color = _M.okay_color
	if val < 30 then
		color = _M.error_color
	elseif val < 75 then
		color = _M.warning_color
	end

	local padded_val = _M.add_padding_if_not_len(tostring(val), 3)
	return "<span foreground='" .. color .. "'>" .. padded_val .. "</span>"
end

function _M.table_has_value(tab, val)
	for _, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	return false
end

return _M
