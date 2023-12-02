return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`CThruShields` encountered an error loading the Darktide Mod Framework.")

		new_mod("CThruShields", {
			mod_script       = "CThruShields/scripts/mods/CThruShields/CThruShields",
			mod_data         = "CThruShields/scripts/mods/CThruShields/CThruShields_data",
			mod_localization = "CThruShields/scripts/mods/CThruShields/CThruShields_localization",
		})
	end,
	packages = {},
}
