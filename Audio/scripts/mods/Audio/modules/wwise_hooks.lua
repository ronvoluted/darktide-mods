local mod = get_mod("Audio")
local tools = get_mod("Tools")

mod.patches = {}

local success, event_names = tools.load_table({
	file_name = "wwise_event_names",
})

mod.check_collected = function(event_name)
	return table.contains(event_names, event_name)
end

mod.collect_if_new = function(data)
	if not mod.check_collected(data.event_name) then
		-- event_names[#event_names] = {
		-- 	event_name = event_name,
		-- 	time = os.time(),
		-- }
		event_names[#event_names] = data
	end
end

mod.save_collected = function()
	tools.save_table(event_names, {
		file_name = "wwise_event_names",
	})
end

mod:hook(
	WwiseWorld,
	"trigger_resource_event",
	function(fun, wwise_world, wwise_event_name, unit_or_source_id, optional_node)
		if type(unit_or_source_id) == nil then -- 2D sound
			mod.collect_if_new({
				type = "2d",
				event_name = wwise_event_name,
				time = os.time(),
			})

			fun(wwise_world, wwise_event_name)
		end

		-- local optional_params = { ... }
		-- for i, v in ipairs(optional_params) do
		-- 	print(tostring(i) .. ": " .. tostring(v))
		-- end
		-- print(type(unit_or_source_id), unit_or_source_id)

		if type(unit_or_source_id) == "number" then -- source_id
			mod.collect_if_new({
				type = "2d_with_source_id",
				event_name = wwise_event_name,
				source_id = unit_or_source_id,
				time = os.time(),
			})

			fun(wwise_world, wwise_event_name, unit_or_source_id)
		end

		if type(unit_or_source_id) == "unitdata" then
			if tostring(unit_or_source_id):sub(1, 7) == "Vector3" then -- 3D sound
				mod.collect_if_new({
					type = "3d",
					event_name = wwise_event_name,
					position = { unit_or_source_id[1], unit_or_source_id[2], unit_or_source_id[3] },
					time = os.time(),
				})

				print({ unit_or_source_id[1], unit_or_source_id[2], unit_or_source_id[3] })

				fun(wwise_world, wwise_event_name, unit_or_source_id)
			elseif tostring(unit_or_source_id):sub(2, 5) == "Unit" then -- Unit sound
				local breed_data = Unit.get_data(unit_or_source_id, "breed")

				-- if breed_data then
				-- 	mod:dump(breed_data)
				-- end

				mod.collect_if_new({
					type = "unit",
					event_name = wwise_event_name,
					-- position = { unit_or_source_id[1], unit_or_source_id[2], unit_or_source_id[3] },
					time = os.time(),
				})

				fun(wwise_world, wwise_event_name, unit_or_source_id, optional_node)
			end
		end

		-- print(event_name)
		-- if event_name == "wwise/events/music/play_music_manager" then
		-- 	print("wwise/events/music/play_music_manager triggered")
		-- end
	end
)

mod:hook(
	DialogueSystemWwise,
	"trigger_vorbis_external_event",
	function(fun, self, sound_event, sound_source, file_path, wwise_source_id)
		mod:dump({
			sound_event = sound_event,
			sound_source = sound_source,
			file_path = file_path,
			wwise_source_id = wwise_source_id,
		}, "trigger_vorbis_external_event", 2)

		return fun(self, sound_event, sound_source, file_path, wwise_source_id)
	end
)

mod.patch_sound = function()
	--
end

mod.patch_vo = function()
	--
end

mod:command("check_event_names", "Print recently collected WWise event names", function(range)
	range = tonumber(range) or 5

	for i = math.max(1, #event_names - range), #event_names do
		print(event_names[i])
	end
end)
