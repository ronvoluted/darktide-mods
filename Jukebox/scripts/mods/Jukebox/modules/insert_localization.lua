local mod = get_mod("Jukebox")

local mod_localization = mod:io_dofile("Jukebox/scripts/mods/Jukebox/Jukebox_localization")
local music_tracks = mod:io_dofile("Jukebox/scripts/mods/Jukebox/modules/music_tracks")

local localizations_to_add = {
	loc_jukebox_name = mod_localization.mod_name,
	loc_jukebox_high_gothic_name = mod_localization.high_gothic_name,
	loc_jukebox_insert_credit = mod_localization.insert_credit,
	loc_jukebox_tracks = mod_localization.tracks,
	loc_jukebox_options = mod_localization.options,
	loc_jukebox_autoplay = mod_localization.autoplay,
	loc_jukebox_shuffle = mod_localization.shuffle,
	loc_jukebox_show_track_changes = mod_localization.show_track_changes,
	loc_jukebox_play_stop = mod_localization.play_stop,
	loc_jukebox_play = mod_localization.play,
	loc_jukebox_stop = mod_localization.stop,
	loc_jukebox_previous = mod_localization.previous,
	loc_jukebox_next = mod_localization.next,
}

for i, track in pairs(music_tracks) do
	localizations_to_add["loc_jukebox_track_" .. i] = {
		en = track.name,
	}
end

mod:add_global_localize_strings(localizations_to_add)
