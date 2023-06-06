return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`WillOfTheEmperor` encountered an error loading the Darktide Mod Framework.")

		new_mod("WillOfTheEmperor", {
			mod_script       = "WillOfTheEmperor/scripts/mods/WillOfTheEmperor/WillOfTheEmperor",
			mod_data         = "WillOfTheEmperor/scripts/mods/WillOfTheEmperor/WillOfTheEmperor_data",
			mod_localization = "WillOfTheEmperor/scripts/mods/WillOfTheEmperor/WillOfTheEmperor_localization",
		})
	end,
	packages = {},
}
