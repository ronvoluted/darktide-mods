local appdata_dir = os.getenv("AppData") .. "\\Fatshark\\Darktide"

return {
	mod_name = {
		["en"] = "Auto Backup",
	},
	mod_description = {
		["en"] = "Automatically creates a backup of your settings on launch, exit and weekly\n\nAuthor: Seventeen",
	},
	reset_warning_title = {
		["en"] = "Restore settings",
	},
	reset_warning_descripton = {
		["en"] = string.format(
			'Auto Backup\n\nIt appears the game may have reset your settings to default. To restore, exit the game and overwrite "user_settings.config" with "user_settings_backup.config" which can be found in:\n\n%s',
			appdata_dir
		),
	},
	reset_warning_okay = {
		["en"] = "Okay",
	},
	reset_warning_exit = {
		["en"] = "Exit game",
	},
}
