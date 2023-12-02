local mod = get_mod("PreventPlayerFade")

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

local DEFAULT_MIN_DISTANCE = 0.5
local DEFAULT_MAX_DISTANCE = 0.7
local DEFAULT_MAX_HEIGHT_DIFFERENCE = 1

mod:hook(CLASS.FadeSystem, "on_add_extension", function(fun, self, world, unit, extension_name)
	local player_unit = Managers.player:local_player_safe(1).player_unit
	local min_distance, max_distance, max_height_difference
	local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")

	if unit_data_extension then
		local breed = unit_data_extension:breed()
		local fade = breed.fade

		if fade then
			if breed.behavior_tree_name:match("cultist_mutant") or unit == player_unit then
				min_distance = 0
				max_distance = 0
				max_height_difference = 0
			else
				min_distance = fade.min_distance
				max_distance = fade.max_distance
				max_height_difference = fade.max_height_difference
			end
		end
	end

	min_distance = min_distance or DEFAULT_MIN_DISTANCE
	max_distance = max_distance or DEFAULT_MAX_DISTANCE
	max_height_difference = max_height_difference or DEFAULT_MAX_HEIGHT_DIFFERENCE

	Fade.register_unit(self._fade_system, unit, min_distance, max_distance, max_height_difference)

	local extension = {}

	ScriptUnit.set_extension(unit, self._name, extension)

	self._unit_to_extension_map[unit] = extension

	return extension
end)
