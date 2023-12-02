return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`DarktideLocalServer` encountered an error loading the Darktide Mod Framework.")

		new_mod("DarktideLocalServer", {
			mod_script       = "DarktideLocalServer/scripts/mods/DarktideLocalServer/DarktideLocalServer",
			mod_data         = "DarktideLocalServer/scripts/mods/DarktideLocalServer/DarktideLocalServer_data",
			mod_localization = "DarktideLocalServer/scripts/mods/DarktideLocalServer/DarktideLocalServer_localization",
		})
	end,
	packages = {},
}
