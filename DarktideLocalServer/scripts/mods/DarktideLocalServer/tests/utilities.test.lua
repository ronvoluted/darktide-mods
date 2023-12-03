local DLS = get_mod("DarktideLocalServer")

local caller_mod = {
	description = "returns the name of the current mod",
	fun = function()
		return DLS.function_caller_mod_name()
	end,
	expected = "Tests",
}

DLS._tests.suites["utilities"] = {
	description = "Utilities",
	tests = {
		caller_mod,
	},
}
