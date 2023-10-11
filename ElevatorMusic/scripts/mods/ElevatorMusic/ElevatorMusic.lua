local mod = get_mod("ElevatorMusic")
local Audio

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

local muzak_volume = mod:get("muzak_volume")
local play_file_id_table = mod:persistent_table("play_file_id_table", {})
local ascension_started = mod:persistent_table("ascension_started", {})

local TRACKS = {
	"AaronPaulLow_ElevatorToHeaven.opus",
	"BenSound_TheElevatorBossaNova.opus",
	"DarGolan_ElevatorMusic.opus",
	"GeoffreyBurch_TheGhostOfShepardsPie.opus",
	"GiulioFazio_TheFunnyBunch.opus",
	"MonumentMusic_DreamByDreams.opus",
	"MonumentMusic_GlassOfWine.opus",
	"MonumentMusic_Pure.opus",
}

local riding_elevator = false

local stop_muzak = function()
	for _, play_file_id in pairs(play_file_id_table) do
		Audio.stop_file(play_file_id)
	end

	play_file_id_table = {}
end

mod:hook(MoveablePlatformSystem, "units_are_locked", function(fun, self)
	local are_locked = fun(self)

	if are_locked and not riding_elevator then
		riding_elevator = true

		play_file_id_table[#play_file_id_table + 1] = Audio.play_file(TRACKS[math.random(1, 8)], {
			audio_type = "music",
			afade = "t=in:ss=0:d=2",
			silenceremove = "start_periods=1:stop_periods=1",
			volume = muzak_volume,
		})
	elseif riding_elevator and not are_locked then
		riding_elevator = false

		stop_muzak()
	end

	return are_locked
end)

-- Treat Ascension Riser as a glorified elevator
mod:hook(WwiseGameSyncManager, "_set_state", function(fun, self, group_name, new_state)

	if
		ascension_started[1]
		and Managers.state.mission._mission.name == "dm_rise"
		and ((group_name == "music_objective" and new_state == "last_man_standing") or (group_name == "music_combat" and new_state == "boss"))
	then
		return
	end

	if
		group_name == "music_objective"
		and new_state == "demolition_event"
		and Managers.state.mission._mission.name == "dm_rise"
	then
		if not ascension_started[1] and not play_file_id_table[1] and not Managers.state.cinematic:active() then
			play_file_id_table[#play_file_id_table + 1] = Audio.play_file(TRACKS[math.random(1, 8)], {
				audio_type = "music",
				afade = "t=in:ss=0:d=2",
				loop = 0,
				silenceremove = "start_periods=1:stop_periods=1",
				volume = muzak_volume,
			})

			ascension_started[1] = true
		end

		-- Withold game music
		fun(self, "music_objective", "None")
		fun(self, "event_intensity", "low")

		return
	end

	fun(self, group_name, new_state)
end)

-- Stop music once you leave in the Valkyrie in Ascension Riser
mod:hook_safe(CinematicSceneSystem, "_play_cutscene", function(self, cinematic_name, client_channel_id)
	if Managers.state.mission._mission.name == "dm_rise" and cinematic_name == "outro_win" then
		stop_muzak()
	end
end)

mod.on_all_mods_loaded = function()
	local LocalServer = get_mod("DarktideLocalServer")
	Audio = get_mod("Audio")

	if not LocalServer then
		mod:echo(
			'Required mod "DarktideLocalServer" not found: Download from Nexus Mods and make sure it is in mod_load_order.txt'
		)
	end

	if not Audio then
		mod:echo('Required mod "Audio" not found: Download from Nexus Mods and make sure it is in mod_load_order.txt')
	end

	if not Audio or not LocalServer then
		mod:disable_all_hooks()
		mod:disable_all_commands()
	end
end

mod.on_game_state_changed = function(status, sub_state_name)
	if ascension_started[1] and sub_state_name == "StateGameplay" and status == "exit" then
		ascension_started = {}
	end
end
