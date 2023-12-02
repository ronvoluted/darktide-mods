local mod = get_mod("AutoBackup")

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

local _io = Mods.lua.io
local _os = Mods.lua.os

local PLATFORMS = {
	gamepass = {
		appdata_directory = os.getenv("AppData") .. "\\Fatshark\\MicrosoftStore\\Darktide\\",
	},
	steam = {
		appdata_directory = os.getenv("AppData") .. "\\Fatshark\\Darktide\\",
	},
}

local WEEK_SECONDS = 604800

mod.file_modified_datetime = function(file_path)
	local handle = _io.popen(string.format("dir /T:W %s", file_path))
	local dir_output = handle:read("*a")
	handle:close()

	local datetime_pattern = "(%d+/%d+/%d+%s+%d+:%d+)" -- 29/05/2023  13:57
	local datetime_elements_pattern = "(%d+)/(%d+)/(%d+)%s+(%d+):(%d+)" -- 29 05 2023 13 57
	local datetime_string = dir_output:match(datetime_pattern)
	local ampm_pattern = string.format("%s%%s+(%%a%%a)", datetime_string) -- PM | AM | nil

	local day, month, year, hour, min = dir_output:match(datetime_elements_pattern)
	local ampm = dir_output:match(ampm_pattern)

	return os.time({
		year = tonumber(year),
		month = tonumber((month:gsub("^0+", ""))),
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

mod.backup = function(config_path, backup_path)
	_os.execute(string.format('copy /b "%s" "%s" > nul', config_path, backup_path))
end

local show_reset_warning = function(appdata_directory)
	local context = {
		title_text = "loc_auto_backup_reset_warning_title",
		description_text = "loc_auto_backup_reset_warning_description",
		options = {
			{
				text = "loc_auto_backup_reset_warning_okay",
				close_on_pressed = true,
			},
			{
				text = "loc_auto_backup_reset_warning_exit",
				close_on_pressed = true,
				callback = function()
					_os.execute(string.format('explorer "%s"', appdata_directory))
					Application.quit()
				end,
			},
		},
	}

	Managers.event:trigger("event_show_ui_popup", context)
end

local run = function(platform_name)
	local platform = PLATFORMS[platform_name]
	platform.config_path = platform.appdata_directory .. "user_settings.config"
	platform.backup_path = platform.appdata_directory .. "user_settings_backup.config"
	platform.backup_weekly_path = platform.appdata_directory .. "user_settings_backup_weekly.config"

	if mod.file_exists(platform.config_path) then
		platform.possible_reset = mod.file_exists(platform.backup_path)
			and mod.file_exists(platform.backup_weekly_path)
			and not mod:get("has_run_before")

		if platform.possible_reset then
			if not mod:get("warning_shown") then
				show_reset_warning(platform.appdata_directory)

				mod:set("warning_shown", true)
			end
		else
			mod.backup(platform.config_path, platform.backup_path)

			if not mod.file_exists(platform.backup_weekly_path) then
				mod.backup(platform.config_path, platform.backup_weekly_path)
			elseif os.time() > mod.file_modified_datetime(platform.backup_weekly_path) + WEEK_SECONDS then
				mod.backup(platform.config_path, platform.backup_weekly_path)
			end

			mod:set("has_run_before", true)
		end
	end
end

if Steam then
	run("steam")
else
	run("gamepass")
end

mod.on_unload = function(exit_game)
	if exit_game then
		local platform = PLATFORMS[Steam and "steam" or "gamepass"]

		if not platform.possible_reset then
			mod.backup(platform.config_path, platform.backup_path)
		end
	end
end

mod:hook("LocalizationManager", "localize", function(fun, self, ...)
	self._string_cache.loc_auto_backup_reset_warning_title = mod:localize("reset_warning_title")
	self._string_cache.loc_auto_backup_reset_warning_description = mod:localize("reset_warning_descripton")
	self._string_cache.loc_auto_backup_reset_warning_okay = mod:localize("reset_warning_okay")
	self._string_cache.loc_auto_backup_reset_warning_exit = mod:localize("reset_warning_exit")

	return fun(self, ...)
end)
