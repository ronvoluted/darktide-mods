---Extract the minimum delay from an FFplay `adelay` string
---@param adelay_string string The `adelay` value used in `playback_settings`
---@return number minDelay The shortest delay in seconds, or 0 if there are none
local get_delay_seconds = function(adelay_string)
	if not adelay_string then
		return 0
	end

	local withoutColon = string.match(adelay_string, "([^:]+)")
	local minDelay = 0
	local delays = {}

	if not withoutColon then
		return 0
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
	get_userdata_type = get_userdata_type,
}
