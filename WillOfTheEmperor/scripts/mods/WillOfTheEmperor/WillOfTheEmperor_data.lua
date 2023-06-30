local mod = get_mod("WillOfTheEmperor")

mod._settings = {}

local BESTOWMENT_TOGGLES = {
	"god_emperor_mode",
	"fervency_mode",
	"disable_enemy_spawns",
	"invisibility",
	"rapid_ability_cooldowns",
	"infinite_warp",
	"infinite_slide",
	"infinite_ledge_hold",
	"infinite_ammunition",
	"no_reloading",
}

local BESTOWMENT_TRUE_BY_DEFAULT = {
	"infinite_ledge_hold",
}

local BESTOWMENT_KEYBINDS = {
	"god_emperor_mode",
	"fervency_mode",
	"disable_enemy_spawns",
	"invisibility",
}

local data = {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {},
	},
}

for _, setting_id in ipairs(BESTOWMENT_TOGGLES) do
	table.insert(data.options.widgets, {
		setting_id = setting_id,
		type = "checkbox",
		default_value = table.contains(BESTOWMENT_TRUE_BY_DEFAULT, setting_id) or false,
		title = setting_id,
		tooltip = setting_id .. "_desc",
	})
end

table.append(data.options.widgets, {
	{
		setting_id = "rounds_in_chamber",
		type = "dropdown",
		default_value = 0,
		title = "rounds_in_chamber",
		tooltip = "rounds_in_chamber_desc",
		options = {
			{ text = "rounds_minus_0", value = 0 },
			{ text = "rounds_minus_1", value = -1 },
			{ text = "rounds_minus_2", value = -2 },
			{ text = "rounds_minus_3", value = -3 },
			{ text = "rounds_minus_4", value = -4 },
			{ text = "rounds_5", value = 5 },
			{ text = "rounds_4", value = 4 },
			{ text = "rounds_3", value = 3 },
			{ text = "rounds_2", value = 2 },
			{ text = "rounds_1", value = 1 },
		},
	},
	-- {
	-- 	setting_id = "infinite_coherency",
	-- 	type = "checkbox",
	-- 	default_value = true,
	-- 	title = "infinite_coherency",
	-- 	tooltip = "infinite_coherency_desc",
	-- },
	-- {
	-- 	setting_id = "no_fall_damage",
	-- 	type = "checkbox",
	-- 	default_value = true,
	-- 	title = "no_fall_damage",
	-- 	tooltip = "no_fall_damage_desc",
	-- },
	{
		setting_id = "move_speed",
		type = "numeric",
		default_value = 4,
		range = { 0, 50 },
		title = "move_speed",
		tooltip = "move_speed_desc",
	},
	-- {
	-- 	setting_id = "attack_speed",
	-- 	type = "numeric",
	-- 	default_value = 4,
	-- 	range = { 0, 50 },
	-- 	title = "attack_speed",
	-- 	tooltip = "attack_speed_desc",
	-- },
	{
		setting_id = "gravity",
		type = "numeric",
		default_value = 11.82,
		range = { 0, 50 },
		decimals_number = 1,
		title = "gravity",
		tooltip = "gravity_desc",
	},
	-- {
	-- 	setting_id = "air_move_speed_scale",
	-- 	type = "numeric",
	-- 	default_value = 0.75,
	-- 	range = { 0, 100 },
	-- 	decimals_number = 2,
	-- 	title = "air_move_speed_scale",
	-- 	tooltip = "air_move_speed_scale_desc",
	-- },
	{
		setting_id = "reset_sliders_on_reload",
		type = "checkbox",
		default_value = true,
		title = "reset_sliders_on_reload",
		tooltip = "reset_sliders_on_reload_desc",
	},
	{
		setting_id = "keybind_pause",
		type = "keybind",
		title = "toggle_pause_time",
		tooltip = "toggle_pause_time_desc",
		keybind_trigger = "pressed",
		keybind_type = "function_call",
		function_name = "toggle_pause_time",
		default_value = {},
	},
	{
		setting_id = "keybind_slow_mo",
		type = "keybind",
		title = "slow_mo",
		tooltip = "slow_mo_desc",
		keybind_trigger = "pressed",
		keybind_type = "function_call",
		function_name = "toggle_slow_mo",
		default_value = {},
	},
	{
		setting_id = "keybind_reset_time_scale",
		type = "keybind",
		title = "reset_time",
		tooltip = "reset_time_desc",
		keybind_trigger = "pressed",
		keybind_type = "function_call",
		function_name = "reset_time",
		default_value = {},
	},
	{
		setting_id = "keybind_explode_enemies",
		type = "keybind",
		title = "explode_enemies",
		tooltip = "explode_enemies_desc",
		keybind_trigger = "pressed",
		keybind_type = "function_call",
		function_name = "explode_enemies",
		default_value = {},
	},
})

for _, setting_id in ipairs(BESTOWMENT_TOGGLES) do
	if table.contains(BESTOWMENT_KEYBINDS, setting_id) then
		table.insert(data.options.widgets, {
			setting_id = "toggle_" .. setting_id,
			type = "keybind",
			title = "toggle_" .. setting_id,
			keybind_trigger = "pressed",
			keybind_type = "function_call",
			function_name = "toggle_" .. setting_id,
			default_value = {},
		})
	end
end

table.insert(data.options.widgets, {
	setting_id = "keybind_toggle_gravity",
	type = "keybind",
	title = "toggle_gravity",
	tooltip = "toggle_gravity_desc",
	keybind_trigger = "pressed",
	keybind_type = "function_call",
	function_name = "toggle_gravity",
	default_value = {},
})

table.insert(data.options.widgets, {
	setting_id = "show_toggles",
	type = "checkbox",
	default_value = true,
	title = "show_toggles",
	tooltip = "show_toggles_desc",
})

for _, widget in pairs(data.options.widgets) do
	mod._settings[widget.setting_id] = mod:get(widget.setting_id)
end

return data
