return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`CustomViewBoilerplate` encountered an error loading the Darktide Mod Framework.")

		new_mod("CustomViewBoilerplate", {
			mod_script       = "CustomViewBoilerplate/scripts/mods/CustomViewBoilerplate/CustomViewBoilerplate",
			mod_data         = "CustomViewBoilerplate/scripts/mods/CustomViewBoilerplate/CustomViewBoilerplate_data",
			mod_localization = "CustomViewBoilerplate/scripts/mods/CustomViewBoilerplate/CustomViewBoilerplate_localization",
		})
	end,
	packages = {},
}
