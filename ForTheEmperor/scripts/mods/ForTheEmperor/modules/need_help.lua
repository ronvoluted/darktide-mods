local mod = get_mod("ForTheEmperor")

local memoised_vo_settings = mod:persistent_table("memoised_vo_settings", {})

mod.help_markers = {}


mod.vo_call_for_help = function(player_needing_help)
	local vo_settings_path = "dialogues/generated/gameplay_vo_" .. player_needing_help._profile.selected_voice

	local vo_settings = memoised_vo_settings[vo_settings_path]

	if not vo_settings then
		vo_settings = require(vo_settings_path)
		memoised_vo_settings[vo_settings_path] = vo_settings
	end

	local vo_sound_events = vo_settings.calling_for_help.sound_events
	local vo_sound_from_pool = vo_sound_events[math.random(#vo_sound_events)]
	local vo_file_path = "wwise/externals/" .. vo_sound_from_pool

	local local_player = Managers.player:local_player_safe(1)
	local world = Managers.world:world("level_world")
	local wwise_world = Managers.world:wwise_world(world)

	if player_needing_help ~= local_player then
		Managers.ui:play_2d_sound("wwise/events/ui/play_hud_objective_part_done")

		wwise_world:trigger_resource_external_event(
			"wwise/events/vo/play_sfx_es_player_vo",
			"es_vo_prio_1",
			vo_file_path,
			4,
			wwise_world:make_auto_source(player_needing_help.player_unit, 1)
		)
	else
		wwise_world:trigger_resource_external_event(
			"wwise/events/vo/play_sfx_es_player_vo_2d",
			"es_player_vo_2d",
			vo_file_path,
			4,
			wwise_world:make_auto_source(local_player.player_unit, 1)
		)
	end
end

mod.need_help = function(cooldown)
	if mod.last_need_help and os.clock() - mod.last_need_help < cooldown then
		return
	end

	mod.vo_call_for_help(Managers.player:local_player_safe(1))
	mod.send_wheel_message(mod:localize("need_help"), cooldown, "need_help")

	mod.last_need_help = os.clock()
end

mod:hook_safe("VivoxManager", "_handle_event", function(self, message)
	if message.message_body and not message.is_current_user and string.find(message.message_body, "#need_help") then
		if mod:get("ignore_help") then
			return
		end

		local session_handle = message.session_handle
		local participant_uri = message.participant_uri
		local sender = Managers.chat._sessions[session_handle].participants[participant_uri]
		local peer_id = sender.peer_id

		local player_needing_help = Managers.player._players_by_peer[peer_id][1]

		mod.vo_call_for_help(player_needing_help)

		if mod.help_markers[peer_id] then
			Managers.event:trigger("remove_world_marker", mod.help_markers[peer_id].marker_id)
		end

		local callback = function(marker_id)
			mod.help_markers[peer_id] = {
				marker_id = marker_id,
				time = os.clock(),
			}
		end

		Managers.event:trigger(
			"add_world_marker_unit",
			"player_assistance",
			player_needing_help.player_unit,
			callback,
			{
				player = player_needing_help,
			}
		)
	end
end)
