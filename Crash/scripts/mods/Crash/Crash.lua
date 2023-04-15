local mod = get_mod("Crash")

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
		mod:echo("Crashing in " .. seconds_remaining .. (seconds_remaining == 1 and " second..." or " seconds..."))
		last_message_time = os.clock()
	end
end

mod:command("crash", "Crash the game immediately, or specify seconds to schedule", function(delay_seconds)
	delay = tonumber(delay_seconds)

	if type(delay) == "number" then
		mod:echo("Crashing in " .. string.format("%g", string.format("%.3f", delay)) .. " seconds...")
		start_time = os.clock()
		crash_time = os.clock() + delay
	else
		crash()
	end
end)

mod:command("crash_cancel", "Cancel a scheduled crash", function()
	if crash_time ~= nil then
		delay, start_time, crash_time, last_message_time = nil, nil, nil, nil
		mod:echo("Crash cancelled")
	else
		mod:echo("No crash scheduled")
	end
end)

mod:command("error", "Create an error from message", function(...)
	local message = table.concat({...}, " ")

	if message == "" then
			error("Error created")
			return
	else
		error(message)
	end
end)

mod:command("exit", "Exit the game immediately", function()
	Application.quit()
end)
