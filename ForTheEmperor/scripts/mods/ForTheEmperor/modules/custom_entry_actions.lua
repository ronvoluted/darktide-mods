local mod = get_mod("ForTheEmperor")

mod.last_wheel_message = {}

mod.send_wheel_message = function(message, cooldown, metadata_string)
	if Managers.state.game_mode:game_mode_name() ~= "coop_complete_objective" then
		return
	end

	cooldown = cooldown or 15

	if mod.last_wheel_message[message] and os.clock() - mod.last_wheel_message[message] < cooldown then
		return
	end

	local formatted_message = string.format("{#color(79,175,255)} %s {#reset()}{#%s}", message, metadata_string)
	local sessionId = next(Managers.chat:sessions())

	Managers.chat:send_channel_message(sessionId, formatted_message)

	mod.last_wheel_message[message] = os.clock()
end

mod:hook_safe(
	"HudElementSmartTagging",
	"_on_com_wheel_stop_callback",
	function(self, t, ui_renderer, render_settings, input_service)
		if self.destroyed then
			return
		end

		local wheel_active = self._wheel_active
		local wheel_hovered_entry = wheel_active and self:_is_wheel_entry_hovered(t)

		if wheel_hovered_entry then
			local option = wheel_hovered_entry.option

			if option.display_name == "loc_communication_wheel_need_help" then
				mod.need_help(10)
			elseif option.display_name == "loc_social_menu_confirmation_popup_confirm_button" then
				mod.send_wheel_message(Localize(option.display_name), 5)
			elseif option.display_name == "loc_social_menu_confirmation_popup_decline_button" then
				mod.send_wheel_message(Localize(option.display_name), 5)
			end
		end
	end
)
