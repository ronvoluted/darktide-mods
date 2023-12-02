return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`PreventPlayerFade` encountered an error loading the Darktide Mod Framework.")

		new_mod("PreventPlayerFade", {
			mod_script       = "PreventPlayerFade/scripts/mods/PreventPlayerFade/PreventPlayerFade",
			mod_data         = "PreventPlayerFade/scripts/mods/PreventPlayerFade/PreventPlayerFade_data",
			mod_localization = "PreventPlayerFade/scripts/mods/PreventPlayerFade/PreventPlayerFade_localization",
		})
	end,
	packages = {},
}
