local Audio = get_mod("Audio")
local DLS = get_mod("DarktideLocalServer")

local utilities = Audio:io_dofile("Audio/scripts/mods/Audio/modules/utilities")
local get_userdata_type = utilities.get_userdata_type

local FFPLAY_FILENAME = "ffplay_dt.exe"
local FFPLAY_PATH = DLS.get_mod_path(Audio, "bin\\" .. FFPLAY_FILENAME, true)
local AUDIO_TYPE = table.enum("dialogue", "music", "sfx")
local PLAY_STATUS = table.enum("error", "fulfilled", "pending", "playing", "stopped", "success")
local TRACK_STATUS_INTERVAL = 1

local log_errors = Audio:get("log_errors")
local played_files = {}
local track_status_delta = 0

local listener_position_rotation = function()
	local player = Managers.player and Managers.player:local_player_safe(1)

	if not player then
		return Vector3.zero(), Quaternion.identity()
	end

	local listener_pose = Managers.state.camera:listener_pose(player.viewport_name)
	local lister_position = listener_pose and Matrix4x4.translation(listener_pose) or Vector3.zero()
	local lister_rotation = listener_pose and Matrix4x4.rotation(listener_pose) or Quaternion.identity()

	return lister_position, lister_rotation
end

local calculate_distance_filter = function(
	unit_or_position,
	decay,
	min_distance,
	max_distance,
	override_position,
	override_rotation,
	node
)
	if not Managers.ui or Managers.ui:get_current_sub_state_name() ~= "GameplayStateRun" then
		return 100, 1, 1
	end

	local input_type = get_userdata_type(unit_or_position)

	if input_type ~= "Unit" and input_type ~= "Vector3" then
		return 100, 1, 1
	end

	local position

	if input_type == "Unit" then
		position = Unit.local_position(unit_or_position, node or 1) or Vector3.zero()
	elseif input_type == "Vector3" then
		position = unit_or_position
	end

	local current_listener_position, current_listener_rotation
	if not override_position or not override_rotation then
		current_listener_position, current_listener_rotation = listener_position_rotation()
	end

	local listener_position = override_position or current_listener_position
	local listener_rotation = override_rotation or current_listener_rotation

	decay = decay or 0.01
	min_distance = min_distance or 0
	max_distance = max_distance or 100

	local distance = Vector3.distance(position, listener_position)
	local volume

	if distance < min_distance then
		volume = 100
	elseif distance > max_distance then
		volume = 0
	else
		local ratio = 1 - math.clamp((distance - min_distance) / (max_distance - min_distance), 0, 1)

		volume = math.clamp(100 * (ratio - (distance - min_distance) * decay), 0, 100)
	end

	local direction = position - listener_position
	local directionRotated = Quaternion.rotate(Quaternion.inverse(listener_rotation), direction)
	local directionRotatedNormalized = Vector3.normalize(directionRotated)
	local angle = math.atan2(directionRotatedNormalized.x, directionRotatedNormalized.y)

	local pan

	if angle > 0 then
		if angle <= math.pi / 2 then
			pan = angle / (math.pi / 2)
		else
			pan = 1 - (angle - math.pi / 2) / (math.pi / 2)
		end
	else
		if angle >= -math.pi / 2 then
			pan = angle / (math.pi / 2)
		else
			pan = -(1 + (angle + math.pi / 2) / (math.pi / 2))
		end
	end

	local left_volume = pan > 0 and 1 - pan or 1
	local right_volume = pan < 0 and 1 + pan or 1

	return volume, left_volume, right_volume
end

local volume_adjustment = function(audio_type)
	local master_volume = (Application.user_setting("sound_settings", "option_master_slider") or 100) / 100

	if not audio_type then
		return master_volume
	end

	if audio_type == AUDIO_TYPE.dialogue then
		local vo_trim = ((Application.user_setting("sound_settings", "options_vo_trim") or 0) / 10) + 1

		return master_volume * vo_trim
	end

	if audio_type == AUDIO_TYPE.music then
		local music_volume = (Application.user_setting("sound_settings", "options_music_slider") or 100) / 100

		return master_volume * music_volume
	end

	if audio_type == AUDIO_TYPE.sfx then
		local sfx_volume = (Application.user_setting("sound_settings", "options_sfx_slider") or 100) / 100

		return master_volume * sfx_volume
	end
end

Audio.play_file = function(
	path,
	playback_settings,
	unit_or_position,
	decay,
	min_distance,
	max_distance,
	override_position,
	override_rotation
)
	playback_settings = playback_settings or {}

	local volume, left_volume, right_volume = calculate_distance_filter(
		unit_or_position,
		decay,
		min_distance,
		max_distance,
		override_position,
		override_rotation
	)

	local adjusted_volume = math.round(volume * volume_adjustment(playback_settings.audio_type))
	local volume_multiplier = playback_settings.volume and (playback_settings.volume / 100) or 1
	local final_volume = math.round(adjusted_volume * volume_multiplier)

	local command = string.format(
		'%s -i "%s" -volume %s -af "pan=stereo|c0=%s*c0|c1=%s*c1 %s %s %s %s %s %s %s %s" %s %s %s -fast -nodisp -autoexit -loglevel quiet -hide_banner',
		FFPLAY_PATH,
		DLS.absolute_path(path),
		final_volume,
		left_volume,
		right_volume,
		playback_settings.adelay and (", adelay=" .. playback_settings.adelay) or "",
		playback_settings.aecho and (", aecho=" .. playback_settings.aecho) or "",
		playback_settings.afade and (", afade=" .. playback_settings.afade) or "",
		playback_settings.atempo and (", atempo=" .. playback_settings.atempo) or "",
		playback_settings.chorus and (", chorus=" .. playback_settings.chorus) or "",
		playback_settings.silenceremove and (", silenceremove=" .. playback_settings.silenceremove) or "",
		playback_settings.speechnorm and (", speechnorm=" .. playback_settings.speechnorm) or "",
		playback_settings.stereotools and (", stereotools=" .. playback_settings.stereotools) or "",
		playback_settings.loop and ("-loop " .. playback_settings.loop) or "",
		playback_settings.pos and ("-ss " .. playback_settings.pos) or "",
		playback_settings.duration and ("-t " .. playback_settings.duration) or ""
	)

	local play_file_id = #played_files + 1

	played_files[play_file_id] = {
		status = PLAY_STATUS.pending,
		track_status = playback_settings.track_status or nil,
	}

	DLS.run_command(command)
		:next(function(response)
			local result = cjson.decode(response.body)

			played_files[play_file_id].status = result.success == true
					and (playback_settings.track_status and PLAY_STATUS.playing or PLAY_STATUS.success)
				or PLAY_STATUS.fulfilled

			played_files[play_file_id].pid = result.pid
		end)
		:catch(function(error)
			played_files[play_file_id].status = PLAY_STATUS.error

			if not log_errors then
				return
			end

			local success = error.body and cjson.decode(error.body).success

			if success == false then
				Audio:dump({
					command = command,
					status = error.status,
					body = error.body,
					description = error.description,
					headers = error.headers,
					response_time = error.response_time,
				}, string.format("Server run command failed: %s", os.date()), 2)
			end
		end)

	return play_file_id, command
end

Audio.stop_file = function(play_file_id)
	if not play_file_id then
		for _, played_file in pairs(played_files) do
			if played_file.pid then
				DLS.stop_process(played_file.pid)
				played_file.status = PLAY_STATUS.stopped
			end
		end

		return
	end

	local pid = play_file_id and played_files[play_file_id] and played_files[play_file_id].pid

	DLS.stop_process(pid)

	local file = played_files[play_file_id]

	if file then
		file.status = PLAY_STATUS.stopped
	end
end

Audio.file_status = function(play_file_id)
	return played_files[play_file_id] and played_files[play_file_id].status
end

Audio.file_pid = function(play_file_id)
	return played_files[play_file_id] and played_files[play_file_id].pid
end

Audio.is_file_playing = function(play_file_id)
	local pid = play_file_id and played_files[play_file_id] and played_files[play_file_id].pid

	if not pid then
		return false
	end

	return played_files[play_file_id].status == PLAY_STATUS.playing
end

Audio.mods_loaded_functions["play_file"] = function()
	if not DLS then
		Audio:echo(
			'Required mod "Darktide Local Server" not found: Download from Nexus Mods and make sure it is in your mod_load_order.txt'
		)
		Audio:disable_all_hooks()
		Audio:disable_all_commands()
	end
end

Audio.settings_changed_functions["play_file"] = function(setting_name)
	if setting_name == "log_errors" then
		log_errors = Audio:get("log_errors")
	end
end

Audio.update_functions["play_file"] = function(dt)
	if track_status_delta < TRACK_STATUS_INTERVAL then
		track_status_delta = track_status_delta + dt

		return
	end

	for play_file_id, played_file in pairs(played_files) do
		local track_status = played_file.track_status
		local pid = played_file.pid

		-- If we aren't tracking or a file has already stopped, there is no need to query the process
		-- If the played_file has a PID, it means the promise in play_file() was successful and an
		-- ffplay_dt instance launched
		if track_status and pid and played_file.status ~= PLAY_STATUS.stopped then
			local request = DLS.process_is_running(pid)
			request:next(function(response)
				if response.body.process_is_running == false then
					played_files[play_file_id].status = PLAY_STATUS.stopped

					if type(track_status) == "function" then
						track_status()
					end
				end
			end)
		end
	end

	track_status_delta = 0
end
