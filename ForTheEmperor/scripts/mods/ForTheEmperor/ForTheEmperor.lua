local mod = get_mod("ForTheEmperor")

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

local VOQueryConstants = require("scripts/settings/dialogue/vo_query_constants")
local wheel_position = mod:get("wheel_position")
local LEFT_POSITION = 7
local RIGHT_POSITION = 3

mod:hook(LocalizationManager, "localize", function(fun, self, key, no_cache, context)
	self._string_cache.loc_for_the_emperor = mod:localize("mod_title")

	return fun(self, key, no_cache, context)
end)

mod:hook("HudElementSmartTagging", "_populate_wheel", function(fun, self, options)
	if not options[LEFT_POSITION] and not options[RIGHT_POSITION] then
		options[wheel_position == "left" and LEFT_POSITION or RIGHT_POSITION] = {
			icon = "content/ui/materials/icons/system/escape/achievements",
			display_name = "loc_for_the_emperor",
			voice_event_data = {
				voice_tag_concept = VOQueryConstants.concepts.on_demand_com_wheel,
				voice_tag_id = VOQueryConstants.trigger_ids.com_wheel_vo_for_the_emperor,
			},
		}

		mod.wheel_options = options
	end

	fun(self, options)
end)

mod:hook_safe("HudElementSmartTagging", "update", function(self)
	if mod.setting_dirty then
		self:_populate_wheel(mod.wheel_options)

		mod.setting_dirty = false
	end
end)

mod.on_setting_changed = function(setting)
	if setting == "wheel_position" then
		wheel_position = mod:get(setting)

		if wheel_position == "left" then
			mod.wheel_options[LEFT_POSITION] = mod.wheel_options[RIGHT_POSITION]
			mod.wheel_options[RIGHT_POSITION] = nil
		elseif wheel_position == "right" then
			mod.wheel_options[RIGHT_POSITION] = mod.wheel_options[LEFT_POSITION]
			mod.wheel_options[LEFT_POSITION] = nil
		end

		mod.setting_dirty = true
	end
end
