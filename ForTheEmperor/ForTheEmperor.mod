return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`ForTheEmperor` encountered an error loading the Darktide Mod Framework.")

		new_mod("ForTheEmperor", {
			mod_script       = "ForTheEmperor/scripts/mods/ForTheEmperor/ForTheEmperor",
			mod_data         = "ForTheEmperor/scripts/mods/ForTheEmperor/ForTheEmperor_data",
			mod_localization = "ForTheEmperor/scripts/mods/ForTheEmperor/ForTheEmperor_localization",
		})
	end,
	packages = {},
}
