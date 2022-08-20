local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")

local function truncate(text, length)
	return (text:len() > length and length > 0) and text:sub(0, length - 3) .. "..." or text
end

-- Converts seconds to “time ago” represenation, like ‘1 hour ago’
local function to_time_ago(seconds)
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
end

---A helper function to print a table's contents.
---@param tbl table @The table to print.
---@param depth number @The depth of sub-tables to traverse through and print.
---@param n number @Do NOT manually set this. This controls formatting through recursion.
local function table_to_string(tbl, depth, n)
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
					final = final .. table_to_string(value, depth - 1, n + 4) .. "\n"
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

local function notify(str)
	naughty.notify({
		text = table_to_string(str),
		shape = gears.shape.rounded_rect,
	})
end

---A helper function to spawn with logging
---@param command string @Command to execute
---@param single_instance boolean @Launch Single Instance
---@param log boolean @Should log
---@param log_err boolean @Should log errors
local function spawn(command, single_instance, log, log_err)
	local log_file = "/dev/null"
	local log_err_file = "/dev/null"

	local name = "default"
	local found = command:find(" ")
	if found then
		name = command:sub(1, found - 1)
	end

	if log then
		log_file = "~/log/" .. name .. ".log"
	end
	if log_err then
		log_file = "~/log/" .. name .. ".err.log"
	end
	local log_str = "1>> " .. log_file .. " 2>> " .. log_err_file

	if single_instance then
		awful.spawn(
			"sh -c 'pidof "
				.. name
				.. ' > /dev/null && echo "'
				.. name
				.. ' is already running" || '
				.. (command or name)
				.. log_str
				.. "'"
		)
	else
		awful.spawn(
			"sh -c 'pidof "
				.. command
				.. ' > /dev/null && echo "'
				.. command
				.. ' is already running" || '
				.. command
				.. log_str
				.. "'"
		)
	end
end

-- see if the file exists
local function file_exists(file)
	local f = io.open(file, "rb")
	if f then
		f:close()
	end
	return f ~= nil
end

-- get all lines from a file, returns an empty
-- list/table if the file does not exist
local function lines_from(file)
	if not file_exists(file) then
		return {}
	end
	lines = {}
	for line in io.lines(file) do
		lines[#lines + 1] = line
	end
	return lines
end

local function is_process_running(ps)
	return io.popen("pidof " .. ps):read("*all") ~= ""
end

-- Average CPU
local function get_cpu()
	local line = lines_from("/proc/stat")[1]
	local cols = gears.string.split(line, " ")
	local obj = {
		user = cols[2],
		nice = cols[3],
		system = cols[4],
		idle = cols[5],
		iowait = cols[6],
		irq = cols[7],
		softirq = cols[8],
	}

	return math.floor(
		(obj.idle * 100) / (obj.user + obj.nice + obj.system + obj.idle + obj.iowait + obj.irq + obj.softirq)
	)
end

local function read_file(str)
	local file = io.open(str, "r")
	local text = file:read("*all")
	file:close()
	return text
end

local function get_ram()
	local lines = lines_from("/proc/meminfo")

	local total = tonumber(lines[1]:match("[%d]+"))
	local free = tonumber(lines[2]:match("[%d]+"))

	local percent = math.floor(((total - free) / total) * 100)
	return percent
end

local function get_swap()
	local lines = lines_from("/proc/meminfo")

	local total = tonumber(lines[15]:match("[%d]+"))
	local free = tonumber(lines[16]:match("[%d]+"))

	local percent = math.floor(((total - free) / total) * 100)
	return percent
end

local function is_plugged(sys_file)
	return read_file(sys_file or "/sys/class/power_supply/ACAD/online") == "1"
end

local function get_battery(sys_file)
	return tonumber(read_file(sys_file or "/sys/class/power_supply/BAT1/capacity"))
end

local function get_volume()
	return io.popen([[amixer sget Master | grep -Po 'Left: Playback.*\[\K[\d]+(?=%\])']]):read("*all")
end

local function get_ping()
	return io.popen([[SB=3 ~/dotfiles/scripts/ping]]):read("*all")
end

local function get_storage()
	return io.popen([[df /dev/sda6 | awk 'FNR==2 { printf ($3*100)/($3+$4) }']]):read("*all")
end

local function sleep(n) -- seconds
	local t0 = os.clock()
	while os.clock() - t0 <= n do
	end
end

local function add_padding_if_not_len(str, desired_len)
	if #str < desired_len then
		return string.rep(" ", desired_len - #str) .. str
	else
		return str
	end
end

local function determine_color(value,okay,warning,error)
	local color = beautiful.defaults.okay_color
	if value > 0.80 then
		color = beautiful.error_color
	elseif value > 0.70 then
		color = beautiful.warning_color
	elseif value > 0.60 then
		color = beautiful.error_color
	end
	return color
end