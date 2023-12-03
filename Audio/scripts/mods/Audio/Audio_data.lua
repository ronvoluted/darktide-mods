local mod = get_mod("Audio")

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = false,
	options = {
		widgets = {
			{
				setting_id = "log_wwise",
				type = "checkbox",
				tooltip = "log_wwise_tooltip",
				default_value = false,
			},
			{
				setting_id = "log_wwise_ui",
				type = "checkbox",
				tooltip = "log_wwise_ui_tooltip",
				default_value = false,
			},
			{
				setting_id = "log_wwise_common",
				type = "checkbox",
				tooltip = "log_wwise_common_tooltip",
				default_value = false,
			},
			{
				setting_id = "log_silenced",
				type = "checkbox",
				tooltip = "log_silenced_tooltip",
				default_value = true,
			},
			{
				setting_id = "log_wwise_verbose",
				type = "checkbox",
				tooltip = "log_wwise_verbose_tooltip",
				default_value = false,
			},
			{
				setting_id = "log_errors",
				type = "checkbox",
				tooltip = "log_errors_tooltip",
				default_value = false,
			},
			{
				setting_id = "log_server_commands",
				type = "checkbox",
				tooltip = "log_server_commands_tooltip",
				default_value = false,
			},
			{
				setting_id = "log_to_chat",
				type = "checkbox",
				tooltip = "log_to_chat_tooltip",
				default_value = false,
			},
		},
	},
}
