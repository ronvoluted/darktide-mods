local mod = get_mod("WillOfTheEmperor")

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local damage_types = DamageSettings.damage_types

local EXPLODE_RADIUS = 100
local EXPLODE_INTERVAL = 0.1

local EXPLOSION_TEMPLATE = {
	damage_falloff = true,
	radius = 10,
	min_radius = 10,
	scalable_radius = true,
	close_radius = 2,
	static_power_level = 1000,
	min_close_radius = 2,
	close_damage_profile = DamageProfileTemplates.close_frag_grenade,
	close_damage_type = damage_types.grenade_frag,
	damage_profile = DamageProfileTemplates.frag_grenade,
	damage_type = damage_types.grenade_frag,
	explosion_area_suppression = {
		suppression_falloff = true,
		instant_aggro = true,
		distance = 15,
		suppression_value = 20,
	},
	scalable_vfx = {
		{
			radius_variable_name = "radius",
			min_radius = 5,
			effects = {
				"content/fx/particles/explosions/frag_grenade_01",
				"content/fx/particles/weapons/force_staff/force_staff_explosion",
				"content/fx/particles/destructibles/explosive_barrel_explosion",
			},
		},
	},
	sfx = {
		"wwise/events/weapon/play_explosion_grenade_frag",
		"wwise/events/weapon/play_explosion_refl_gen",
	},
}

local DAMAGE_PROFILE = {
	armor_damage_modifier = {
		attack = {
			armored = 1,
			berserker = 1,
			disgustingly_resilient = 1,
			player = 1,
			prop_armor = 1,
			resistant = 1,
			super_armor = 1,
			unarmored = 1,
			void_shield = 1,
		},
		impact = {
			armored = 10,
			berserker = 10,
			disgustingly_resilient = 10,
			player = 10,
			prop_armor = 10,
			resistant = 10,
			super_armor = 10,
			unarmored = 10,
			void_shield = 10,
		},
	},
	cleave_distribution = {
		attack = 1,
		impact = 1,
	},
	damage_type = "grenade_frag",
	gibbing_power = 10,
	gibbing_type = "explosion",
	ignore_stagger_reduction = true,
	name = "close_frag_grenade",
	power_distribution = {
		attack = 1000,
		impact = 1000,
	},
	ragdoll_push_force = 1000,
	stagger_category = "explosion",
	suppression_value = 10,
	targets = {
		default_target = {
			boost_curve = { 0, 0.3, 0.6, 0.8, 1 },
		},
	},
}

mod.enemies_to_explode = {}
mod.explosions = {}
mod.explosion_cooldown = 0

mod.spawn_explosion = function(unit)
	if not Unit.alive(unit) or not BLACKBOARDS[unit] then
		return
	end

	local player_unit = Managers.player:local_player_safe(1).player_unit
	local world = Managers.world:world("level_world")
	local physics_world = World.get_data(world, "physics_world")
	local position = Unit.local_position(unit, 1)

	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

	local direction = Vector3(math.random(-2, 2), math.random(-2, 2), 3)

	Managers.state.minion_death:die(unit, player_unit, direction, "center_mass", DAMAGE_PROFILE, "explosion")

	if visual_loadout_extension:can_gib("center_mass") then
		visual_loadout_extension:gib("center_mass", direction, DAMAGE_PROFILE)
	end

	Explosion.create_explosion(
		world,
		physics_world,
		position,
		Vector3.down(),
		unit,
		EXPLOSION_TEMPLATE,
		1000,
		100,
		"explosion"
	)
end

mod.explosion_update = function()
	for k, enemy in pairs(mod.enemies_to_explode) do
		if os.clock() > enemy.scheduled_time then
			mod.spawn_explosion(enemy.unit)

			mod.enemies_to_explode[k] = nil
		end
	end
end

mod.explode_enemies = function()
	if #mod.enemies_to_explode > 0 or #mod.explosions > 0 or os.clock() <= mod.explosion_cooldown then
		return
	end

	mod.explosion_cooldown = os.clock() + #mod.enemies_to_explode * EXPLODE_INTERVAL

	local player_unit = Managers.player:local_player_safe(1).player_unit
	local player_position = Unit.local_position(player_unit, 1)
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[player_unit]
	local enemy_side_names = side:relation_side_names("enemy")

	local units = {}

	broadphase_system.broadphase:query(player_position, EXPLODE_RADIUS, units, enemy_side_names)

	for i, unit in ipairs(units) do
		if Unit.alive(unit) then
			mod.enemies_to_explode[#mod.enemies_to_explode + 1] = {
				unit = unit,
				scheduled_time = os.clock() + (EXPLODE_INTERVAL * i),
			}
		end
	end
end

mod:command("explode_enemies", "Explode your enemies", function()
	mod.explode_enemies()
end)
