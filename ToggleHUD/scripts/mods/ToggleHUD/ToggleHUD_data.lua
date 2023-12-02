local mod = get_mod("ToggleHUD")

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id = "keybind_toggle",
				type = "keybind",
				title = "keybind_toggle",
				keybind_trigger = "held",
				keybind_type = "function_call",
				function_name = "handle_keybind_toggle",
				default_value = {},
			},
			{
				setting_id = "toggle_on_hold",
				type = "checkbox",
				title = "toggle_on_hold",
				default_value = false,
			},
			{
				setting_id = "enable_command",
				type = "checkbox",
				title = "enable_command",
				tooltip = "enable_command_tooltip",
				default_value = true,
			},
		},
	},
}
