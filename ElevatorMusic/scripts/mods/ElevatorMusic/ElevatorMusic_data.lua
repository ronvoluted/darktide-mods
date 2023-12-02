local mod = get_mod("ElevatorMusic")

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id = "muzak_volume",
				type = "numeric",
				tooltip = "muzak_volume",
				default_value = 50,
				range = { 1, 100 },
			},
		},
	},
}
