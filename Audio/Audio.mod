return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`Audio` encountered an error loading the Darktide Mod Framework.")

		new_mod("Audio", {
			mod_script       = "Audio/scripts/mods/Audio/Audio",
			mod_data         = "Audio/scripts/mods/Audio/Audio_data",
			mod_localization = "Audio/scripts/mods/Audio/Audio_localization",
		})
	end,
	packages = {},
}
