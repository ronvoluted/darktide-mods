local Audio = get_mod("Audio")
local DLS = get_mod("DarktideLocalServer")
-- local Tools = get_mod("Tools")
local utilities = Audio:io_dofile("Audio/scripts/mods/Audio/modules/utilities")
local get_userdata_type = utilities.get_userdata_type

local SOUND_TYPE = table.enum(
	"2d_sound",
	"3d_sound",
	"start_stop_event",
	"external_sound",
	"source_sound",
	"unit_sound",
	"unknown_userdata_sound"
)

local sound_type_map = {
	["nil"] = SOUND_TYPE["2d_sound"],
	["boolean"] = SOUND_TYPE["start_stop_event"],
	["number"] = SOUND_TYPE["source_sound"],
	["Vector3"] = SOUND_TYPE["3d_sound"],
	["Unit"] = SOUND_TYPE["unit_sound"],
}

local log_silenced = Audio:get("log_silenced", false)
local log_to_chat = Audio:get("log_to_chat", false)
local log_wwise = Audio:get("log_wwise")
local log_wwise_ui = Audio:get("log_wwise_ui")
local log_wwise_common = Audio:get("log_wwise_common")
local log_wwise_verbose = Audio:get("log_wwise_verbose")

local hooks = {}
local silenced = {}

-- local success, event_names = Tools.load_table({
-- 	file_name = "wwise_event_names",
-- })

-- Audio.check_collected = function(event_name)
-- 	return table.contains(event_names, event_name)
-- end

-- Audio.collect_if_new = function(data)

-- 	if not Audio.check_collected(data.event_name) then
-- 		-- event_names[#event_names] = {
-- 		-- 	event_name = event_name,
-- 		-- 	time = os.time(),
-- 		-- }
-- 		event_names[#event_names] = data
-- 	end
-- end

-- Audio.save_collected = function()
-- 	Tools.save_table(event_names, {
-- 		file_name = "wwise_event_names",
-- 	})
-- end

Audio.silence_sounds = function(patterns)
	if type(patterns) == "string" then
		silenced[patterns] = true

		return
	end
	for _, sound_name in ipairs(patterns) do
		silenced[sound_name] = true
	end
end

Audio.unsilence_sounds = function(patterns)
	if type(patterns) == "string" and silenced[patterns] then
		silenced[patterns] = nil

		return
	end
	for _, sound_name in ipairs(patterns) do
		if silenced[sound_name] then
			silenced[sound_name] = nil
		end
	end
end

Audio.is_sound_silenced = function(sound_name)
	for pattern in pairs(silenced) do
		if sound_name:match(pattern) then
			return true
		end
	end

	return false
end

Audio.hook_sound = function(pattern, callback)
	if not hooks[pattern] then
		hooks[pattern] = {}

		setmetatable(hooks[pattern], {})
	end

	hooks[pattern][DLS.function_caller_mod_name()] = callback
end

local run_hooks = function(sound_type, sound_name, position_or_unit_or_id, optional_a, optional_b)
	for pattern, pattern_data in pairs(hooks) do
		local pattern_meta = getmetatable(hooks[pattern])

		if sound_name:match(pattern) then
			for _, fun in pairs(pattern_data) do
				local delta = pattern_meta._last_run and (Managers.time:time("main") - pattern_meta._last_run) or nil

				setmetatable(hooks[pattern], {
					_last_run = Managers.time:time("main"),
				})

				return fun(sound_type, sound_name, delta, position_or_unit_or_id, optional_a, optional_b)
			end
		end
	end
end

Audio.mods_loaded_functions["wwise_hooks"] = function()
	Audio:hook(
		CLASS.WwiseWorld,
		"trigger_resource_event",
		function(fun, wwise_world, wwise_event_name, position_or_unit_or_id, optional_a, optional_b)
			local is_ui_sound = wwise_event_name:find("events/ui/") ~= nil
			local is_common_sound = false

			local common_sounds = { "husk", "foley", "footstep", "locomotion", "material", "upper_body", "vce" }

			for _, sound in ipairs(common_sounds) do
				if wwise_event_name:find(sound) ~= nil then
					is_common_sound = true
					break
				end
			end

			local var_type = get_userdata_type(position_or_unit_or_id) or type(position_or_unit_or_id)
			local sound_type = sound_type_map[var_type] or var_type

			local hook_result = run_hooks(sound_type, wwise_event_name, position_or_unit_or_id, optional_a, optional_b)
			if hook_result == false then
				return
			end

			local sound_is_silenced = Audio.is_sound_silenced(wwise_event_name)

			if log_silenced and sound_is_silenced then
				return
			end

			if
				log_wwise
				and not (is_ui_sound and not log_wwise_ui)
				and not (is_common_sound and not log_wwise_common)
			then
				if log_wwise_verbose then
					Audio:dump({
						sound_type = sound_type,
						wwise_event_name = wwise_event_name,
						position_or_unit_or_id = position_or_unit_or_id,
						optional_a = optional_a,
						optional_b = optional_b,
					})
				else
					if log_to_chat then
						Audio:echo(wwise_event_name)
					else
						print(wwise_event_name, sound_type)
					end
				end
			end

			if sound_is_silenced then
				return
			end

			if sound_type == SOUND_TYPE["2d_sound"] then
				return fun(wwise_world, wwise_event_name)
			elseif sound_type == SOUND_TYPE["3d_sound"] then
				return fun(wwise_world, wwise_event_name, position_or_unit_or_id)
			elseif sound_type == SOUND_TYPE["start_stop_event"] then
				return fun(wwise_world, wwise_event_name, position_or_unit_or_id, optional_a, optional_b)
			elseif sound_type == SOUND_TYPE["source_sound"] then
				return fun(wwise_world, wwise_event_name, position_or_unit_or_id)
			elseif sound_type == SOUND_TYPE["unit_sound"] then
				-- local breed_data = Unit.get_data(position_or_unit_or_id, "breed")

				return fun(wwise_world, wwise_event_name, position_or_unit_or_id, optional_a)
			end
		end
	)

	Audio:hook(
		DialogueSystemWwise,
		"trigger_vorbis_external_event",
		function(fun, self, sound_event, sound_source, file_path, wwise_source_id)
		local sound_type = SOUND_TYPE.external_sound
		local sound_name = file_path:gsub("wwise/externals/", "")

		local hook_result = run_hooks(sound_type, sound_name, wwise_source_id, sound_event, sound_source)
		if hook_result == false then
			return
		end

		local sound_is_silenced = Audio.is_sound_silenced(file_path)

		if log_silenced and sound_is_silenced then
			return
		end

		if log_wwise then
			if log_wwise_verbose then
				Audio:dump({
					sound_type = sound_type,
					sound_event = sound_event,
					sound_source = sound_source,
					file_path = file_path,
					wwise_source_id = wwise_source_id,
				})
			else
				if log_to_chat then
					Audio:echo(file_path)
				else
					print(file_path, SOUND_TYPE.external_sound)
				end
			end
		end

			if sound_is_silenced then
				return
			end

			return fun(self, sound_event, sound_source, file_path, wwise_source_id)
		end
	)
end

Audio.settings_changed_functions["wwise_hooks"] = function(setting_name)
	if setting_name == "log_wwise" then
		log_wwise = Audio:get("log_wwise")
	end

	if setting_name == "log_wwise_ui" then
		log_wwise_ui = Audio:get("log_wwise_ui")
	end

	if setting_name == "log_wwise_common" then
		log_wwise_common = Audio:get("log_wwise_common")
	end

	if setting_name == "log_wwise_verbose" then
		log_wwise_verbose = Audio:get("log_wwise_verbose")
	end

	if setting_name == "log_to_chat" then
		log_to_chat = Audio:get("log_to_chat")
	end
end

-- Audio:command("check_event_names", "Print recently collected Wwise event names", function(range)
-- 	range = tonumber(range) or 5

-- 	for i = math.max(1, #event_names - range), #event_names do
-- 		print(event_names[i])
-- 	end
-- end)
