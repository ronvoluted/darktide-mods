local localizations = {
	mod_title = {
		["en"] = "For the Emperor!",
		["zh-cn"] = "为了帝皇！",
	},
	mod_description = {
		["en"] = "Shout words of camaraderie, Yes, No and Help from the comms wheel, fully customisable by dragging with right-click. Also adds keybinds and replaces greedy voicelines when re-tagging. \n\nAuthor: Seventeen",
		["zh-cn"] = "通过标签轮盘喊出“为了帝皇！”、“为了亚托玛！”或其他友谊之词\n\n作者：Seventeen",
	},
	options = {
		["en"] = "Options",
	},
	keybinds = {
		["en"] = "Keybinds",
	},
	disable_dibs = {
		["en"] = "Disable calling dibs when re-tagging",
	},
	disable_dibs_desc = {
		["en"] = 'Call out and extend existing tags instead of saying "That\'s mine!"',
	},
	ignore_help = {
		["en"] = "Ignore help",
	},
	ignore_help_desc = {
		["en"] = "Mute teammates and disable indicators when they need help",
	},
	need_help = {
		["en"] = "I need help!",
	},
	need_help_comms_wheel = {
		["en"] = "Need Help",
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
