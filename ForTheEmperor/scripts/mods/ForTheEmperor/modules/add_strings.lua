local mod = get_mod("ForTheEmperor")

local ForTheEmperor_localization = mod:io_dofile("ForTheEmperor/scripts/mods/ForTheEmperor/ForTheEmperor_localization")

local strings_to_add = {
	loc_for_the_emperor = ForTheEmperor_localization.mod_title,
	loc_communication_wheel_need_help = ForTheEmperor_localization.need_help_comms_wheel,
}

local need_ammo_strings = string.split(Localize("loc_communication_wheel_need_ammo"), " ")

for i, str in ipairs(need_ammo_strings) do
	if i ~= 2 then
		need_ammo_strings[i] = string.lower(str)
	end
end

strings_to_add.loc_communication_wheel_need_ammo = {
	en = table.concat(need_ammo_strings, " "),
}

mod:add_global_localize_strings(strings_to_add)
