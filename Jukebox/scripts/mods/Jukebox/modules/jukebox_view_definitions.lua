local mod = get_mod("Jukebox")

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")

local music_tracks = mod:io_dofile("Jukebox/scripts/mods/Jukebox/modules/music_tracks")

local title_style = table.clone(UIFontSettings.header_1)

title_style = table.merge(title_style, {
	text_horizontal_alignment = "center",
	text_vertical_alignment = "top",
})

local edge_padding = 20
local grid_width = 640
local grid_height = 680
local grid_size = { grid_width - edge_padding, grid_height }
local grid_spacing = { 0, 5 }
local mask_size = { grid_width + 40, grid_height }
local top_alignment = 310

local grid_settings = {
	grid_size = grid_size,
	grid_spacing = grid_spacing,
	mask_size = mask_size,
	title_height = 0,
	top_padding = 0,
	edge_padding = edge_padding,
	scrollbar_width = 16,
	scrollbar_horizontal_offset = 4,
	scrollbar_vertical_offset = 102,
	scrollbar_vertical_margin = 213,
	scroll_start_margin = 200,
	scrollbar_pass_templates = ScrollbarPassTemplates.metal_scrollbar,
	use_item_categories = false,
	use_select_on_focused = false,
	show_loading_overlay = false,
	widget_icon_load_margin = 0,
	use_is_focused_for_navigation = false,
	use_terminal_background = true,
}

local scenegraph_definition = {
	item_grid_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			grid_width,
			grid_height,
		},
		position = {
			100,
			top_alignment + 10,
			1,
		},
	},
	frame_top = {
		vertical_alignment = "top",
		parent = "item_grid_pivot",
		horizontal_alignment = "bottom",
		size = { 772, 552 },
		position = { -66, -top_alignment, 15 },
	},
	frame_bottom = {
		vertical_alignment = "bottom",
		parent = "item_grid_pivot",
		horizontal_alignment = "center",
		size = { 664, 54 },
		position = { 0, 10, 15 },
	},
	now_playing = {
		vertical_alignment = "top",
		parent = "item_grid_pivot",
		horizontal_alignment = "center",
		size = {
			530,
			200,
		},
		position = {
			0,
			-110,
			10,
		},
	},
	title_text = {
		vertical_alignment = "top",
		parent = "item_grid_pivot",
		horizontal_alignment = "left",
		size = {
			grid_size[1] + edge_padding,
			200,
		},
		position = {
			0,
			0,
			25,
		},
		offset = { 0, 15, 0 },
	},
	divider = {
		vertical_alignment = "bottom",
		parent = "title_text",
		horizontal_alignment = "left",
		size = {
			grid_size[1] + edge_padding,
			50,
		},
		position = {
			0,
			50,
			1,
		},
	},
}

local widget_definitions = {
	frame_top = UIWidget.create_definition({
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture",
			value = "content/ui/materials/frames/end_of_round/reward_random_item_upper",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				scale_to_material = true,
			},
		},
	}, "frame_top"),
	frame_bottom = UIWidget.create_definition({
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture_uv",
			value = "content/ui/materials/frames/end_of_round/reward_levelup_lower",

			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				scale_to_material = true,
				uvs = { { 0, 0.2 }, { 1, 1 } },
			},
		},
	}, "frame_bottom"),
	now_playing = UIWidget.create_definition({
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text",
			style = {
				font_size = 40,
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				drop_shadow = true,

				material = "content/ui/materials/font_gradients/slug_font_gradient_premium",
				font_type = "machine_medium",
				text_color = Color.white(255, true),
				offset = {
					0,
					0,
					25,
				},
			},
			value = music_tracks[mod.current_track].name,
		},
	}, "now_playing"),

	title_text = UIWidget.create_definition({
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text",
			style = title_style,
			value = Localize("loc_jukebox_high_gothic_name"),
		},
	}, "title_text"),
	divider = UIWidget.create_definition({
		{
			value = "content/ui/materials/dividers/skull_center_02",
			pass_type = "texture",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = Color.terminal_corner(255, true),
				size = {
					468,
					22,
				},
			},
		},
	}, "divider"),
}

local legend_inputs = {
	{
		input_action = "back",
		on_pressed_callback = "_on_back_pressed",
		display_name = "loc_class_selection_button_back",
		alignment = "left_alignment",
	},
	{
		input_action = "jukebox_previous",
		on_pressed_callback = "_on_previous_pressed",
		display_name = "loc_jukebox_previous",
		alignment = "center_alignment",
	},
	{
		input_action = "jukebox_play_stop",
		on_pressed_callback = "_on_play_stop_pressed",
		display_name = "loc_jukebox_play",
		alignment = "center_alignment",
		visibility_function = function()
			return not mod.playing
		end,
	},
	{
		input_action = "jukebox_play_stop",
		on_pressed_callback = "_on_play_stop_pressed",
		display_name = "loc_jukebox_stop",
		alignment = "center_alignment",
		visibility_function = function()
			return mod.playing
		end,
	},
	{
		input_action = "jukebox_next",
		on_pressed_callback = "_on_next_pressed",
		display_name = "loc_jukebox_next",
		alignment = "center_alignment",
	},
}

return {
	grid_settings = grid_settings,
	legend_inputs = legend_inputs,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
