local Audio = get_mod("Audio")
local utilities = Audio:io_dofile("Audio/scripts/mods/Audio/modules/utilities")
local get_delay_seconds = utilities.get_delay_seconds
local get_userdata_type = utilities.get_userdata_type

local get_delay = {
	description = "extract mininum delay from `adelay`",
	fun = function()
		assert(get_delay_seconds() == 0)
		assert(get_delay_seconds("emperor:all=1") == 0)
		assert(get_delay_seconds("500|780") == 0.5)
		assert(get_delay_seconds("5s|2.3s:all=1") == 2.3)
		assert(get_delay_seconds("96000S|888888S:all=1") == 2)
		assert(get_delay_seconds("6784|12s|480000S|9000:all=1") == 6.784)
	end,
}

local userdata_vector3 = {
	description = "returns userdata type for Vector3",
	fun = function()
		return get_userdata_type(Vector3.one())
	end,
	expected = "Vector3",
}

local userdata_unit = {
	description = "returns userdata type for Unit",
	fun = function()
		local player_unit = Managers.player:local_player_safe(1).player_unit
		return get_userdata_type(player_unit)
	end,
	expected = "Unit",
}

Audio._tests.suites["utilities"] = {
	description = "Utilities",
	tests = {
		get_delay,
		userdata_vector3,
		userdata_unit,
	},
}
