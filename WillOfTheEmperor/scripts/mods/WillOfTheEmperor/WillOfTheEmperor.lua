local mod = get_mod("WillOfTheEmperor")
local SoloPlay = get_mod("SoloPlay")

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

mod:io_dofile("WillOfTheEmperor/scripts/mods/WillOfTheEmperor/modules/bestowments")
mod:io_dofile("WillOfTheEmperor/scripts/mods/WillOfTheEmperor/modules/constants")
mod:io_dofile("WillOfTheEmperor/scripts/mods/WillOfTheEmperor/modules/time_scale")

mod.apply_constants()

local update_delta = 0

mod.is_client_map = function()
	local game_mode = Managers.state and Managers.state.game_mode and Managers.state.game_mode:game_mode_name()

	if not game_mode then
		return false
	end

	Managers.state.game_mode:game_mode_name()
	return (game_mode == "shooting_range" or game_mode == "prologue_hub" or SoloPlay.is_soloplay()),
		game_mode == "shooting_range",
		game_mode == "prologue_hub",
		SoloPlay.is_soloplay()
end

mod.update = function(dt)
	local is_client_map, is_shooting_range = mod.is_client_map()

	if not is_client_map or Managers.ui:get_current_sub_state_name() ~= "GameplayStateRun" then
		return
	end

	if not Managers.player:local_player_safe(1).player_unit then
		return
	end

	if mod._settings.god_emperor_mode then
		mod.god_emperor_mode(true)
	else
		mod.god_emperor_mode(false)
	end

	if mod._settings.disable_enemy_spawns then
		mod.disable_enemy_spawns()

		Managers.state.pacing._disabled = true
	elseif not is_shooting_range then
		Managers.state.pacing._disabled = false
	end

	if mod._settings.infinite_ammunition then
		mod.infinite_ammunition()
	end

	if mod._settings.no_reloading then
		mod.no_reloading()
	end

	if update_delta < 1 then
		update_delta = update_delta + dt
		return
	else
		update_delta = 0
	end

	if mod._settings.invisibility then
		if not mod.has_invisibility() then
			mod.set_invisibility(true)
		end
	elseif mod.has_invisibility() then
		mod.set_invisibility(false)
	end

	if mod._settings.fervency_mode then
		mod.fervency_mode()
	end

	if mod._settings.rapid_ability_cooldowns then
		if not mod.cooldowns_quickened() then
			mod.rapid_ability_cooldowns(true)
		end
	elseif mod.cooldowns_quickened() then
		mod.rapid_ability_cooldowns(false)
	end
end

mod.on_game_state_changed = function(status, state_name)
	if not (Managers.state and Managers.state.game_mode) then
		return
	end

	local game_mode = Managers.state.game_mode:game_mode_name()

	if status == "enter" and state_name == "GameplayStateRun" then
		if game_mode == "coop_complete_objective" then
			mod.set_invisibility(false)
		end
	end

	if status == "exit" then
		if game_mode == "coop_complete_objective" then
			mod.set_invisibility(false)
		end
	end
end

mod.on_setting_changed = function(changed_setting)
	mod._settings[changed_setting] = mod:get(changed_setting)

	mod.apply_constants()
end

if mod:get("reset_sliders_on_reload") then
	mod:set("move_speed", 4)
	mod:set("gravity", 11.82)
end
