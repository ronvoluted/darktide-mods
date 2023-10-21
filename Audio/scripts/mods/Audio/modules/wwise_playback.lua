local Audio = get_mod("Audio")
local utilities = Audio:io_dofile("Audio/scripts/mods/Audio/modules/utilities")
local get_userdata_type = utilities.get_userdata_type

Audio.play = function(wwise_event_name_or_loc, unit_or_position_or_id, node_or_rotation_or_boolean)
	local world = Managers.ui:world()
	local wwise_world = Managers.world:wwise_world(world)

	if string.starts_with(wwise_event_name_or_loc, "wwise/events") then
		return wwise_world:trigger_resource_event(
			wwise_event_name_or_loc,
			unit_or_position_or_id,
			node_or_rotation_or_boolean
		)
	end

	local source_id
	if not unit_or_position_or_id then
		local player_unit = Managers.player:local_player_safe(1).player_unit

		source_id = wwise_world:make_auto_source(player_unit, node_or_rotation_or_boolean)
	elseif type(unit_or_position_or_id) == "number" then
		source_id = unit_or_position_or_id
	elseif type(unit_or_position_or_id) == "userdata" then
		local userdata_type = get_userdata_type(unit_or_position_or_id)
		if userdata_type == "Unit" then
			source_id = wwise_world:make_auto_source(unit_or_position_or_id, node_or_rotation_or_boolean)
		elseif userdata_type == "Vector3" then
			source_id = wwise_world:make_manual_source(unit_or_position_or_id, node_or_rotation_or_boolean)
		end
	end

	local wwise_external_event_name = string.starts_with(wwise_event_name_or_loc, "wwise/externals/")
			and wwise_event_name_or_loc
		or "wwise/externals/" .. wwise_event_name_or_loc

	if string.starts_with(wwise_event_name_or_loc, "loc_") then
		return wwise_world:trigger_resource_external_event(
			"wwise/events/vo/play_sfx_es_player_vo",
			"es_vo_prio_1",
			wwise_external_event_name,
			4,
			source_id
		)
	end
end
