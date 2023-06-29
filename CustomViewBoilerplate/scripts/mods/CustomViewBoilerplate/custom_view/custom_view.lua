local mod = get_mod("CustomViewBoilerplate")

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

local ScriptWorld = require("scripts/foundation/utilities/script_world")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")

local definitions =
	mod:io_dofile("CustomViewBoilerplate/scripts/mods/CustomViewBoilerplate/custom_view/custom_view_definitions")

CustomView = class("CustomView", "BaseView")

CustomView.init = function(self, settings)
	CustomView.super.init(self, definitions, settings)
end

CustomView.on_enter = function(self)
	CustomView.super.on_enter(self)

	self:_setup_input_legend()
end

CustomView._setup_input_legend = function(self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)
	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback
			and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(
			legend_input.display_name,
			legend_input.input_action,
			legend_input.visibility_function,
			on_pressed_callback,
			legend_input.alignment
		)
	end
end

CustomView._on_back_pressed = function(self)
	Managers.ui:close_view(self.view_name)
end

CustomView._destroy_renderer = function(self)
	if self._offscreen_renderer then
		self._offscreen_renderer = nil
	end

	local world_data = self._offscreen_world

	if world_data then
		Managers.ui:destroy_renderer(world_data.renderer_name)
		ScriptWorld.destroy_viewport(world_data.world, world_data.viewport_name)
		Managers.ui:destroy_world(world_data.world)

		world_data = nil
	end
end

CustomView.update = function(self, dt, t, input_service)
	return CustomView.super.update(self, dt, t, input_service)
end

CustomView.draw = function(self, dt, t, input_service, layer)
	CustomView.super.draw(self, dt, t, input_service, layer)
end

CustomView._draw_widgets = function(self, dt, t, input_service, ui_renderer, render_settings)
	CustomView.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

CustomView.on_exit = function(self)
	CustomView.super.on_exit(self)

	self:_destroy_renderer()
end

return CustomView
