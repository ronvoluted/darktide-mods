local Audio = get_mod("Audio")

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

Audio.settings_changed_functions = {}
Audio.mods_loaded_functions = {}

Audio:io_dofile("Audio/scripts/mods/Audio/modules/utilities")
Audio:io_dofile("Audio/scripts/mods/Audio/modules/path_utilities")
Audio:io_dofile("Audio/scripts/mods/Audio/modules/play_file")
Audio:io_dofile("Audio/scripts/mods/Audio/modules/wwise_hooks")
Audio:io_dofile("Audio/scripts/mods/Audio/modules/wwise_playback")

Audio.on_setting_changed = function(setting_name)
	for _, fun in pairs(Audio.settings_changed_functions) do
		fun(setting_name)
	end
end

Audio.on_all_mods_loaded = function()
	for _, fun in pairs(Audio.mods_loaded_functions) do
		fun()
	end
end

Audio.on_unload = function()
	Audio.stop_file()
end
