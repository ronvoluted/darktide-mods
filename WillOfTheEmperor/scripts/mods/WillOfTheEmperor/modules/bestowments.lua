local mod = get_mod("WillOfTheEmperor")

local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")

mod.buff_indices = mod:persistent_table("original_player_abilities", {})
local original_player_abilities = mod:persistent_table("original_player_abilities", {})
local player_abilities

local COMBAT_ABILITY_NAMES = {
	"base_combat_attack",
	"base_invisibility",
	"base_shout",
	"ogryn_charge",
	"ogryn_charge_bleed",
	"ogryn_charge_damage",
	"ogryn_charge_cooldown_reduction",
	"ogryn_charge_increased_distance",
	"psyker_discharge_shout",
	"psyker_psychic_fortress",
	"psyker_psychic_fortress_duration_increased",
	"veteran_ranger_ranged_stance",
	"veteran_ranger_ranged_stance_big_game_hunter",
	"veteran_ranger_ranged_stance_headhunter",
	"veteran_ranger_ranged_stance_rending",
	"veteran_ranger_ranged_stance_weapon_handling_improved",
	"zealot_dash",
	"zealot_maniac_targeted_dash",
	"zealot_maniac_targeted_dash_improved",
	"zealot_targeted_dash",
}

local RAPID_COOLDOWN_TIME = 1

mod.god_emperor_mode = function(invincible)
	local player_unit = Managers.player:local_player_safe(1).player_unit

	local health_extension = ScriptUnit.has_extension(player_unit, "health_system")
	local toughness_extension = ScriptUnit.has_extension(player_unit, "toughness_system")

	if invincible then
		toughness_extension._toughness_damage = 0

		if not health_extension:is_invulnerable() then
			health_extension:set_invulnerable(true)
		end
	else
		if health_extension:is_invulnerable() then
			health_extension:set_invulnerable(false)
		end
	end
end

mod.fervency_mode = function()
	local player_unit = Managers.player:local_player_safe(1).player_unit

	local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")
	local character_state_component = unit_data_extension and unit_data_extension:read_component("character_state")
	local assisted_state_input_component = unit_data_extension:write_component("assisted_state_input")

	if PlayerUnitStatus.is_knocked_down(character_state_component) then
		assisted_state_input_component.force_assist = true
	end
end

mod.disable_enemy_spawns = function()
	if not (Managers.state and Managers.state.minion_spawn) then
		return
	end

	Managers.state.minion_spawn:despawn_all_minions()
end

mod.set_invisibility = function(invisibility)
	local player_unit = Managers.player:local_player_safe(1).player_unit
	local player_buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

	if not player_buff_extension then
		return
	end

	local buff_name = "will_of_the_emperor_invisibility"

	if invisibility then
		local buff_index = player_buff_extension:_add_buff({
			name = buff_name,
			class_name = "buff",
			keywords = { "unperceivable" },
		}, Managers.time:time("main"))

		mod.buff_indices[#mod.buff_indices + 1] = buff_index
	else
		for i, buff_index in ipairs(mod.buff_indices) do
			local buff = player_buff_extension._buffs_by_index[buff_index]

			if buff and buff:template_name() == buff_name then
				player_buff_extension:_remove_buff(buff_index)
			end

			mod.buff_indices[i] = nil
		end
	end
end

mod.has_invisibility = function()
	return #mod.buff_indices > 0
end

mod.rapid_ability_cooldowns = function(quick)
	if quick then
		for _, ability in pairs(COMBAT_ABILITY_NAMES) do
			player_abilities[ability].cooldown = RAPID_COOLDOWN_TIME
		end
	else
		for _, ability in pairs(COMBAT_ABILITY_NAMES) do
			player_abilities[ability].cooldown = original_player_abilities[ability].cooldown
		end
	end
end

mod.cooldowns_quickened = function()
	return player_abilities.base_combat_attack.cooldown == RAPID_COOLDOWN_TIME
end

mod.infinite_ammunition = function()
	local player_unit = Managers.player:local_player_safe(1).player_unit

	local player_unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

	local ammo = player_unit_data_extension._components.slot_secondary[1]

	if ammo.current_ammunition_reserve < ammo.max_ammunition_reserve then
		ammo.current_ammunition_reserve = ammo.max_ammunition_reserve
	end
end

local previous_clip

mod.no_reloading = function()
	local player_unit = Managers.player:local_player_safe(1).player_unit

	local player_unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

	local ammo = player_unit_data_extension._components.slot_secondary[1]

	if not previous_clip then
		previous_clip = ammo.current_ammunition_clip
	end

	if ammo.current_ammunition_reserve <= 0 then
		return
	end

	local clip_change = ammo.current_ammunition_clip - previous_clip
	local is_reload = clip_change > 0

	if is_reload then
		return
	end

	ammo.current_ammunition_reserve = ammo.current_ammunition_reserve + clip_change

	local rounds_in_chamber_setting = mod._settings.rounds_in_chamber
	local rounds_in_chamber

	if rounds_in_chamber_setting > 0 then -- rounds remaining
		rounds_in_chamber = rounds_in_chamber_setting
	else -- rounds less than full
		rounds_in_chamber = ammo.max_ammunition_clip + rounds_in_chamber_setting
	end

	ammo.current_ammunition_clip = rounds_in_chamber

	previous_clip = ammo.current_ammunition_clip
end

mod:hook("PlayerUnitHealthExtension", "max_wounds", function(fun, self)
	if mod._settings.fervency_mode then
		return 10
	else
		return fun(self)
	end
end)

mod:hook_require("scripts/settings/ability/player_abilities/player_abilities", function(_player_abilities)
	original_player_abilities = table.clone(_player_abilities)
	table.set_readonly(original_player_abilities)

	player_abilities = _player_abilities
end)
