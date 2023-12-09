local mod = get_mod("JukeboxOld")

local InputUtils = require("scripts/managers/input/input_utils")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")

local JukeboxOld_data = mod:io_dofile("JukeboxOld/scripts/mods/JukeboxOld/JukeboxOld_data")

local MAIN_MAPPINGS = {
	["oem_period (> .)"] = "keyboard_oem_period ",
	["oem_minus (_ -)"] = "keyboard_oem_minus",
	["numpad +"] = "keyboard_numpad plus",
	["num -"] = "keyboard_num minus",
	["oem_comma (< ,)"] = "keyboard_oem_comma",
	["oem_1 (: ;)"] = "keyboard_oem_1",
	["oem_plus (+ =)"] = "keyboard_oem_plus",
	["oem_2 (? /)"] = "keyboard_oem_2",
	["oem_3 (~ `)"] = "keyboard_oem_3",
	["oem_4 ({ [)"] = "keyboard_oem_4",
	["oem_5 (| )"] = "keyboard_oem_5",
	["oem_6 (} ])"] = "keyboard_oem_6",
	["oem_7 (\" ')"] = "keyboard_oem_7",
	["oem_8 (?!)"] = "keyboard_oem_8",
	["oem_102 (> <)"] = "keyboard_102",
}

local ENABLER_KEYS = {
	"ctrl",
	"left ctrl",
	"right ctrl",
	"alt",
	"left alt",
	"right alt",
	"shift",
	"left shift",
	"right shift",
	"keyboard_ctrl",
	"keyboard_alt",
	"keyboard_shift",
	"keyboard_left ctrl",
	"keyboard_left alt",
	"keyboard_left shift",
	"keyboard_right ctrl",
	"keyboard_right alt",
	"keyboard_right shift",
}

local ENABLER_MAPPINGS = {
	["keyboard_ctrl"] = "keyboard_left ctrl",
	["ctrl"] = "keyboard_left ctrl",
	["left ctrl"] = "keyboard_left ctrl",
	["right ctrl"] = "keyboard_right ctrl",
	["keyboard_alt"] = "keyboard_left alt",
	["alt"] = "keyboard_left alt",
	["left alt"] = "keyboard_left alt",
	["right alt"] = "keyboard_right alt",
	["keyboard_shift"] = "keyboard_left shift",
	["shift"] = "keyboard_left shift",
	["left shift"] = "keyboard_left shift",
	["right shift"] = "keyboard_right shift",
}

local keybind_to_string = function(keybind)
	local key_info = {}

	for _, key in ipairs(keybind) do
		if not key_info.main and not table.contains(ENABLER_KEYS, key) then
			key_info.main = MAIN_MAPPINGS[key] or ("keyboard_" .. key)
		else
			if not key_info.enablers then
				key_info.enablers = {}
			end

			table.insert(key_info.enablers, ENABLER_MAPPINGS[key] or key)
		end
	end

	return InputUtils.localized_string_from_key_info(key_info)
end

local keybind_to_legend = function(keybind_setting_id, override_title, color)
	color = color or { 255, 226, 199, 126 }

	local keybind = mod:get(keybind_setting_id)

	local keybind_string = #keybind > 0 and keybind_to_string(keybind)
	local keybind_title

	if override_title then
		keybind_title = override_title
	else
		for _, widget in ipairs(JukeboxOld_data.options.widgets) do
			if widget.setting_id == keybind_setting_id then
				keybind_title = widget.title and mod:localize(widget.title) or keybind_setting_id
			end
		end
	end

	if keybind_string then
		return string.format("%s %s", InputUtils.apply_color_to_input_text(keybind_string, color), keybind_title)
	else
		return keybind_title
	end
end

local text_options_bounding_size = function(widget, ui_renderer, options)
	local content = widget.content
	local style = widget.style
	local text_style = style.text
	local size = { 1920, content.size[2] }
	local text_options = UIFonts.get_font_options_by_style(text_style)

	local largest_width = 0
	local largest_height = 0
	local largest_width_option
	local largest_height_option

	for i, text in ipairs(options) do
		local width, height =
			UIRenderer.text_size(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)

		if width > largest_width then
			largest_width = width
			largest_width_option = text
		end

		if height > largest_height then
			largest_height = height
			largest_height_option = text
		end
	end

	return largest_width, largest_height, largest_width_option, largest_height_option
end

return {
	keybind_to_string = keybind_to_string,
	keybind_to_legend = keybind_to_legend,
	text_options_bounding_size = text_options_bounding_size,
}
