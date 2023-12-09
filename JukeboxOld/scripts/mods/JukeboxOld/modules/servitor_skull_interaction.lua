local mod = get_mod("JukeboxOld")

require("scripts/extension_systems/interaction/interactions/base_interaction")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local ServitorSkullInteraction = class("ServitorSkullInteraction", "BaseInteraction")

ServitorSkullInteraction.init = function(self, template)
	self._template = template
end

ServitorSkullInteraction.start = function(self, world, interactor_unit, unit_data_component, t, interactor_is_server)
	return
end

ServitorSkullInteraction.stop = function(
	self,
	world,
	interactor_unit,
	unit_data_component,
	t,
	result,
	interactor_is_server
)
	mod._open_jukebox()
end

ServitorSkullInteraction.interactor_condition_func = function(self, interactor_unit, interactee_unit)
	return true
end

ServitorSkullInteraction.interactee_condition_func = function(self, interactee_unit)
	return true
end

ServitorSkullInteraction.interactee_show_marker_func = function(self, interactor_unit, interactee_unit)
	return true
end

ServitorSkullInteraction.hud_description = function(self, interactor_unit, interactee_unit, target_node)
	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")

	return interactee_extension:description()
end

ServitorSkullInteraction.hud_block_text = function(self, interactor_unit, interactee_unit, target_node)
	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")

	return interactee_extension:block_text()
end

ServitorSkullInteraction.marker_offset = function(self)
	return nil
end

ServitorSkullInteraction.type = function(self)
	return self._template.type
end

ServitorSkullInteraction.duration = function(self)
	return self._template.duration
end

ServitorSkullInteraction.ui_interaction_type = function(self)
	return self._template.ui_interaction_type
end

ServitorSkullInteraction.interaction_icon = function(self)
	return self._template.interaction_icon
end

ServitorSkullInteraction.description = function(self)
	return self._template.description
end

ServitorSkullInteraction.action_text = function(self)
	return self._template.action_text
end

ServitorSkullInteraction.ui_view_name = function(self)
	return self._template.ui_view_name
end

ServitorSkullInteraction.only_once = function(self)
	return self._template.only_once
end

ServitorSkullInteraction._interactor_disabled = function(self, interactor_unit)
	local unit_data_extension = ScriptUnit.extension(interactor_unit, "unit_data_system")
	local character_state_component = unit_data_extension:read_component("character_state")

	return PlayerUnitStatus.is_disabled(character_state_component)
end

return ServitorSkullInteraction
