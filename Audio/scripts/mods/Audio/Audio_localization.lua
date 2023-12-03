return {
	mod_name = {
		["en"] = "Audio Plugin",
		["ru"] = "Аудио плагин",
    ["zh-cn"] = "音频插件",
	},
	mod_description = {
		["en"] = "Library for playing custom sound files and hooking/playing Wwise events. Developer Mode and Show Developer Console must be On in Darktide Mod Framework options.\n\nAuthor: Seventeen ducks",
		["ru"] = "Audio Plugin - Библиотека для воспроизведения пользовательских звуковых файлов и подключения/воспроизведения событий Wwise. В настройках Darktide Mod Framework должны быть включены «Режим разработчика» и «Показать консоль разработчика».\nАвтор: Seventeen ducks",
    ["zh-cn"] = "用于播放自定义音频文件并挂钩/播放 WWise 事件的公共库。Darktide Mod Framework 选项中必须启用“开发者模式”和“显示开发者控制台”。\n\n作者：Seventeen ducks",
	},
	log_errors = {
		["en"] = "Log errors",
		["ru"] = "Записывать ошибки",
    ["zh-cn"] = "记录错误日志",
	},
	log_errors_tooltip = {
		["en"] = "Print failed `play_file` info to the developer console",
		["ru"] = "Показывать информацию об ошибке `play_file` в консоли разработчика",
    ["zh-cn"] = "在开发者控制台输出失败的 `play_file` 信息",
	},
	log_server_commands = {
		["en"] = "Populate crash logs with server commands",
		["ru"] = "Заполнение журналов сбоев командами сервера",
    ["zh-cn"] = "产生与服务器命令有关的崩溃日志",
	},
	log_server_commands_tooltip = {
		["en"] = "This can quickly max out the crash console_logs with hundreds of server commands, making them useless. Only enable if you are debugging.",
		["ru"] = "Это может быстро привести к сбою console_logs из-за сотен серверных команд, сделав их бесполезными. Включайте только в том случае, если вы выполняете отладку.",
    ["zh-cn"] = "这会快速导致崩溃日志 console_logs 被上百条服务器命令填满，通常没有意义。仅应在调试时启用。",
	},
	log_silenced = {
		["en"] = "Include silenced sounds in Wwise logging",
	},
	log_silenced_tooltip = {
		["en"] = "Log voicelines and sound events even if they have been silenced by Audio mods",
	},
	log_to_chat = {
		["en"] = "Log to chat window instead of developer console",
	},
	log_to_chat_tooltip = {
		["en"] = 'Only the developer console will show sound type (e.g. "source_sound", "3d_sound"). NOTE: Not compatible with "Verbose event logging" option.',
	},
	log_wwise = {
		["en"] = "Log Wwise events and sounds",
		["ru"] = "Записывать события и звуки Wwise",
    ["zh-cn"] = "记录 Wwise 事件和音频日志",
	},
	log_wwise_tooltip = {
		["en"] = "Print triggered Wwise sound names and their type to the developer console",
		["ru"] = "Показывать названия звуков, запускаемых Wwise, и их тип в консоли разработчика.",
    ["zh-cn"] = "在开发者控制台输出触发的 Wwise 音频名称和类型",
	},
	log_wwise_common = {
		["en"] = "Include common sounds in Wwise logging",
		["ru"] = "Включать общие звуки в журнал Wwise",
    ["zh-cn"] = "在 Wwise 日志中包括常规音频",
	},
	log_wwise_common_tooltip = {
		["en"] = "Sounds matching the pattern \"husk\", \"foley\", \"footstep\", \"locomotion\", \"material\", \"upper_body\" or \"vce\"",
		["ru"] = "Звуки, соответствующие шаблону: «husk», «foley», «footstep», «locomotion», «material», «upper_body» или «vce».",
    ["zh-cn"] = "匹配“husk”、“foley”、“footstep”、“locomotion”、“material”、“upper_body”和“vce”模式的音频",
	},
	log_wwise_ui = {
		["en"] = "Include UI sounds in Wwise logging",
		["ru"] = "Включить звуки пользовательского интерфейса в ведение журнала Wwise",
    ["zh-cn"] = "在 Wwise 日志中包括 UI 音频",
	},
	log_wwise_ui_tooltip = {
		["en"] = "Sounds matching the pattern \"events/ui\"",
		["ru"] = "Звуки, соответствующие шаблону «events/ui».",
    ["zh-cn"] = "匹配“events/ui”模式的音频",
	},
	log_wwise_verbose = {
		["en"] = "Verbose event logging",
		["ru"] = "Подробная регистрация событий",
    ["zh-cn"] = "详细事件日志",
	},
	log_wwise_verbose_tooltip = {
		["en"] = 'Log a table of all arguments for each event. NOTE: Not compatible with "Log to chat window" option.',
		["ru"] = "Записывать таблицу всех аргументов для каждого события.",
		["zh-cn"] = "对每个事件，记录包含所有参数的表（table）",
	},
}
