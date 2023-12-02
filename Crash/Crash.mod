return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`Crash` encountered an error loading the Darktide Mod Framework.")

		new_mod("Crash", {
			mod_script       = "Crash/scripts/mods/Crash/Crash",
			mod_data         = "Crash/scripts/mods/Crash/Crash_data",
			mod_localization = "Crash/scripts/mods/Crash/Crash_localization",
		})
	end,
	packages = {},
}
