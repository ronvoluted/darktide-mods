local Audio = get_mod("Audio")

local userdata_vector3 = {
	description = "returns userdata type for Vector3",
	fun = function()
		return Audio.userdata_type(Vector3.one())
	end,
	expected = "Vector3",
}

local userdata_unit = {
	description = "returns userdata type for Unit",
	fun = function()
		local player_unit = Managers.player:local_player_safe(1).player_unit
		return Audio.userdata_type(player_unit)
	end,
	expected = "Unit",
}

local caller_mod = {
	description = "returns the name of the current mod",
	fun = function()
		return Audio.function_caller_mod_name()
	end,
	expected = "Tests",
}

Audio._tests.suites["utilities"] = {
	description = "Utilities",
	tests = {
		userdata_vector3,
		userdata_unit,
		caller_mod,
	},
}
