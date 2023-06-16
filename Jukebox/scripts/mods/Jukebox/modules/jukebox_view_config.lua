local mod = get_mod("Jukebox")

local music_tracks = mod:io_dofile("Jukebox/scripts/mods/Jukebox/modules/music_tracks")

local config = {
	{
		display_name = "loc_jukebox_tracks",
		widget_type = "jukebox_subheading",
	},
}

for i in ipairs(music_tracks) do
	if not music_tracks[i].disabled then
		config[#config + 1] = {
			display_name = "loc_jukebox_track_" .. i,
			disabled = true,
			disable = true,
			widget_type = "jukebox_track",
			value_type = "boolean",
			default_value = false,
			value_get_function = function()
				return mod.track_disabled(i)
			end,
			on_value_changed_function = function(value)
				if value == true then
					mod.disable_track(i)
				else
					mod.enable_track(i)
				end
			end,
		}
	end
end

table.append(config, {
	{
		display_name = "loc_jukebox_options",
		widget_type = "jukebox_subheading",
	},
	{
		display_name = "loc_jukebox_autoplay",
		widget_type = "jukebox_toggle",
		value_type = "boolean",
		default_value = mod:get("autoplay"),
		value_get_function = function()
			return mod:get("autoplay")
		end,
		on_value_changed_function = function(value)
			mod:set("autoplay", value)
			mod._settings.autoplay = value
		end,
	},
	{
		display_name = "loc_jukebox_shuffle",
		widget_type = "jukebox_toggle",
		value_type = "boolean",
		default_value = mod:get("shuffle"),
		value_get_function = function()
			return mod:get("shuffle")
		end,
		on_value_changed_function = function(value)
			mod:set("shuffle", value)
			mod._settings.shuffle = value
			print(mod._settings.shuffle)
		end,
	},
	{
		display_name = "loc_jukebox_show_track_changes",
		widget_type = "jukebox_toggle",
		value_type = "boolean",
		default_value = mod:get("show_track_changes"),
		value_get_function = function()
			return mod:get("show_track_changes")
		end,
		on_value_changed_function = function(value)
			mod:set("show_track_changes", value)
			mod._settings.show_track_changes = value
		end,
	},
})

return config
