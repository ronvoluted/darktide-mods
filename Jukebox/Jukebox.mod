return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`Jukebox` encountered an error loading the Darktide Mod Framework.")

		new_mod("Jukebox", {
			mod_script       = "Jukebox/scripts/mods/Jukebox/Jukebox",
			mod_data         = "Jukebox/scripts/mods/Jukebox/Jukebox_data",
			mod_localization = "Jukebox/scripts/mods/Jukebox/Jukebox_localization",
		})
	end,
	packages = {},
}
