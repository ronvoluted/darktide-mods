local mod = get_mod("CustomViewBoilerplate")

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")

mod:add_require_path("CustomViewBoilerplate/scripts/mods/CustomViewBoilerplate/custom_view/custom_view")

local custom_view_registered_correctly = mod:register_view({
	view_name = "custom_view",
	view_settings = {
		init_view_function = function(ingame_ui_context)
			return true
		end,
		state_bound = true,
		display_name = "loc_eye_color_sienna_desc", -- Only used for debug
		path = "CustomViewBoilerplate/scripts/mods/CustomViewBoilerplate/custom_view/custom_view",
		-- package = "", -- Optional package to load with view
		class = "CustomView",
		disable_game_world = false,
		load_always = true,
		load_in_hub = true,
		game_world_blur = 0,
		enter_sound_events = {
			UISoundEvents.system_menu_enter,
		},
		exit_sound_events = {
			UISoundEvents.system_menu_exit,
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
		},
	},
	view_transitions = {},
	view_options = {
		close_all = false,
		close_previous = false,
		close_transition_time = nil,
		transition_time = nil,
	},
})

mod.toggle_custom_view = function()
	if
		not Managers.ui:has_active_view()
		and not Managers.ui:chat_using_input()
		and not Managers.ui:view_instance("custom_view")
	then
		Managers.ui:open_view("custom_view")
	elseif Managers.ui:view_instance("custom_view") then
		Managers.ui:close_view("custom_view")
	end
end

mod:command("open_custom_view", mod:localize("keybind_open_custom_view"), function()
	mod.toggle_custom_view()
end)
