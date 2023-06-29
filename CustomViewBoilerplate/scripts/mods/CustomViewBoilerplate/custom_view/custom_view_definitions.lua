local scenegraph_definition = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080,
		},
	},
	canvas = {
		parent = "screen",
		horizontal_alignment = "center",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			0,
		},
	},
}

local widget_definitions = {}

local legend_inputs = {
	{
		input_action = "back",
		on_pressed_callback = "_on_back_pressed",
		display_name = "loc_class_selection_button_back",
		alignment = "left_alignment",
	},
}

return {
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	legend_inputs = legend_inputs,
}
