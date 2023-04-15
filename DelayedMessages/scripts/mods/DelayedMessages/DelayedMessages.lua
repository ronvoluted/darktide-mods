-- FILE: ./scripts/mods/delayed_message/delayed_message.lua

local mod = get_mod("DelayedMessage")
local DESCRIPTION = "<seconds> <message> (Send mod message after a delay)"
local delayedMessages = {}

mod:command("delayed", DESCRIPTION, function(delay, ...)
	delay = tonumber(delay)

	if delay == nil then
		mod:error("No delay provided.")
		return
	end

	local message = table.concat({ ... }, " ")

	if message == "" then
		mod:error("No phrase provided.")
		return
	end

	table.insert(delayedMessages, {
		message = message,
		time = os.clock() + delay,
	})
end)

function mod.update()
	if #delayedMessages == 0 then
		return
	end

	for i, delayed in pairs(delayedMessages) do
		if os.clock() >= delayed.time then
			mod:echo(delayed.message)

			table.remove(delayedMessages, i)
		end
	end
end
