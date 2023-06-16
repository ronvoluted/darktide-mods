local mod = get_mod("Jukebox")

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")

mod:add_require_path("Jukebox/scripts/mods/Jukebox/modules/jukebox_view")

mod:register_view({
	view_name = "jukebox_view",
	view_settings = {
		init_view_function = function(ingame_ui_context)
			return true
		end,
		state_bound = true,
		display_name = "loc_jukebox_high_gothic_name",
		path = "Jukebox/scripts/mods/Jukebox/modules/jukebox_view",
		package = "packages/ui/hud/player_weapon/player_weapon",
		class = "JukeboxView",
		disable_game_world = false,
		load_always = true,
		load_in_hub = true,
		game_world_blur = 0.75,
		enter_sound_events = {
			UISoundEvents.system_menu_enter,
		},
		exit_sound_events = {
			UISoundEvents.system_menu_exit,
		},
		wwise_states = {
			options = "none",
		},
		context = {
			use_item_categories = false,
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
