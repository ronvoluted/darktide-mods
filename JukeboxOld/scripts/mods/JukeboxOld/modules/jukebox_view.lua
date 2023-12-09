local mod = get_mod("JukeboxOld")

local definitions = mod:io_dofile("JukeboxOld/scripts/mods/JukeboxOld/modules/jukebox_view_definitions")
local config = mod:io_dofile("JukeboxOld/scripts/mods/JukeboxOld/modules/jukebox_view_config")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementInputLegendSettings =
	require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend_settings")
require("scripts/ui/views/vendor_view_base/vendor_view_base")
local default_view_input_settings = dofile("scripts/settings/input/default_view_input_settings")

local KeybindUtils = mod:io_dofile("JukeboxOld/scripts/mods/JukeboxOld/modules/keybind_utils")

local JukeboxView = class("JukeboxView", "VendorViewBase")

local filter_keys = {
	"_convert_offers_to_layout_entries",
	"_current_balance",
	"_destroy_weapon_preview",
	"_fetch_item_compare_slot_name",
	"_fetch_store_items",
	"_get_store",
	"_get_weapon_spawn_position_normalized",
	"_inventory_items",
	"_item_definitions",
	"_on_purchase_complete",
	"_purchase_item",
	"_set_display_price",
	"_setup_weapon_preview",
	"_setup_weapon_stats",
	"_set_weapon_zoom",
	"_update_wallets",
	"_update_wallets_presentation",
	"_update_weapon_preview_viewport",
	"_update_weapon_stats_position",
	"_wallet_promise",
	"_weapon_compare_stats",
	"_weapon_stats",
	"can_afford",
	"character_level",
	"equipped_item_in_slot",
}

local create_template = function(params)
	local default_value = params.default_value

	local function default_value_function()
		return default_value
	end

	local value_get_function = params.value_get_function or default_value_function
	local value_change_function = params.on_value_changed_function or default_value_function

	local template = {
		widget_type = "value_slider",
		display_name = params.display_name,
		default_value = default_value,
		on_changed = value_change_function,
		on_activated = value_change_function,
		get_function = value_get_function,
		disabled = false,
	}

	return template
end

JukeboxView.init = function(self, settings, context)
	JukeboxView.super.init(self, definitions, settings, context)

	self._use_item_categories = false

	self.select_first_index = function() end

	self._allow_close_hotkey = true
end

JukeboxView._insert_custom_input_actions = function(self)
	if self._input_legend_element and self._input_legend_element._entries then
		for _, legend_input in pairs(self._input_legend_element._entries) do
			if not table.contains(default_view_input_settings.settings, legend_input.input_action) then
				local keybind = mod:get(legend_input.input_action)

				if keybind and #keybind > 0 then
					self._input_legend_element._widgets_by_name[legend_input.id].content.text =
						KeybindUtils.keybind_to_legend(legend_input.input_action, Localize(legend_input.display_name))
				end
			end
		end

		self._custom_input_actions_inserted = true
	end
end

JukeboxView._setup_input_legend = function(self)
	self._legends = {}
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)
	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback
			and callback(self, legend_input.on_pressed_callback)

		local legend_id = self._input_legend_element:add_entry(
			legend_input.display_name_options and legend_input.display_name_options[1] or legend_input.display_name,
			legend_input.input_action,
			legend_input.visibility_function,
			on_pressed_callback,
			legend_input.alignment
		)

		self._legends[legend_input.display_name] = {
			widget_name = legend_id,
			entry_index = i,
		}

		-- Calculate width to prevent layout shift when switching between Play/Stop
		if legend_input.display_name == "loc_jukebox_play" then
			local keybind_play_stop = mod:get("jukebox_play_stop")
			local keybind_string = ""

			if keybind_play_stop and #keybind_play_stop > 0 then
				keybind_string = KeybindUtils.keybind_to_string(mod:get("jukebox_play_stop")) .. " "
			end

			local largest_width = KeybindUtils.text_options_bounding_size(
				self._input_legend_element._widgets_by_name[legend_id],
				self._ui_renderer,
				{
					keybind_string .. mod:localize("play"),
					keybind_string .. mod:localize("stop"),
				}
			)

			self._play_stop_width = largest_width + ViewElementInputLegendSettings.button_text_margin
		end
	end
end

JukeboxView.present_grid_layout = function(self, layout, on_present_callback)
	self:set_loading_state(false)
	JukeboxView.super.present_grid_layout(self, layout, on_present_callback)
end

JukeboxView._sort_grid_layout = function(self)
	local layout = table.clone(self._filtered_offer_items_layout)
	table.reverse(layout) -- revert the reversed loop iteration in `ItemGridViewBase._present_layout_by_slot_filter`

	local on_present_callback = callback(self, "_cb_on_present")

	self:present_grid_layout(layout, on_present_callback)
end

JukeboxView._update_grid_height = function(self, use_tab_menu)
	return
end

JukeboxView._generate_layout = function(self)
	local layout = {}
	local widget_size = { 580, 60 }

	for _, option in ipairs(config) do
		local template

		if option.widget_type == "jukebox_track" then
			template = create_template(option)
		elseif option.widget_type == "jukebox_toggle" then
			template = create_template(option)
		elseif option.widget_type == "jukebox_subheading" then
			template = option
		end

		template = table.merge(template, {
			widget_type = option.widget_type,
			size = widget_size,
			on_activated = option.on_activated or template.on_activated,
		})

		layout[#layout + 1] = template
	end

	return layout
end

JukeboxView._populate_layout = function(self)
	local layout = self:_generate_layout()

	self._offer_items_layout = layout

	self:_update_grid_height(false)

	self:_present_layout_by_slot_filter({})
end

JukeboxView.clear_unused_data = function(self)
	for _, key in pairs(filter_keys) do
		self[key] = nil
	end
end

JukeboxView.on_enter = function(self)
	JukeboxView.super.on_enter(self)

	mod.disabled_tracks = mod:get("disabled_tracks")

	self._item_grid._widgets_by_name.grid_divider_top.visible = false
	self._item_grid._widgets_by_name.grid_divider_bottom.visible = false

	self._using_cursor_navigation = Managers.ui:using_cursor_navigation()

	self:_populate_layout()
	self:_setup_input_legend()
	self:clear_unused_data()

	if not self._custom_input_actions_inserted then
		self:_insert_custom_input_actions()
	end

	self._item_grid._grid:set_scrollbar_progress(mod.scroll_position or 0)
end

JukeboxView.on_exit = function(self)
	mod.scroll_position = self._item_grid._current_scrollbar_progress
	mod:set("disabled_tracks", mod.disabled_tracks)

	JukeboxView.super.on_exit(self)
end

JukeboxView._setup_item_grid = function(self)
	local total_height = 0
	local widgets_by_name = self._widgets_by_name
	local title_text_widget = widgets_by_name.title_text

	if title_text_widget then
		local ui_renderer = self._ui_renderer
		local content = title_text_widget.content
		local style = title_text_widget.style
		local text_style = style.text
		local text_options = UIFonts.get_font_options_by_style(text_style)
		local _, height = UIRenderer.text_size(
			ui_renderer,
			content.text,
			text_style.font_type,
			text_style.font_size,
			text_style.size,
			text_options
		)
		height = height + 10

		self:_set_scenegraph_size("title_text", nil, height)

		local height_offset = 120

		self:_set_scenegraph_position("title_text", nil, height_offset)

		total_height = total_height + height + height_offset -- height of header area
	end

	total_height = total_height + 60
	local grid_settings = self._definitions.grid_settings
	grid_settings.top_padding = total_height

	JukeboxView.super._setup_item_grid(self)

	self._item_grid.select_first_index = function() end -- disable auto-selecting first item
end

JukeboxView._setup_sort_options = function(self) -- needed for sorting
	self._sort_options = nil
end

JukeboxView.draw = function(self, dt, t, input_service, layer)
	return JukeboxView.super.draw(self, dt, t, input_service, layer)
end

JukeboxView._force_legend_width = function(self, width)
	local play_widget_name = self._legends.loc_jukebox_play.widget_name
	local play_widget = self._input_legend_element._widgets_by_name[play_widget_name]
	local stop_widget_name = self._legends.loc_jukebox_stop.widget_name
	local stop_widget = self._input_legend_element._widgets_by_name[stop_widget_name]

	width = width or self._play_stop_width + ViewElementInputLegendSettings.button_text_margin

	play_widget.content.size[1] = width
	stop_widget.content.size[1] = width
end

JukeboxView.update = function(self, dt, t, input_service)
	local handle_input = true

	if self._update_callback_on_grid_entry_left_pressed then
		self._update_callback_on_grid_entry_left_pressed()

		self._update_callback_on_grid_entry_left_pressed = nil
	end

	if self._update_callback_on_grid_entry_right_pressed then
		self._update_callback_on_grid_entry_right_pressed()

		self._update_callback_on_grid_entry_right_pressed = nil
	end

	local pass_input, pass_draw = JukeboxView.super.update(self, dt, t, input_service)

	self:_force_legend_width(150)

	return handle_input and pass_input, pass_draw
end

JukeboxView._handle_input = function(self, input_service, dt, t)
	JukeboxView.super._handle_input(self, input_service)
end

JukeboxView._on_back_pressed = function(self)
	Managers.ui:close_view(self.view_name)
end

JukeboxView._on_play_stop_pressed = function(self)
	mod.play_stop_toggle()
end

JukeboxView._on_play_pressed = function(self)
	mod.play()
end

JukeboxView._on_stop_pressed = function(self)
	mod.stop()
end

JukeboxView._on_previous_pressed = function(self)
	mod._progress_track(false)
end

JukeboxView._on_next_pressed = function(self)
	mod._progress_track()
end

JukeboxView.cb_on_grid_entry_left_pressed = function(self, widget, element_config)
	local function cb_func()
		if self._destroyed then
			return
		end

		if Managers.ui:using_cursor_navigation() then
			local widget_index = self._item_grid:widget_index(widget) or 1

			self._item_grid:focus_grid_index(widget_index)
		end
	end

	self._update_callback_on_grid_entry_left_pressed = callback(cb_func)
end

JukeboxView.cb_on_grid_entry_right_pressed = function(self, widget, element_config)
	element_config.on_changed(element_config.default_value)
end

return JukeboxView
