local mod = get_mod("Jukebox")

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

mod._settings = mod:persistent_table("settings", {})
mod.update_functions = {}

mod.current_track = mod:get("last_played_track") or 15
mod.playing = false
mod.current_track_playtime = 0

mod:io_dofile("Jukebox/scripts/mods/Jukebox/modules/servitor_skull")
mod:io_dofile("Jukebox/scripts/mods/Jukebox/modules/insert_localization")
mod:io_dofile("Jukebox/scripts/mods/Jukebox/modules/insert_blueprints")
mod:io_dofile("Jukebox/scripts/mods/Jukebox/modules/insert_actions")
mod:io_dofile("Jukebox/scripts/mods/Jukebox/modules/jukebox_view_register")
mod:io_dofile("Jukebox/scripts/mods/Jukebox/modules/dance")
mod:io_dofile("Jukebox/scripts/mods/Jukebox/modules/disco")

local music_tracks = mod:io_dofile("Jukebox/scripts/mods/Jukebox/modules/music_tracks")
local mod_widgets = mod:io_dofile("Jukebox/scripts/mods/Jukebox/Jukebox_data").options.widgets

local servitor = mod:persistent_table("servitor")
local disco_ball = mod:persistent_table("disco_ball")
local history = mod:persistent_table("history.tracks", {
	tracks = {},
	cursor = 0,
})

local MISSION_INTRO_CUTOFF = 62
local HACK_FRAMES = 3
local HACK_TRACK_INDEX = 8 -- Dropship to Hive Tertium
local TRACKS_NEEDING_HACKS = {
	"The Torrent Fights Back",
	"Write Transmit",
	"Embrace of the Chaos Cult",
	"Forge Chaos Detected",
	"Imperial Advance",
}

for _, widget in pairs(mod_widgets) do
	mod._settings[widget.setting_id] = mod:get(widget.setting_id)
end

mod.reset_music = function()
	local mission = Managers.state and Managers.state.mission and Managers.state.mission._mission
	local music_game_state
	local music_zone

	if mission then
		music_zone = mission.wwise_state

		if mission.mechanism_name == "hub" then
			music_game_state = "hub"
		elseif mission.mechanism_name == "adventure" then
			music_game_state = "mission"
		elseif mission.mechanism_name == "onboarding" then
			music_game_state = music_zone == "prologue" and "mission" or nil
		end
	end

	Wwise.set_state("music_game_state", music_game_state or "None")
	Wwise.set_state("music_zone", music_zone or "None")
	Wwise.set_state("music_objective", "None")
	Wwise.set_state("music_combat", "None")
	Wwise.set_state("event_intensity", "low")
	Wwise.set_state("music_objective_progression", "one")
	Wwise.set_state("minion_aggro_intensity", "None")
end

mod.disable_track = function(track_index)
	mod.disabled_tracks[#mod.disabled_tracks + 1] = track_index
end

mod.enable_track = function(track_index)
	mod.disabled_tracks = table.filter(mod.disabled_tracks, function(track)
		return track ~= track_index
	end)
end

mod.track_disabled = function(track_index)
	return table.contains(mod.disabled_tracks, track_index)
end

mod.track_valid = function(track_index)
	return music_tracks[track_index] and not music_tracks[track_index].disabled
end

mod.track_recent = function(track, number_of_tracks)
	local recently_played = false

	if number_of_tracks >= #music_tracks then
		number_of_tracks = #music_tracks - 1
	end

	if number_of_tracks >= #history.tracks then
		number_of_tracks = #history.tracks - 1
	end

	if number_of_tracks < 1 then
		return false
	end

	for i = 0, number_of_tracks - 1 do
		if history.tracks[#history.tracks - i] == track then
			recently_played = true
			break
		end
	end

	return recently_played
end

mod.debug_history = function(current_cursor)
	print(
		string.format(
			"\ncursor: %s -> %s, track: #%s %s (%s)",
			current_cursor,
			history.cursor,
			mod.current_track,
			music_tracks[mod.current_track].name,
			os.clock()
		)
	)

	for i, track in ipairs(history.tracks) do
		local index_format

		if history.cursor == i then
			index_format = i < 10 and "[%s] " or "[%s]"
		else
			index_format = i < 10 and " %s  " or " %s "
		end

		print(string.format("%s #%s %s", string.format(index_format, i), track, music_tracks[track].name))
	end
end

mod._play_track = function(track_index, duration)
	if not mod.track_valid(track_index) then
		mod.playing = false

		return false
	end

	mod.playing = true
	mod.current_track = track_index
	mod.current_track_playtime = 0

	if mod:get("show_track_changes") and not mod.queued then
		mod:notify(music_tracks[mod.current_track].name)
	end

	local jukebox_view = Managers.ui:view_instance("jukebox_view")

	if jukebox_view then
		if not (mod.queued and mod.current_track == HACK_TRACK_INDEX) then
			jukebox_view._widgets_by_name.now_playing.content.text = music_tracks[mod.current_track].name
		end
	end

	-- local pre_cursor = history.cursor

	if history.cursor == #history.tracks and history.tracks[history.cursor] ~= mod.current_track then
		history.tracks[#history.tracks + 1] = track_index
		history.cursor = history.cursor + 1
	end

	-- mod.debug_history(pre_cursor)

	mod.dance()
	return true
end

mod._progress_track = function(next)
	if next == nil then
		next = true
	end

	local previous = not next

	mod.reset_music()

	mod.playing = false
	mod.current_track_playtime = 0

	if next and history.cursor < #history.tracks then
		history.cursor = history.cursor + 1

		mod.current_track = history.tracks[history.cursor]

		mod.play()

		return mod.current_track
	end

	if previous then
		if history.cursor > 1 then
			history.cursor = history.cursor - 1
		elseif history.cursor < 0 then
			history.cursor = 0
		end

		mod.current_track = history.tracks[history.cursor] or mod.current_track

		mod.play()

		return mod.current_track
	end

	local no_repeat_range = math.ceil((#music_tracks - #mod.disabled_tracks) * 0.75)

	if #mod.disabled_tracks >= #music_tracks then
		return
	end

	repeat
		if mod:get("shuffle") then
			mod.current_track = math.random(1, #music_tracks)
		elseif mod.current_track >= #music_tracks then
			mod.current_track = 1
		else
			mod.current_track = mod.current_track + 1
		end
	until mod.track_valid(mod.current_track)
		and not mod.track_disabled(mod.current_track)
		and not mod.track_recent(mod.current_track, no_repeat_range)

	mod.play()

	return mod.current_track
end

mod._queue_track = function(track_index, delay)
	mod.queued = {
		track = track_index,
		update_count = 0,
	}

	mod._play_track(HACK_TRACK_INDEX)
	--[[
		Boss tracks other than 'Hab Block Bonanza' and 'Nightsider' glitch when
		played in the Psykhanium unless played after certain special tracks.
		This plays 'Dropship to Hive Tertium' for 3 frames prior to those tracks.
	]]
end

mod.play = function()
	mod.reset_music()

	local needs_hack = table.contains(TRACKS_NEEDING_HACKS, music_tracks[mod.current_track].name)

	if needs_hack then
		mod._queue_track(mod.current_track)
	else
		mod._play_track(mod.current_track)
	end
end

mod.stop = function()
	mod.reset_music()
	mod.dancing = false
	mod.disco_ball_disable()
	mod.playing = false
end

mod.next = function()
	mod._progress_track()
end

mod.previous = function()
	mod._progress_track(false)
end

mod.play_stop_toggle = function()
	if mod.playing then
		mod.stop()
	else
		mod.play()
	end
end

local _servitor_update = function(dt, t)
	if not ALIVE[servitor.handler:unit()] then
		return
	end

	servitor.handler:_handle_floating_z_offset(dt, t)

	local state = servitor.handler._movement_state

	if state == "idle" then
		servitor.handler:_calculate_idle(dt, t)
	elseif state == "direct" then
		servitor.handler:_calculate_direct(dt)
	elseif state == "arc" then
		servitor.handler:_calculate_arc(dt)
	end

	servitor.handler:_move(dt)
	servitor.handler:_handle_lookat(dt)
end

mod.update = function(dt)
	if mod.scheduled_spawn and Managers.time:time("main") > mod.scheduled_spawn then
		mod.spawn_servitor()
		mod.spawn_disco_ball()
		mod.scheduled_spawn = nil
	end

	if servitor.handler and servitor.handler:unit() and Unit.alive(servitor.handler:unit()) then
		local player_unit = Managers.player:local_player_safe(1).player_unit

		if not player_unit then
			return
		end

		local player_position = Unit.local_position(player_unit, 1)

		_servitor_update(dt, Managers.time:time("main"))

		servitor.handler:update_lookat_position(player_position)

		if mod.playing then
			servitor.handler._float_z_offset_magnitude = 0.1
			servitor.handler._float_z_speed = 6
		else
			servitor.handler._float_z_offset_magnitude = 0.015
			servitor.handler._float_z_speed = 1.5
		end
	end

	if Unit.alive(disco_ball.unit) then
		if mod.playing and not disco_ball.on then
			mod.disco_ball_enable()
		elseif not mod.playing and disco_ball.on then
			mod.disco_ball_disable()
		end
	end

	if mod._settings.enable_media_keys then
		if Keyboard.released(179) then -- "play / pause"
			mod.play_stop_toggle()
		end

		if Keyboard.released(178) then -- "stop"
			mod.stop()
		end

		if Keyboard.released(177) then -- "previous track"
			mod.previous()
		end

		if Keyboard.released(176) then -- "next track"
			mod.next()
		end
	end

	if mod.queued then
		if mod.queued.update_count < HACK_FRAMES then
			mod.queued.update_count = mod.queued.update_count + 1
		else
			local track_to_play = mod.queued.track

			mod.playing = false
			mod.queued = nil
			mod._play_track(track_to_play)
		end
	end

	if mod.playing then
		mod.current_track_playtime = mod.current_track_playtime + dt

		local duration = music_tracks[mod.current_track].music_game_state == "mission_intro" and MISSION_INTRO_CUTOFF
			or music_tracks[mod.current_track].duration
			or music_tracks[mod.current_track].soundtrack_duration

		if mod.current_track_playtime > duration then
			mod.playing = false

			if mod:get("autoplay") then
				mod._progress_track()
			else
				mod.reset_music()
			end
		end
	end

	for _, fun in pairs(mod.update_functions) do
		fun(dt)
	end
end

mod.on_game_state_changed = function(status, sub_state_name)
	if status == "enter" and sub_state_name == "GameplayStateRun" then
		local game_mode = Managers.state.game_mode:game_mode_name()

		if game_mode == "hub" then
			mod.scheduled_spawn = Managers.time:time("main") + 1
		else
			mod.spawn_servitor()
			mod.spawn_disco_ball()
		end
	end

	local state_name = Managers.ui and Managers.ui:get_current_state_name()

	if not mod.playing then
		if
			status == "enter"
			and state_name == "StateMainMenu"
			and mod._settings.play_on_start == "character_select"
		then
			mod.play()
		end

		if
			status == "enter"
			and state_name == "StateGameplay"
			and sub_state_name == "GameplayStateRun"
			and mod._settings.play_on_start == "mourningstar"
		then
			mod.play()
		end
	end

	if mod.dancing then
		mod.dancing = false
	end

	if status == "exit" and mod.disco_ball_alive() then
		mod.despawn_disco_ball()
	end
end

mod.on_setting_changed = function(changed_setting)
	mod._settings[changed_setting] = mod:get(changed_setting)

	if changed_setting == "disco" and mod._settings.disco == false then
		mod.disco_ball_disable()
	end
end

mod.on_unload = function()
	mod:set("disabled_tracks", mod.disabled_tracks)
	mod:set("last_played_track", mod.current_track)
end

mod._open_jukebox = function()
	if not Managers.ui:view_instance("jukebox_view") then
		Managers.ui:open_view("jukebox_view", nil, nil, nil, nil, {})
	end
end

mod.toggle_jukebox = function()
	if
		not Managers.ui:has_active_view()
		and not Managers.ui:chat_using_input()
		and not Managers.ui:view_instance("jukebox_view")
	then
		Managers.ui:open_view("jukebox_view", nil, nil, nil, nil, {})
	elseif Managers.ui:view_instance("jukebox_view") then
		Managers.ui:close_view("jukebox_view")
	end
end

mod:hook(WwiseGameSyncManager, "update", function(fun, self, dt, t)
	if not mod.playing then
		fun(self, dt, t)
		return
	end

	Wwise.set_state("music_game_state", music_tracks[mod.current_track].music_game_state or "None")
	Wwise.set_state("music_zone", music_tracks[mod.current_track].music_zone or "None")
	Wwise.set_state("music_objective", music_tracks[mod.current_track].music_objective or "None")
	Wwise.set_state("music_combat", music_tracks[mod.current_track].music_combat or "None")
	Wwise.set_state("event_intensity", music_tracks[mod.current_track].event_intensity or "low")
	Wwise.set_state("music_objective_progression", music_tracks[mod.current_track].music_objective_progression or "one")
	Wwise.set_state("minion_aggro_intensity", music_tracks[mod.current_track].minion_aggro_intensity or "None")
end)

mod:command("jb", "Jukebox <play | stop | next | prev | track | dance>", function(action)
	if action == nil or action == "open" then
		mod.toggle_jukebox()
	end

	if action == "play" then
		mod.play()
	end

	if action == "stop" then
		mod.stop()
	end

	if action == "next" then
		mod.next()
	end

	if action == "previous" or action == "prev" then
		mod.previous()
	end

	if action == "track" or action == "playing" or action == "current" or action == "info" then
		if mod.playing then
			mod:echo(string.format("%s: %s", mod:localize("current_track"), music_tracks[mod.current_track].name))
		else
			mod:echo(mod:localize("no_track_queued"))
		end
	end

	if action == "dance" then
		mod.dance()
	end
end)

if mod:get("play_on_start") == "title" then
	mod.play()
end
