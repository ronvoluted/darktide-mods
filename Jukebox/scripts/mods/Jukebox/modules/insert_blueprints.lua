local mod = get_mod("Jukebox")

require("scripts/ui/view_content_blueprints/item_blueprints")

local CheckboxPassTemplates = require("scripts/ui/pass_templates/checkbox_pass_templates")
local OptionsViewContentBlueprints = require("scripts/ui/views/options_view/options_view_content_blueprints")

local jukebox_track = {
	size = {
		580,
		60,
	},
	pass_template_function = function(parent, config, size)
		local template = CheckboxPassTemplates.settings_checkbox(580, 60, 60, 1, true)

		for _, pass in ipairs(template) do
			if pass.style_id == "list_header" then
				pass.style.default_color = table.clone(pass.style.hover_color)
			end

			if pass.style_id == "option_1" then
				pass.style.default_color = { 0, 255, 255, 255 }
				pass.style.hover_color = { 255, 200, 0, 0 }
				pass.style.disabled_color = { 255, 200, 200, 200 }
			end

			if pass and pass.value == "content/ui/materials/frames/hover" then
				pass.visibility_function = function(content, style)
					local option_hotspot_1 = content.option_hotspot_1

					return option_hotspot_1.is_hover
				end
			end
		end

		return template
	end,
	init = function(parent, widget, entry, callback_name, changed_callback_name)
		local content = widget.content
		local display_name = entry.display_name or "loc_settings_option_unavailable"
		content.text = Managers.localization:localize(display_name)
		content.entry = entry

		content.option_1 = ""

		content.hotspot.pressed_callback = function()
			if not content.option_hotspot_1.is_hover then
				local track_number = entry.display_name:gsub("loc_jukebox_track_", "")

				mod.current_track = tonumber(track_number)
				mod.play()
			end
		end

		-- content.hotspot.right_pressed_callback = function()
		-- 	return
		-- end
	end,
	update = function(parent, widget, input_service, dt, t)
		local content = widget.content
		local entry = content.entry
		local value = entry:get_function()
		local on_activated = entry.on_activated
		local hotspot = content.option_hotspot_1
		local widget_disabled = content.disabled or false
		local is_disabled = entry.disabled or false
		content.disabled = is_disabled
		local new_value = nil

		if hotspot.on_pressed and not parent._navigation_column_changed_this_frame and not is_disabled then
			new_value = not value
		end

		if widget_disabled then
			content.option_1 = mod:localize("add_to_playlist")
			widget.style.option_1.size[1] = 200
			widget.style.option_hotspot_1.size[1] = 200
			widget.style.style_id_6.size[1] = 200
			widget.style.style_id_8.size[1] = 200
		else
			content.option_1 = ""
			widget.style.option_1.size[1] = 60
			widget.style.option_hotspot_1.size[1] = 60
			widget.style.style_id_6.size[1] = 60
			widget.style.style_id_8.size[1] = 60
		end

		content.option_hotspot_1.is_selected = value

		content.disabled = value

		if new_value ~= nil and new_value ~= value then
			on_activated(new_value, entry)
		end
	end,
}

local jukebox_toggle = {
	size = {
		580,
		60,
	},
	pass_template_function = function(parent, config, size)
		local template = CheckboxPassTemplates.settings_checkbox(580, config.size[2], 200, 2, true)

		return template
	end,
	init = function(parent, widget, entry, callback_name, changed_callback_name)
		local content = widget.content
		local display_name = entry.display_name or "loc_settings_option_unavailable"
		content.text = Managers.localization:localize(display_name)
		content.entry = entry

		content.option_1 = Managers.localization:localize("loc_setting_checkbox_on")
		content.option_2 = Managers.localization:localize("loc_setting_checkbox_off")
	end,
	update = function(parent, widget, input_service, dt, t)
		local content = widget.content
		local entry = content.entry
		local value = entry:get_function()
		local on_activated = entry.on_activated
		local hotspot = content.hotspot
		local is_disabled = entry.disabled or false
		content.disabled = is_disabled
		local new_value = nil

		if hotspot.on_pressed and not parent._navigation_column_changed_this_frame and not is_disabled then
			new_value = not value
		end

		for i = 1, 2 do
			local widget_option_id = "option_hotspot_" .. i
			local option_hotspot = content[widget_option_id]
			local is_selected = value and i == 1 or not value and i == 2
			option_hotspot.is_selected = is_selected
		end

		if new_value ~= nil and new_value ~= value then
			on_activated(new_value, entry)
		end
	end,
}

local jukebox_subheading = OptionsViewContentBlueprints.group_header
jukebox_subheading.size = { 1000, 45 }
jukebox_subheading.pass_template[1].style.font_size = 30
jukebox_subheading.pass_template[1].style.offset = { 28, 5, 0 }

mod:hook(
	package.loaded,
	"scripts/ui/view_content_blueprints/item_blueprints",
	function(generate_blueprints_function, grid_size)
		local item_blueprints = generate_blueprints_function(grid_size)

		item_blueprints.jukebox_track = jukebox_track
		item_blueprints.jukebox_toggle = jukebox_toggle
		item_blueprints.jukebox_subheading = jukebox_subheading

		return item_blueprints
	end
)
