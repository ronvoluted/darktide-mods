local DLS = get_mod("DarktideLocalServer")

---Determine the mod that is calling the current scope
---@return string mod_name Unlocalised name of the mod
---@return boolean uses_audio_library Whether Audio is called in stack
DLS.function_caller_mod_name = function()
	local highest_mod_in_stack
	local highest_non_library_mod_in_stack
	local uses_audio_library = false

	for i = 2, 32 do
		local info = debug.getinfo(i, "S")

		if info then
			local calling_mod_name = info.source:match("./../mods/([^/]+)/scripts/")

			if not calling_mod_name and i > 2 then
				break
			end

			if calling_mod_name == "Tests" then
				highest_mod_in_stack = "Tests"
				break
			end

			if calling_mod_name == "Audio" then
				uses_audio_library = true
			end

			if calling_mod_name and calling_mod_name ~= "dmf" then
				highest_mod_in_stack = calling_mod_name
				if calling_mod_name ~= "DarktideLocalServer" and calling_mod_name ~= "Audio" then
					highest_non_library_mod_in_stack = calling_mod_name
				end
			end
		end
	end

	return highest_non_library_mod_in_stack or highest_mod_in_stack, uses_audio_library
end
