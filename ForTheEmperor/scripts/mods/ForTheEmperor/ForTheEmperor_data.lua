local mod = get_mod("ForTheEmperor")

return {
	name = mod:localize("mod_title"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id = "wheel_position",
				type = "dropdown",
				default_value = "left",
				options = {
					{ text = "wheel_left", value = "left" },
					{ text = "wheel_right", value = "right" },
				},
			},
		},
	},
}
