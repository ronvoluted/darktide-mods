local Audio = get_mod("Audio")

--[[
    Provide further distinction between userdata types.

		@param {userdata} userdata - A userdata value
    @returns {string|nil} "Unit", "Vector3" accordingly, or nil if the `userdata` is not of userdata type.
--]]
Audio.userdata_type = function(userdata)
	if type(userdata) ~= "userdata" then
		return nil
	end

	if Unit.alive(userdata) then
		return "Unit"
	elseif Vector3.is_valid(userdata) then
		return "Vector3"
	else
		return tostring(userdata)
	end
end

--[[
    Find the mod that is calling the current scope.

    @returns {string} Non-localised name of the mod.
--]]
Audio.function_caller_mod_name = function()
	local highest_mod_in_stack
	local highest_non_Audio_mod_in_stack

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

			if calling_mod_name and calling_mod_name ~= "dmf" then
				highest_mod_in_stack = calling_mod_name
				if calling_mod_name ~= "Audio" then
					highest_non_Audio_mod_in_stack = calling_mod_name
				end
			end
		end
	end

	return highest_non_Audio_mod_in_stack or highest_mod_in_stack
end
