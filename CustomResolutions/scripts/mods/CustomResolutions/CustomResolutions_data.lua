local mod = get_mod("CustomResolutions")

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				title = "append_position",
				tooltip = "append_position_tooltip",
				setting_id = "append_position",
				type = "dropdown",
				default_value = "end",
				options = {
					{ text = "append_position_start", value = "start" },
					{ text = "append_position_end", value = "end" },
				},
			},
		},
	},
}
