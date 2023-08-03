local mod = get_mod("Audio")

mod.play_wwise = function(path)
	local world = Managers.ui:world()
	local wwise_world = Managers.world:wwise_world(world)

	-- Parameters (wwise_world, sound_event, sound_source, file_path, 4, wwise_source_id)
	WwiseWorld.trigger_resource_external_event(
		wwise_world,
		"wwise/events/vo/play_sfx_es_mission_giver_vo",
		"es_mission_giver_vo",
		"wwise/externals/loc_enemy_captain_brute_a__reinforcements_03",
		4, -- Ogg Vorbis file format id
		1115
	)
end

mod:command("vorbis", "Play Ogg Vorbis file", function()
	mod.play_wise()
end)
