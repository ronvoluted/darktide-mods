return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`CustomResolutions` encountered an error loading the Darktide Mod Framework.")

		new_mod("CustomResolutions", {
			mod_script       = "CustomResolutions/scripts/mods/CustomResolutions/CustomResolutions",
			mod_data         = "CustomResolutions/scripts/mods/CustomResolutions/CustomResolutions_data",
			mod_localization = "CustomResolutions/scripts/mods/CustomResolutions/CustomResolutions_localization",
		})
	end,
	packages = {},
}
