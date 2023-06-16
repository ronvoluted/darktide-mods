local mod = get_mod("Jukebox")

mod:hook_require("scripts/settings/input/default_view_input_settings", function(default_view_input_settings)
	default_view_input_settings.aliases.jukebox_play_stop = {
		"jukebox_play_stop",
		description = "loc_jukebox_play_stop",
		bindable = false,
	}

	default_view_input_settings.settings.jukebox_play_stop = {
		key_alias = "jukebox_play_stop",
		type = "pressed",
	}

	default_view_input_settings.aliases.jukebox_play = {
		"jukebox_play",
		description = "loc_jukebox_play",
		bindable = false,
	}

	default_view_input_settings.settings.jukebox_play = {
		key_alias = "jukebox_play",
		type = "pressed",
	}

	default_view_input_settings.aliases.jukebox_stop = {
		"jukebox_stop",
		description = "loc_jukebox_stop",
		bindable = false,
	}

	default_view_input_settings.settings.jukebox_stop = {
		key_alias = "jukebox_stop",
		type = "pressed",
	}

	default_view_input_settings.aliases.jukebox_previous = {
		"jukebox_previous",
		description = "loc_jukebox_previous",
		bindable = false,
	}

	default_view_input_settings.settings.jukebox_previous = {
		key_alias = "jukebox_previous",
		type = "pressed",
	}

	default_view_input_settings.aliases.jukebox_next = {
		"jukebox_next",
		description = "loc_jukebox_next",
		bindable = false,
	}

	default_view_input_settings.settings.jukebox_next = {
		key_alias = "jukebox_next",
		type = "pressed",
	}
end)
