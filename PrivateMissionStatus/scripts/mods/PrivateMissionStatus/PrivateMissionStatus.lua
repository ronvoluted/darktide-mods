local mod = get_mod("PrivateMissionStatus")

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

local UIWidget = require("scripts/managers/ui/ui_widget")

mod:hook_safe(PartyImmateriumManager, "update", function(self)
	if not mod.PartyImmateriumManager then
		mod.PartyImmateriumManager = self
	end
end)

mod:hook_require("scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay_definitions", function(overlay)
	local mission_info_size = { 550, 160 }

	overlay.left_panel_widgets_definitions.mission_info = UIWidget.create_definition({
		{
			value = "content/ui/materials/icons/generic/danger",
			value_id = "icon",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = Color.terminal_text_header(255, true),
				offset = { 0, 25, 2 },
				size = { 60, 60 },
			},
		},
		{
			style_id = "mission_name",
			value_id = "mission_name",
			pass_type = "text",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				text_vertical_alignment = "top",
				font_size = 34,
				text_horizontal_alignment = "left",
				offset = { 65, 15, 10 },
				size = { mission_info_size[1] + 100, 50 },
				text_color = { 255, 169, 191, 153 },
			},
		},
		{
			style_id = "mission_type",
			value_id = "mission_type",
			pass_type = "text",
			style = {
				vertical_alignment = "bottom",
				text_vertical_alignment = "top",
				horizontal_alignment = "center",
				text_horizontal_alignment = "left",
				offset = { 65, 0, 10 },
				size = { mission_info_size[1], 50 },
				text_color = { 255, 169, 191, 153 },
			},
		},
		{
			value = "content/ui/materials/hud/communication_wheel/icons/attention",
			value_id = "mission_status_icon",
			style_id = "mission_status_icon",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = Color.terminal_text_body(255, true),
				offset = { -7.5, -115, 2 },
				size = { 75, 75 },
			},
		},
		{
			value_id = "mission_status_text",
			style_id = "mission_status_text",
			pass_type = "text",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				offset = { 65, -115, 10 },
				size = { 120, 40 },
				text_color = Color.terminal_text_body(255, true),
			},
		},
	}, "mission_info_panel")
end)

mod:hook_safe("HudElementTacticalOverlay", "update", function(self)
	if self._active then
		local private_mission

		if Managers.multiplayer_session:host_type() == "singleplay" then
			private_mission = true
		else
			-- private_mission = mod.PartyImmateriumManager:is_in_private_session()
			private_mission = Managers.party_immaterium:is_in_private_session()
		end

		if type(mod.private_mission) == "boolean" and mod.private_mission == private_mission then
			return
		end

		local mission_info = self._widgets_by_name.mission_info

		if private_mission then
			mission_info.content.mission_status_text = string.format("[%s]", mod:localize("private"))
			mission_info.content.mission_status_icon = "content/ui/materials/icons/circumstances/ventilation_purge_01"
			mission_info.style.mission_status_icon.size = { 60, 60 }
			mission_info.style.mission_status_icon.offset = { 0, -115, 2 }
		else
			mission_info.content.mission_status_text = string.format("[%s]", mod:localize("public"))
			mission_info.content.mission_status_icon = "content/ui/materials/hud/communication_wheel/icons/attention"
			mission_info.style.mission_status_icon.size = { 75, 75 }
			mission_info.style.mission_status_icon.offset = { -7.5, -115, 2 }
		end

		mod.private_mission = private_mission
	end
end)
