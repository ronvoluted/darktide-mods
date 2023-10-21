---Extract the minimum delay from an FFplay `adelay` string
---@param adelay_string string The `adelay` value used in `playback_settings`
---@return number minDelay The shortest delay in seconds, or 0 if there are none
local get_delay_seconds = function(adelay_string)
	local withoutColon = string.match(adelay_string, "([^:]+)")
	local minDelay = 0
	local delays = {}

	if not withoutColon then
		return minDelay
	end

	for delay in string.gmatch(withoutColon, "([^|]+)") do
		table.insert(delays, delay)
	end

	for _, delay in pairs(delays) do
		local number, suffix = string.match(delay, "([%d%.]+)([sS]?)")
		if number then
			number = tonumber(number)

			if type(number) == "number" then
				local delaySeconds

				if suffix == "S" then
					delaySeconds = number / 48000 -- I am okay with this
				elseif suffix == "s" then
					delaySeconds = number
				else
					delaySeconds = number / 1000
				end

				if minDelay == 0 or delaySeconds < minDelay then
					minDelay = delaySeconds
				end
			end
		end
	end

	return minDelay
end

---Determine the mod that is calling the current scope
---@return string mod_name Unlocalised name of the mod
local function_caller_mod_name = function()
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

---Distinguish if userdata is a position or unit
---@param userdata userdata A userdata value
---@return "Unit"|"Vector3"|nil type Type of the userdata
local get_userdata_type = function(userdata)
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

return {
	get_delay_seconds = get_delay_seconds,
	function_caller_mod_name = function_caller_mod_name,
	get_userdata_type = get_userdata_type,
}
