local mod = get_mod("ElevatorMusic")
local Audio

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

local muzak_volume = mod:get("muzak_volume")

local tracks = {
	"AaronPaulLow_ElevatorToHeaven.opus",
	"BenSound_TheElevatorBossaNova.opus",
	"MonumentMusic_DreamByDreams.opus",
	"DarGolan_ElevatorMusic.opus",
	"MonumentMusic_GlassOfWine.opus",
	"GeoffreyBurch_TheGhostOfShepardsPie.opus",
	"MonumentMusic_Pure.opus",
	"GiulioFazio_TheFunnyBunch.opus",
}

local music_play_file_id

local start_muzak = function()
	music_play_file_id = Audio.play_file(tracks[math.random(1, 8)], {
		audio_type = "music",
		afade = "t=in:ss=0:d=2",
		silenceremove = "start_periods=1:stop_periods=1",
		volume = muzak_volume,
	})
end

local stop_muzak = function()
	Audio.stop_file(music_play_file_id)
end

mod.on_all_mods_loaded = function()
	Audio = get_mod("Audio")

	if not Audio then
		mod:echo(
			'Required mod "Audio Plugin" not found: Download from Nexus Mods and make sure "Audio" is in mod_load_order.txt'
		)

		mod:disable_all_hooks()
		mod:disable_all_commands()

		return
	end

	Audio.hook_sound("play_elevator_01_start", start_muzak)
	Audio.hook_sound("play_elevator_01_stop", stop_muzak)
end
