local Audio = get_mod("Audio")

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

local log_server_commands = Audio:get("log_server_commands")

Audio.settings_changed_functions = {}
Audio.mods_loaded_functions = {}
Audio.update_functions = {}

Audio:io_dofile("Audio/scripts/mods/Audio/modules/utilities")
Audio:io_dofile("Audio/scripts/mods/Audio/modules/audio_files_handler")
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

	-- get_mod("Tests").run(Audio) -- Uncomment to run tests in 'watch mode'
end

Audio.update = function(dt)
	for _, fun in pairs(Audio.update_functions) do
		fun(dt)
	end
end

Audio.on_unload = function()
	Audio.stop_file()
end

Audio:hook(Log, "_info", function(fun, category, message, ...)
	if log_server_commands or not message or (message and not message:find("localhost")) then
		fun(category, message, ...)
	end
end)

Audio:command("quack", "Play test quacks from Audio Plugin", function()
	Audio.play_file("quack.ogg", { loop = 3 })
end)
