local mod = get_mod("ScrubsVermin")

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ScrubsVermin = class("ScrubsVermin", "HudElementBase")

local TWO_PI = math.two_pi
local FRAME_SIZE = { 1520, 1250 }
local SPINNER_SIZE = { 50, 50 }
local SIZE_FACTOR = 0.85
FRAME_SIZE[1], FRAME_SIZE[2] = FRAME_SIZE[1] * SIZE_FACTOR, FRAME_SIZE[2] * SIZE_FACTOR
local FRAME_RATE = 48
local frame_interval = 1 / FRAME_RATE
local frame_index = 1
local delta = 0

local spinner_texture
local scrubsvermin_frames

ScrubsVermin.init = function(self, parent, draw_layer, start_scale)
	ScrubsVermin.super.init(self, parent, draw_layer, start_scale, {
		scenegraph_definition = {
			screen = UIWorkspaceSettings.screen,
			scrubsvermin_anchor = {
				parent = "screen",
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				position = { -FRAME_SIZE[1] / 2, -FRAME_SIZE[2], 0 },
				size = { 0, 0 },
			},
		},
		widget_definitions = {
			scrubsvermin_widget = UIWidget.create_definition({
				{
					pass_type = "texture",
					style_id = "scrubsvermin_frames",
					style = {
						size = FRAME_SIZE,
						visible = false,
					},
				},
			}, "scrubsvermin_anchor"),
			spinner_widget = UIWidget.create_definition({
				{
					pass_type = "rotated_texture",
					style_id = "spinner_texture",
					value = "content/ui/materials/loading/loading_small",

					style = {
						size = SPINNER_SIZE,
						horizontal_alignment = "center",
						vertical_alignment = "center",
						angle = 0,
						visible = false,
					},
				},
			}, "screen"),
		},
	})

	spinner_texture = self._widgets_by_name.spinner_widget.style.spinner_texture
	scrubsvermin_frames = self._widgets_by_name.scrubsvermin_widget.style.scrubsvermin_frames
end

ScrubsVermin.update = function(self, dt, t, ui_renderer, render_settings, input_service)
	ScrubsVermin.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	if mod.frames_status.loading then
		spinner_texture.visible = true
		spinner_texture.angle = spinner_texture.angle - dt * 10

		if spinner_texture.angle <= -TWO_PI then
			spinner_texture.angle = 0
		end

		return
	else
		spinner_texture.visible = false
	end

	if not mod.show_scrubsvermin then
		if #mod.frames then
			scrubsvermin_frames.visible = false
		end

		return
	end

	if not scrubsvermin_frames.material_values then
		scrubsvermin_frames.material_values = {}
		delta = frame_interval
	end

	if scrubsvermin_frames.color then
		scrubsvermin_frames.visible = true
	end

	if delta >= frame_interval then
		scrubsvermin_frames.material_values.texture_map = mod.frames[frame_index]

		frame_index = frame_index < mod.frame_count and frame_index + 1 or 1

		delta = 0
	else
		delta = delta + dt
	end
end

return ScrubsVermin
