local mod = get_mod("AutoBackup")

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

local _io = Mods.lua.io
local _os = Mods.lua.os

local appdata_dir = os.getenv("AppData") .. "\\Fatshark\\Darktide\\"
local config_path = appdata_dir .. "user_settings.config"
local backup_path = appdata_dir .. "user_settings_backup.config"
local backup_weekly_path = appdata_dir .. "user_settings_backup_weekly.config"

local WEEK_SECONDS = 604800

mod.file_modified_datetime = function(file_path)
	local handle = _io.popen(string.format("dir /T:W %s", file_path))
	local dir_output = handle:read("*a")
	handle:close()

	local match_pattern = "(%d+)/(%d+)/(%d+)%s+(%d+):(%d+)%s+(%a%a)" -- 29/05/2023  12:57 PM
	local day, month, year, hour, min, ampm = dir_output:match(match_pattern)

	month = month:gsub("^0+", "")

	return os.time({
		year = tonumber(year),
		month = tonumber(month),
		day = tonumber(day),
		hour = tonumber(ampm == "PM" and tonumber(hour) + 12 or hour),
		min = tonumber(min),
		sec = 0,
	})
end

mod.file_exists = function(file_path)
	local file = _io.open(file_path, "r")

	if file then
		_io.close(file)
		return true
	else
		return false
	end
end

mod.backup = function(backup_path)
	_os.execute(string.format('copy /b "%s" "%s" > nul', config_path, backup_path))
end

mod.show_reset_warning = function()
	local context = {
		title_text = "loc_auto_backup_reset_warning_title",
		description_text = "loc_auto_backup_reset_warning_description",
		options = {
			{
				text = "loc_auto_backup_reset_warning_okay",
				close_on_pressed = true,
				callback = function()
					print(string.format('start "%s"', appdata_dir))
				end,
			},
			{
				text = "loc_auto_backup_reset_warning_exit",
				close_on_pressed = true,
				callback = function()
					_os.execute(string.format('explorer "%s"', appdata_dir))
					Application.quit()
				end,
			},
		},
	}

	Managers.event:trigger("event_show_ui_popup", context)
end

local likely_to_have_been_reset = mod.file_exists(backup_path)
	and mod.file_exists(backup_weekly_path)
	and not mod:get("has_run_before")

if likely_to_have_been_reset then
	if not mod:get("warning_shown") then
		mod.show_reset_warning()

		mod:set("warning_shown", true)
	end
else
	mod.backup(backup_path)

	if not mod.file_exists(backup_weekly_path) then
		mod.backup(backup_weekly_path)
	elseif os.time() > mod.file_modified_datetime(backup_weekly_path) + WEEK_SECONDS then
		mod.backup(backup_weekly_path)
	end

	mod:set("has_run_before", true)
end

mod.on_unload = function(exit_game)
	if exit_game and not likely_to_have_been_reset then
		mod.backup(backup_path)
	end
end

mod:hook("LocalizationManager", "localize", function(func, self, ...)
	self._string_cache.loc_auto_backup_reset_warning_title = mod:localize("reset_warning_title")
	self._string_cache.loc_auto_backup_reset_warning_description = mod:localize("reset_warning_descripton")
	self._string_cache.loc_auto_backup_reset_warning_okay = mod:localize("reset_warning_okay")
	self._string_cache.loc_auto_backup_reset_warning_exit = mod:localize("reset_warning_exit")

	return func(self, ...)
end)
