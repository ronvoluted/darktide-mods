return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`DelayedMessages` encountered an error loading the Darktide Mod Framework.")

		new_mod("DelayedMessages", {
			mod_script       = "DelayedMessages/scripts/mods/DelayedMessages/DelayedMessages",
			mod_data         = "DelayedMessages/scripts/mods/DelayedMessages/DelayedMessages_data",
			mod_localization = "DelayedMessages/scripts/mods/DelayedMessages/DelayedMessages_localization",
		})
	end,
	packages = {},
}
