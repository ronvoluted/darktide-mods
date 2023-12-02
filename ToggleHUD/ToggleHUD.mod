return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`ToggleHUD` encountered an error loading the Darktide Mod Framework.")

		new_mod("ToggleHUD", {
			mod_script       = "ToggleHUD/scripts/mods/ToggleHUD/ToggleHUD",
			mod_data         = "ToggleHUD/scripts/mods/ToggleHUD/ToggleHUD_data",
			mod_localization = "ToggleHUD/scripts/mods/ToggleHUD/ToggleHUD_localization",
		})
	end,
	packages = {},
}
