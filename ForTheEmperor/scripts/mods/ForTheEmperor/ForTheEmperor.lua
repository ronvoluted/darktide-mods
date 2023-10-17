local mod = get_mod("ForTheEmperor")

--[[ ?????????????????????????????????? ]]

Managers.package:load("packages/ui/views/social_menu_roster_view/social_menu_roster_view", "ForTheEmperor", nil, true)

mod:io_dofile("ForTheEmperor/scripts/mods/ForTheEmperor/modules/add_strings")
mod:io_dofile("ForTheEmperor/scripts/mods/ForTheEmperor/modules/dibs_option")
mod:io_dofile("ForTheEmperor/scripts/mods/ForTheEmperor/modules/custom_entry_actions")
mod:io_dofile("ForTheEmperor/scripts/mods/ForTheEmperor/modules/need_help")
local wheel_options_module = mod:io_dofile("ForTheEmperor/scripts/mods/ForTheEmperor/modules/wheel_options")

local Vo = require("scripts/utilities/vo")

local WHEEL_OPTION = wheel_options_module.WHEEL_OPTION
local wheel_options = wheel_options_module.wheel_options
local HudElementSmartTagging_instance

local ICON_SIZE = { 112, 112 }
local LINE_SIZE = { 200, 147 }
local SLICE_SIZE = { 120, 140 }

local wheel_config = mod:get("wheel_config")
	or {
		[1] = WHEEL_OPTION.thanks,
		[2] = WHEEL_OPTION.health,
		[3] = WHEEL_OPTION.emperor,
		[4] = WHEEL_OPTION.yes,
		[5] = WHEEL_OPTION.enemy,
		[6] = WHEEL_OPTION.location,
		[7] = WHEEL_OPTION.attention,
		[8] = WHEEL_OPTION.no,
		[9] = WHEEL_OPTION.help,
		[10] = WHEEL_OPTION.ammo,
	}

local num_entries = table.size(wheel_config)

local generate_options = function(wheel_config)
	local options = {}

	for i, entry_name in ipairs(wheel_config) do
		options[i] = wheel_options[entry_name]
	end

	return options
end

local init_keybind_functions = function()
	local fun = function()
		return
	end
	for key in pairs(wheel_options) do
		mod["keybind_" .. key] = fun
	end
end

local comms_allowed = function()
	local game_mode = Managers.state.game_mode and Managers.state.game_mode:game_mode_name()
	local ui_manager = Managers.ui;
	if
		not (game_mode and Managers.player and ui_manager)
		and (game_mode == "coop_complete_objective" or game_mode == "shooting_range" or game_mode == "prologue")
		or (ui_manager.using_input())
	then
		return false
	end

	local player_unit = Managers.player:local_player_safe(1).player_unit

	return player_unit and ScriptUnit.has_extension(player_unit, "health_system"):is_alive()
end

local setup_keybind_functions = function()
	for key, option in pairs(wheel_options) do
		if key == "help" then
			mod.keybind_help = function()
				if not comms_allowed() then
					return
				end

				mod.need_help(10)
			end
		else
			mod["keybind_" .. key] = function()
				if not comms_allowed() then
					return
				end

				local tag_type = option.tag_type

				if tag_type then
					local force_update_targets = true
					local raycast_data = HudElementSmartTagging_instance:_find_raycast_targets(force_update_targets)
					local hit_position = raycast_data.static_hit_position

					if hit_position then
						HudElementSmartTagging_instance:_trigger_smart_tag(tag_type, nil, hit_position:unbox())
					end
				end

				local chat_message_data = option.chat_message_data

				if chat_message_data then
					local text = chat_message_data.text
					local channel_tag = chat_message_data.channel
					local channel, channel_handle =
						HudElementSmartTagging_instance:_get_chat_channel_by_tag(channel_tag)

					if channel then
						Managers.chat:send_loc_channel_message(channel_handle, text, nil)
					end
				end

				local voice_event_data = option.voice_event_data

				if voice_event_data then
					local parent = HudElementSmartTagging_instance._parent
					local player_unit = parent:player_unit()

					if player_unit then
						Vo.on_demand_vo_event(
							player_unit,
							voice_event_data.voice_tag_concept,
							voice_event_data.voice_tag_id
						)
					end
				end

				Managers.telemetry_reporters:reporter("com_wheel"):register_event(option.voice_event_data.voice_tag_id)
			end
		end
	end
end

mod:hook_require(
	"scripts/ui/hud/elements/smart_tagging/hud_element_smart_tagging_settings",
	function(HudElementSmartTaggingSettings)
		HudElementSmartTaggingSettings.wheel_slots = num_entries
	end
)

mod:hook_require(
	"scripts/ui/hud/elements/smart_tagging/hud_element_smart_tagging_definitions",
	function(hud_element_smart_tagging_definitions)
		hud_element_smart_tagging_definitions.entry_widget_definition.style.style_id_2.size = ICON_SIZE -- icon

		hud_element_smart_tagging_definitions.entry_widget_definition.style.style_id_3.size = LINE_SIZE -- slice_eighth_line

		hud_element_smart_tagging_definitions.entry_widget_definition.style.style_id_4.size = SLICE_SIZE -- slice_eighth_highlight
		hud_element_smart_tagging_definitions.entry_widget_definition.style.style_id_4.uvs = { { 0.1, 0 }, { 0.9, 1 } }

		hud_element_smart_tagging_definitions.entry_widget_definition.style.style_id_5.size = SLICE_SIZE -- slice_eighth
		hud_element_smart_tagging_definitions.entry_widget_definition.style.style_id_5.uvs = { { 0.1, 0 }, { 0.9, 1 } }
	end
)

mod:hook("HudElementSmartTagging", "_populate_wheel", function(fun, self, options)
	fun(self, generate_options(wheel_config))
end)

mod:hook_safe("HudElementSmartTagging", "update", function(self, dt, t, ui_renderer, render_settings, input_service)
	if not HudElementSmartTagging_instance then
		HudElementSmartTagging_instance = self

		setup_keybind_functions()
	end
	if not self._wheel_active then
		return
	end

	local hovered_entry, hovered_index = self:_is_wheel_entry_hovered(t)

	if hovered_entry and Mouse.button(1) == 1 then -- right-click held
		if not mod.dragged_entry then
			mod.dragged_entry = hovered_entry
			mod.dragged_index = hovered_index
		end

		if hovered_index ~= mod.dragged_index then
			local replaced_entry = wheel_config[hovered_index]
			wheel_config[hovered_index] = wheel_config[mod.dragged_index]
			wheel_config[mod.dragged_index] = replaced_entry

			mod.dragged_entry = hovered_entry
			mod.dragged_index = hovered_index

			self:_populate_wheel(generate_options(wheel_config))
		end

		local wheel_background_widget = self._widgets_by_name.wheel_background

		wheel_background_widget.content.text = Localize(mod.dragged_entry.option.display_name)

		for i, entry in pairs(self._entries) do
			local icon = entry.widget.style.style_id_2
			local highlight = entry.widget.style.style_id_4
			local slice = entry.widget.style.style_id_5
			if i == hovered_index then
				local angle = hovered_entry.widget.content.angle
				local offset_x = math.sin(angle) * 30
				local offset_y = math.cos(angle) * 30

				icon.offset[1] = offset_x
				icon.offset[2] = offset_y
				highlight.offset[1] = offset_x
				highlight.offset[2] = offset_y
				slice.offset[1] = offset_x
				slice.offset[2] = offset_y

				highlight.color[1] = 200
				slice.color[1] = 200
			else
				icon.offset[1] = 0
				icon.offset[2] = 0
				highlight.offset[1] = 0
				highlight.offset[2] = 0
				slice.offset[1] = 0
				slice.offset[2] = 0

				highlight.color[1] = 50
				slice.color[1] = 50
			end
		end
	else
		for _, entry in pairs(self._entries) do
			local icon = entry.widget.style.style_id_2
			local highlight = entry.widget.style.style_id_4
			local slice = entry.widget.style.style_id_5

			icon.offset[1] = 0
			icon.offset[2] = 0
			highlight.offset[1] = 0
			highlight.offset[2] = 0
			slice.offset[1] = 0
			slice.offset[2] = 0

			highlight.color[1] = 150
			slice.color[1] = 150
		end

		mod.dragged_entry = nil
		mod.dragged_index = nil
	end
end)

init_keybind_functions()

mod.update = function()
	for peer_id, marker in pairs(mod.help_markers) do
		if os.clock() - marker.time > 10 then
			Managers.event:trigger("remove_world_marker", marker.marker_id)

			mod.help_markers[peer_id] = nil
		end
	end
end

mod.on_unload = function()
	mod:set("wheel_config", wheel_config)
	HudElementSmartTagging_instance = nil
end
