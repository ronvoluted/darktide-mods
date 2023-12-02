return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`ElevatorMusic` encountered an error loading the Darktide Mod Framework.")

		new_mod("ElevatorMusic", {
			mod_script       = "ElevatorMusic/scripts/mods/ElevatorMusic/ElevatorMusic",
			mod_data         = "ElevatorMusic/scripts/mods/ElevatorMusic/ElevatorMusic_data",
			mod_localization = "ElevatorMusic/scripts/mods/ElevatorMusic/ElevatorMusic_localization",
		})
	end,
	packages = {},
}
