return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`ScrubsVermin` encountered an error loading the Darktide Mod Framework.")

		new_mod("ScrubsVermin", {
			mod_script       = "ScrubsVermin/scripts/mods/ScrubsVermin/ScrubsVermin",
			mod_data         = "ScrubsVermin/scripts/mods/ScrubsVermin/ScrubsVermin_data",
			mod_localization = "ScrubsVermin/scripts/mods/ScrubsVermin/ScrubsVermin_localization",
		})
	end,
	packages = {},
}
