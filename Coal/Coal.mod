return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`Coal` encountered an error loading the Darktide Mod Framework.")

		new_mod("Coal", {
			mod_script       = "Coal/scripts/mods/Coal/Coal",
			mod_data         = "Coal/scripts/mods/Coal/Coal_data",
			mod_localization = "Coal/scripts/mods/Coal/Coal_localization",
		})
	end,
	packages = {},
}
