local mod = get_mod("Crash")

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

local delay = nil
local start_time = nil
local crash_time = nil
local last_message_time = nil

local crash = function()
	Application.release_world()
end

mod.update = function (dt)
	if type(crash_time) ~= "number" then
		return
	end

	if os.clock() > crash_time then
		crash()
	end

	if last_message_time == nil and os.clock() - start_time + dt >= 1 + (delay % 1) or
		type(last_message_time) == "number" and os.clock() - last_message_time + dt >= 1 then
		local seconds_remaining = math.floor(crash_time - os.clock())
		if seconds_remaining == 1 then
			mod:echo(mod:localize("message_crashing_in_second", tostring(seconds_remaining)))
		else
			mod:echo(mod:localize("message_crashing_in_seconds", tostring(seconds_remaining)))
		end
		last_message_time = os.clock()
	end
end

mod:command("crash", mod:localize("command_crash_desc"), function(delay_seconds)
	delay = tonumber(delay_seconds)

	if type(delay) == "number" then
		mod:echo(mod:localize("message_crashing_in_seconds", string.format("%g", string.format("%.3f", delay))))
		start_time = os.clock()
		crash_time = os.clock() + delay
	else
		crash()
	end
end)

mod:command("crash_cancel", mod:localize("command_crash_cancel_desc"), function()
	if crash_time ~= nil then
		delay, start_time, crash_time, last_message_time = nil, nil, nil, nil
		mod:echo(mod:localize("message_cancelled"))
	else
		mod:echo(mod:localize("message_not_scheduled"))
	end
end)

mod:command("error", mod:localize("command_error_desc"), function(...)
	local message = table.concat({...}, " ")

	if message == "" then
			error(mod:localize("message_default_error"))
			return
	else
		error(message)
	end
end)

mod:command("exit", mod:localize("command_exit_desc"), function()
	Application.quit()
end)
