local mod = get_mod("ToggleHUD")

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

local ui = Managers.ui

local hud = mod:persistent_table("hud")

mod.toggle_on_hold = mod:get("toggle_on_hold")
mod.enable_command = mod:get("enable_command")
mod.held = false

mod.toggle = function(set_visible)
	if ui._hud and set_visible ~= true then
		local player = Managers.player:local_player(1)

		hud.hud_peer_id = player:peer_id()
		hud.hud_local_player_id = player:local_player_id()
		hud.hud_elements = ui._hud._element_definitions
		hud.hud_visibility_groups = ui._hud._visibility_groups
		ui:destroy_player_hud()
	elseif set_visible ~= false then
		ui:create_player_hud(hud.hud_peer_id, hud.hud_local_player_id, hud.hud_elements, hud.hud_visibility_groups)
	end
end

mod.handle_keybind_toggle = function()
	if mod.toggle_on_hold then
		mod.toggle(mod.held)
	elseif mod.held then
		mod.toggle()
	end

	mod.held = not mod.held
end

mod.on_setting_changed = function(changed_setting)
	if changed_setting == "toggle_on_hold" then
		mod.toggle_on_hold = mod:get("toggle_on_hold")
		mod.held = false
	end

	if changed_setting == "enable_command" then
		mod.enable_command = mod:get("enable_command")

		if mod.enable_command then
			mod:command_enable("hud")
		else
			mod:command_disable("hud")
		end
	end
end

mod:command("hud", "Toggle HUD", function()
	mod.toggle()
end)

if not mod.enable_command then
	mod:command_disable("hud")
end
