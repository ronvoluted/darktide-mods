local mod = get_mod("WillOfTheEmperor")

local original_constants = mod:persistent_table("original_constants", {})
local constants = {}

mod.apply_constants = function()
	if mod:get("infinite_slide") then
		constants.sprint_slide_friction_function = function()
			return 0
		end
		constants.slide_friction_function = function()
			return 0
		end
	else
		constants.sprint_slide_friction_function = original_constants.sprint_slide_friction_function
		constants.slide_friction_function = original_constants.slide_friction_function
	end

	if mod:get("infinite_ledge_hold") then
		constants.time_until_fall_down_from_hang_ledge = math.huge
	else
		constants.time_until_fall_down_from_hang_ledge = original_constants.time_until_fall_down_from_hang_ledge
	end

	local move_speed = mod:get("move_speed")
	if move_speed ~= original_constants.move_speed then
		constants.move_speed = move_speed
	end

	local gravity = mod:get("gravity")
	if gravity ~= original_constants.gravity then
		constants.gravity = gravity
	end

	-- local air_move_speed_scale = mod:get("air_move_speed_scale")
	-- if air_move_speed_scale ~= original_constants.air_move_speed_scale then
	-- 	constants.air_move_speed_scale = air_move_speed_scale
	-- 	constants.air_acceleration = 0.5
	-- else
	-- 	constants.air_acceleration = original_constants.air_acceleration
	-- end
end

mod.toggle_gravity = function()
	if mod.last_gravity then
		mod:set("gravity", mod.last_gravity)
		mod._settings.gravity = mod.last_gravity
		constants.gravity = mod.last_gravity

		mod.last_gravity = nil
	else
		if mod:get("gravity") ~= original_constants.gravity then
			mod.last_gravity = mod:get("gravity")
		end

		mod:set("gravity", original_constants.gravity)
		mod._settings.gravity = original_constants.gravity
		constants.gravity = original_constants.gravity
	end

	if mod:get("show_toggles") then
		mod:notify(
			string.format(
				"%s %s",
				mod:get("gravity") ~= original_constants.gravity and "Modified" or "Normal",
				mod:localize("gravity")
			)
		)
	end
end

mod:hook_require("scripts/settings/player_character/player_character_constants", function(_constants)
	original_constants = table.clone(_constants)
	table.set_readonly(original_constants)

	constants = _constants
end)
