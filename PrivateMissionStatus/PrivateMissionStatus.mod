return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`PrivateMissionStatus` encountered an error loading the Darktide Mod Framework.")

		new_mod("PrivateMissionStatus", {
			mod_script       = "PrivateMissionStatus/scripts/mods/PrivateMissionStatus/PrivateMissionStatus",
			mod_data         = "PrivateMissionStatus/scripts/mods/PrivateMissionStatus/PrivateMissionStatus_data",
			mod_localization = "PrivateMissionStatus/scripts/mods/PrivateMissionStatus/PrivateMissionStatus_localization",
		})
	end,
	packages = {},
}
