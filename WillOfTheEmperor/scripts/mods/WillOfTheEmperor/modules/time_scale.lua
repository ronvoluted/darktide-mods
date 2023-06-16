local mod = get_mod("WillOfTheEmperor")

local set_time_scale = function(scale)
	Managers.time:set_local_scale("gameplay", scale or 1)
end

mod.toggle_pause_time = function()
	if Managers.time:local_scale("gameplay") == 0 then
		set_time_scale(mod.former_time_scale)
	else
		mod.former_time_scale = Managers.time:local_scale("gameplay")
		set_time_scale(0)
	end
end

mod.toggle_slow_mo = function()
	if Managers.time:local_scale("gameplay") == 0.25 then
		set_time_scale(1)
	else
		set_time_scale(0.25)
	end
end

mod.reset_time = function()
	set_time_scale(1)
end

mod:command("time", "Set time speed", function(scale)
	if type(tonumber(scale)) == "number" then
		set_time_scale(scale)
	end
end)
