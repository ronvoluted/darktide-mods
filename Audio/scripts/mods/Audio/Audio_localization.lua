return {
	mod_name = {
		["en"] = "Audio Plugin",
		["zh-cn"] = "音频插件",
	},
	mod_description = {
		["en"] = "Library for playing custom sound files and hooking/playing Wwise events. Developer Mode and Show Developer Console must be On in Darktide Mod Framework options.\n\nAuthor: Seventeen ducks in a trenchcoat",
		["zh-cn"] = "用于播放自定义音频文件并挂钩/播放 WWise 事件的公共库。Darktide Mod Framework 选项中必须启用“开发者模式”和“显示开发者控制台”。\n\n作者：Seventeen ducks in a trenchcoat",
	},
	log_errors = {
		["en"] = "Log errors",
		["zh-cn"] = "记录错误日志",
	},
	log_errors_tooltip = {
		["en"] = "Print failed `play_file` info to the developer console",
		["zh-cn"] = "在开发者控制台输出失败的 `play_file` 信息",
	},
	log_server_commands = {
		["en"] = "Populate crash logs with server commands",
		["zh-cn"] = "产生与服务器命令有关的崩溃日志",
	},
	log_server_commands_tooltip = {
		["en"] = "This can quickly max out the crash console_logs with hundreds of server commands, making them useless. Only enable if you are debugging.",
		["zh-cn"] = "这会快速导致崩溃日志 console_logs 被上百条服务器命令填满，通常没有意义。仅应在调试时启用。",
	},
	log_wwise = {
		["en"] = "Log Wwise events and sounds",
		["zh-cn"] = "记录 Wwise 事件和音频日志",
	},
	log_wwise_tooltip = {
		["en"] = "Print triggered Wwise sound names and their type to the developer console",
		["zh-cn"] = "在开发者控制台输出触发的 Wwise 音频名称和类型",
	},
	log_wwise_common = {
		["en"] = "Include common sounds in Wwise logging",
		["zh-cn"] = "在 Wwise 日志中包括常规音频",
	},
	log_wwise_common_tooltip = {
		["en"] = "Sounds matching the pattern \"husk\", \"foley\", \"footstep\", \"locomotion\", \"material\", \"upper_body\" or \"vce\"",
		["zh-cn"] = "匹配“husk”、“foley”、“footstep”、“locomotion”、“material”、“upper_body”和“vce”模式的音频",
	},
	log_wwise_ui = {
		["en"] = "Include UI sounds in Wwise logging",
		["zh-cn"] = "在 Wwise 日志中包括 UI 音频",
	},
	log_wwise_ui_tooltip = {
		["en"] = "Sounds matching the pattern \"events/ui\"",
		["zh-cn"] = "匹配“events/ui”模式的音频",
	},
	log_wwise_verbose = {
		["en"] = "Verbose event logging",
		["zh-cn"] = "详细事件日志",
	},
	log_wwise_verbose_tooltip = {
		["en"] = "Log a table of all arguments for each event",
		["zh-cn"] = "对每个事件，记录包含所有参数的表（table）",
	},
}
