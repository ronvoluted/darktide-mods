return {
	mod_name = {
		["en"] = "Audio Plugin",
		["zh-cn"] = "音频插件",
		["ru"] = "Аудио плагин",
	},
	mod_description = {
		["en"] = "Library for playing custom sound files and hooking/playing Wwise events. Developer Mode and Show Developer Console must be On in Darktide Mod Framework options.\n\nAuthor: Seventeen ducks in a trenchcoat",
		["zh-cn"] = "用于播放自定义音频文件并管理 WWise 事件的公共库。\n\n作者：Seventeen ducks in a trenchcoat",
		["ru"] = "Audio Plugin - Библиотека для воспроизведения пользовательских звуковых файлов и подключения/воспроизведения событий Wwise. В настройках Darktide Mod Framework должны быть включены «Режим разработчика» и «Показать консоль разработчика».\nАвтор: Seventeen ducks in a trenchcoat",
	},
	log_errors = {
		["en"] = "Log errors",
		["ru"] = "Записывать ошибки",
	},
	log_errors_tooltip = {
		["en"] = "Print failed `play_file` info to the developer console",
		["ru"] = "Показывать информацию об ошибке `play_file` в консоли разработчика",
	},
	log_server_commands = {
		["en"] = "Populate crash logs with server commands",
		["ru"] = "Заполнение журналов сбоев командами сервера",
	},
	log_server_commands_tooltip = {
		["en"] = "This can quickly max out the crash console_logs with hundreds of server commands, making them useless. Only enable if you are debugging.",
		["ru"] = "Это может быстро привести к сбою console_logs из-за сотен серверных команд, сделав их бесполезными. Включайте только в том случае, если вы выполняете отладку.",
	},
	log_wwise = {
		["en"] = "Log Wwise events and sounds",
		["ru"] = "Записывать события и звуки Wwise",
	},
	log_wwise_tooltip = {
		["en"] = "Print triggered Wwise sound names and their type to the developer console",
		["ru"] = "Показывать названия звуков, запускаемых Wwise, и их тип в консоли разработчика.",
	},
	log_wwise_common = {
		["en"] = "Include common sounds in Wwise logging",
		["ru"] = "Включать общие звуки в журнал Wwise",
	},
	log_wwise_common_tooltip = {
		["en"] = "Sounds matching the pattern \"husk\", \"foley\", \"footstep\", \"locomotion\", \"material\", \"upper_body\" or \"vce\"",
		["ru"] = "Звуки, соответствующие шаблону: «husk», «foley», «footstep», «locomotion», «material», «upper_body» или «vce».",
	},
	log_wwise_ui = {
		["en"] = "Include UI sounds in Wwise logging",
		["ru"] = "Включить звуки пользовательского интерфейса в ведение журнала Wwise",
	},
	log_wwise_ui_tooltip = {
		["en"] = "Sounds matching the pattern \"events/ui\"",
		["ru"] = "Звуки, соответствующие шаблону «events/ui».",
	},
	log_wwise_verbose = {
		["en"] = "Verbose event logging",
		["ru"] = "Подробная регистрация событий",
	},
	log_wwise_verbose_tooltip = {
		["en"] = "Log a table of all arguments for each event",
		["ru"] = "Записывать таблицу всех аргументов для каждого события.",
	},
}
