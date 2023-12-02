return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`AutoBackup` encountered an error loading the Darktide Mod Framework.")

		new_mod("AutoBackup", {
			mod_script       = "AutoBackup/scripts/mods/AutoBackup/AutoBackup",
			mod_data         = "AutoBackup/scripts/mods/AutoBackup/AutoBackup_data",
			mod_localization = "AutoBackup/scripts/mods/AutoBackup/AutoBackup_localization",
		})
	end,
	packages = {},
}
