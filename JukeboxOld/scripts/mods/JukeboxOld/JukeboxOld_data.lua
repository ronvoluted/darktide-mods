local mod = get_mod("JukeboxOld")

if not mod:get("music_tracks_version") then
	mod:set("music_tracks_version", 1)
end

mod.disabled_tracks = mod:get("disabled_tracks")

if not mod.disabled_tracks then
	mod.disabled_tracks = {}
	mod:set("disabled_tracks", mod.disabled_tracks)
end

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id = "play_on_start",
				tooltip = "play_on_start_desc",
				type = "dropdown",
				default_value = "mourningstar",
				options = {
					{ text = "play_on_start_none", value = "none" },
					{ text = "play_on_start_title", value = "title" },
					{ text = "play_on_start_character_select", value = "character_select" },
					{ text = "play_on_mourningstar", value = "mourningstar" },
				},
			},
			{
				setting_id = "dance",
				type = "checkbox",
				default_value = true,
				tooltip = "dance_desc",
			},
			{
				setting_id = "disco",
				type = "checkbox",
				default_value = false,
				tooltip = "disco_desc",
			},
			{
				setting_id = "autoplay",
				type = "checkbox",
				default_value = true,
				tooltip = "autoplay_desc",
			},
			{
				setting_id = "shuffle",
				type = "checkbox",
				default_value = true,
				tooltip = "shuffle_desc",
			},
			{
				setting_id = "show_track_changes",
				type = "checkbox",
				default_value = true,
				tooltip = "show_track_changes_desc",
			},
			{
				setting_id = "enable_media_keys",
				type = "checkbox",
				default_value = true,
				tooltip = "enable_media_keys_desc",
			},
		},
	},
}
