local appdata_dir = os.getenv("AppData") .. "\\Fatshark\\Darktide"

return {
	mod_name = {
		["en"] = "Auto Backup",
		["zh-cn"] = "自动备份",
	},
	mod_description = {
		["en"] = "Automatically creates a backup of your settings on launch, exit and weekly\n\nAuthor: Seventeen ducks",
		["zh-cn"] = "启动退出游戏时以及每周自动创建设置备份\n\n作者：Seventeen ducks",
	},
	reset_warning_title = {
		["en"] = "Restore settings",
		["zh-cn"] = "恢复设置",
	},
	reset_warning_descripton = {
		["en"] = string.format(
			'Auto Backup\n\nIt appears the game may have reset your settings to default. To restore, exit the game and overwrite "user_settings.config" with "user_settings_backup.config" which can be found in:\n\n%s',
			appdata_dir
		),
		["zh-cn"] = string.format(
			'自动备份\n\n似乎游戏把设置重置为默认了。要恢复旧配置，退出游戏并用“user_settings_backup.config”文件覆盖“user_settings.config”文件，这些文件在此文件夹下：\n\n%s',
			appdata_dir
		),
	},
	reset_warning_okay = {
		["en"] = "Okay",
		["zh-cn"] = "好的",
	},
	reset_warning_exit = {
		["en"] = "Exit game",
		["zh-cn"] = "退出游戏",
	},
}
