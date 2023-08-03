local mod = get_mod("Audio")
local DMF = get_mod("DMF")

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

mod.io = DMF:persistent_table("io")
mod.io.initialized = mod.io.initialized or false
if not mod.io.initialized then
	mod.io = DMF.deepcopy(Mods.lua.io)
end

mod:io_dofile("Audio/scripts/mods/Audio/modules/path_utilities")
mod:io_dofile("Audio/scripts/mods/Audio/modules/wwise_playback")

local FFPLAY_PATH = mod.mod_path("bin\\ffplay", true)
local AUDIO_TYPE = table.enum("dialogue", "music", "sfx")

local player_unit
local first_person_component

local use_player_unit = function()
	if not Unit.alive(player_unit) then
		player_unit = Managers.player:local_player_safe(1).player_unit
	end
end

local use_first_person_component = function()
	if not first_person_component then
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		first_person_component = unit_data_extension:read_component("first_person")
	end
end

local calculate_distance_filter = function(
	source_position,
	decay,
	min_distance,
	max_distance,
	override_position,
	override_rotation
)
	if not source_position or not override_position or not override_rotation then
		use_player_unit()
	end

	if not override_rotation then
		use_first_person_component()
	end

	source_position = source_position or Unit.local_position(player_unit, 1) or Vector3.zero()
	local listener_position = override_position or Unit.local_position(player_unit, 1) or Vector3.zero()
	local listener_rotation = override_rotation or first_person_component.rotation or Quaternion.identity()

	decay = decay or 0
	min_distance = min_distance or 0
	max_distance = max_distance or 100

	local distance = Vector3.distance(source_position, listener_position)
	local volume

	if distance < min_distance then
		volume = 100
	elseif distance > max_distance then
		volume = 0
	else
		local ratio = 1 - math.clamp((distance - min_distance) / (max_distance - min_distance), 0, 1)

		volume = math.clamp(100 * (ratio - (distance - min_distance) * decay), 0, 100)
	end

	local direction = source_position - listener_position
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

local play_coroutine = function()
	return coroutine.create(function(command)
		while true do
			mod.io.popen(command):close()
			coroutine.yield()
		end
	end)
end

mod.play = function(
	path,
	source_position,
	decay,
	min_distance,
	max_distance,
	audio_type,
	override_position,
	override_rotation
)
	local volume, left_volume, right_volume = calculate_distance_filter(
		source_position,
		decay,
		min_distance,
		max_distance,
		override_position,
		override_rotation
	)

	local command = string.format(
		'start /b "" %s -i "%s" -fast -nodisp -autoexit -loglevel quiet -volume %s -af "pan=stereo|c0=%s*c0|c1=%s*c1" &',
		FFPLAY_PATH,
		mod.absolute_path(path),
		math.round(volume),
		left_volume,
		right_volume
	)

	coroutine.resume(play_coroutine(), command)

	return command
end

-- mod.on_all_mods_loaded = function()
-- 	get_mod("Tests").run(mod, { quiet = true })
-- end

-- mod.on_unload = function()
-- 	mod.save_collected()
-- end
