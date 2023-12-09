return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`JukeboxOld` encountered an error loading the Darktide Mod Framework.")

		new_mod("JukeboxOld", {
			mod_script       = "JukeboxOld/scripts/mods/JukeboxOld/JukeboxOld",
			mod_data         = "JukeboxOld/scripts/mods/JukeboxOld/JukeboxOld_data",
			mod_localization = "JukeboxOld/scripts/mods/JukeboxOld/Jukebox_localization",
		})
	end,
	packages = {},
}
