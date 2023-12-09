local mod = get_mod("JukeboxOld")

local ServitorSkullInteraction = mod:io_dofile("JukeboxOld/scripts/mods/JukeboxOld/modules/servitor_skull_interaction")

local servitor = mod:persistent_table("servitor")

local init = function()
	mod:hook_require("scripts/settings/interaction/interactions", function(interactions)
		interactions.jukebox = ServitorSkullInteraction
	end)

	mod:hook_require("scripts/settings/interaction/interaction_templates", function(templates)
		templates.jukebox = {
			type = "jukebox",
			ui_interaction_type = "point_of_interest",
			interaction_class_name = "jukebox",
			action_text = "loc_jukebox_insert_credit",
			description = "loc_jukebox_high_gothic_name",
			interaction_icon = "content/ui/materials/icons/pickups/default",
			duration = 0,
		}
	end)

	mod.initialised = true
end

local HUB_POSITION = Vector3Box(4.1, -112.1, 101.6)
local HUB_ROTATION = QuaternionBox(0, 0, -0.382355, -0.924016)
local PSYKHANIUM_POSITION = Vector3Box(4.7515, 0, 1.6)
local PSYKHANIUM_ROTATION = QuaternionBox(0, 0, -0.686882, -0.726769)

mod.spawn_servitor = function()
	if not mod.initialised then
		init()
	end

	if servitor.handler and servitor.handler:unit() and Unit.alive(servitor.handler:unit()) then
		return
	end

	local scenario_system = Managers.state.extension:system("scripted_scenario_system")
	servitor.handler = scenario_system:servitor_handler()

	local game_mode = Managers.state.game_mode:game_mode_name()

	if game_mode == "hub" then
		mod.servitor_unit = servitor.handler:spawn_servitor(HUB_POSITION:unbox(), HUB_ROTATION:unbox())
	elseif game_mode == "shooting_range" then
		mod.servitor_unit = servitor.handler:spawn_servitor(PSYKHANIUM_POSITION:unbox(), PSYKHANIUM_ROTATION:unbox())
	else
		return
	end

	servitor.handler._rotation_speed = 1
	servitor.handler._speed = 3

	local interactee_extension = servitor.handler:interactee_extension()

	interactee_extension:set_interaction_context("jukebox", {}, true)

	local forward_light = Unit.light(servitor.handler:unit(), 1)
	local down_light = Unit.light(servitor.handler:unit(), 2)

	Light.set_enabled(forward_light, false)
	Light.set_enabled(down_light, false)
end
