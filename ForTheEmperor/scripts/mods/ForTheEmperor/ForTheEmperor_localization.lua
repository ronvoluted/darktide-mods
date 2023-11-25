local localizations = {
	mod_title = {
		["en"] = "For the Emperor!",
		["zh-cn"] = "为了帝皇！",
	},
	mod_description = {
		["en"] = "Shout words of camaraderie, Yes, No and Help from the comms wheel, fully customisable by dragging with right-click. Also adds keybinds and replaces greedy voicelines when re-tagging. \n\nAuthor: Seventeen ducks",
		["zh-cn"] = "通过标签轮盘喊出“是”、“否”、“需要帮助”等友谊之词，可通过右键点击完全自定义。同时添加快捷键，并替换重复标记时的贪婪语音。\n\n作者：Seventeen ducks",
	},
	options = {
		["en"] = "Options",
		["zh-cn"] = "选项",
	},
	keybinds = {
		["en"] = "Keybinds",
		["zh-cn"] = "快捷键",
	},
	disable_dibs = {
		["en"] = "Disable calling dibs when re-tagging",
		["zh-cn"] = "重复标记时，禁用表示占有欲的语音",
	},
	disable_dibs_desc = {
		["en"] = 'Call out and extend existing tags instead of saying "That\'s mine!"',
		["zh-cn"] = "重新喊出标记物品的语音并延长标记时间，而不是喊出“那是我的！”",
	},
	ignore_help = {
		["en"] = "Ignore help",
		["zh-cn"] = "忽略帮助",
	},
	ignore_help_desc = {
		["en"] = "Mute teammates and disable indicators when they need help",
		["zh-cn"] = "忽略队友的需要帮助语音和被控图标",
	},
	need_help = {
		["en"] = "I need help!",
		["zh-cn"] = "我需要帮助！",
	},
	need_help_comms_wheel = {
		["en"] = "Need Help",
		["zh-cn"] = "需要帮助",
	},
	keybind_ammo = {
		["en"] = Localize("loc_communication_wheel_display_name_need_ammo"),
	},
	keybind_attention = {
		["en"] = Localize("loc_communication_wheel_display_name_attention"),
	},
	keybind_enemy = {
		["en"] = Localize("loc_communication_wheel_display_name_enemy"),
	},
	keybind_health = {
		["en"] = Localize("loc_communication_wheel_display_name_need_health"),
	},
	keybind_location = {
		["en"] = Localize("loc_communication_wheel_display_name_location"),
	},
	keybind_no = {
		["en"] = Localize("loc_social_menu_confirmation_popup_decline_button"),
	},
	keybind_thanks = {
		["en"] = Localize("loc_communication_wheel_display_name_thanks"),
	},
	keybind_yes = {
		["en"] = Localize("loc_social_menu_confirmation_popup_confirm_button"),
	},
}

localizations.keybind_emperor = localizations.mod_title
localizations.keybind_help = localizations.need_help_comms_wheel

return localizations
