local mod = get_mod("Jukebox")

local disco_ball = mod:persistent_table("disco_ball", {
	on = false,
})

local HUB_POSITION = Vector3Box(0, -116, 160)
local PSYKHANIUM_POSITION = Vector3Box(0, 0, 166)

local DISCO_COLOURS = {
	{ 180, 14, 127 },
	{ 200, 170, 70 },
	{ 29, 43, 185 },
	{ 50, 200, 50 },
}

local BPM = 120

local update_interval = 60 / BPM
local delta = 0
local colour_index = 1
local last_colour_index = 1

mod.disco_ball_alive = function()
	return disco_ball.unit and Unit.alive(disco_ball.unit)
end

mod.spawn_disco_ball = function()
	if mod.disco_ball_alive() then
		return
	end

	local mission_objective_zone_system = Managers.state.extension:system("mission_objective_zone_system")

	if not mission_objective_zone_system._servo_skull_unit then
		local game_mode = Managers.state.game_mode:game_mode_name()
		local spawn_position

		if game_mode == "hub" then
			spawn_position = Vector3Box.unbox(HUB_POSITION)
		elseif game_mode == "shooting_range" then
			spawn_position = Vector3Box.unbox(PSYKHANIUM_POSITION)
		else
			return
		end

		mission_objective_zone_system:spawn_servo_skull(
			spawn_position,
			Quaternion.from_elements(-math.sqrt(1), 0, 0, math.sqrt(1))
		)
	end

	disco_ball.unit = mission_objective_zone_system._servo_skull_unit
	disco_ball.light = Unit.light(disco_ball.unit, 1)

	Light.set_enabled(disco_ball.light, true)

	Light.set_intensity(disco_ball.light, 0.01)
	Light.set_falloff_start(disco_ball.light, 200)
	Light.set_falloff_end(disco_ball.light, 200)
	Light.set_spot_reflector(disco_ball.light, false)
	Light.set_casts_shadows(disco_ball.light, false)
	Light.set_spot_angle_start(disco_ball.light, -math.pi * 0.99)
	Light.set_spot_angle_end(disco_ball.light, math.pi * 0.99)
end

mod.disco_ball_enable = function()
	if not mod._settings.disco then
		return
	end

	disco_ball.on = true

	if mod.disco_ball_alive() then
		Light.set_intensity(disco_ball.light, 0.01)
	end
end

mod.disco_ball_disable = function()
	disco_ball.on = false

	if mod.disco_ball_alive() then
		Light.set_intensity(disco_ball.light, 0)
	end
end

mod.update_functions["disco_ball"] = function(dt)
	if not mod._settings.disco or not mod.disco_ball_alive() or not disco_ball.light or not disco_ball.on then
		return
	end

	if delta > update_interval then
		if #DISCO_COLOURS > 1 then
			repeat
				colour_index = math.random(1, #DISCO_COLOURS)
			until colour_index ~= last_colour_index
		else
			colour_index = 1
		end

		local color_filter =
			Vector3(DISCO_COLOURS[colour_index][1], DISCO_COLOURS[colour_index][2], DISCO_COLOURS[colour_index][3])

		Light.set_color_filter(disco_ball.light, color_filter)

		last_colour_index = colour_index
		delta = 0
	else
		delta = delta + dt
	end
end

mod.despawn_disco_ball = function()
	local mission_objective_zone_system = Managers.state.extension:system("mission_objective_zone_system")

	mission_objective_zone_system:_unregister_servo_skull()

	disco_ball = {
		on = false,
		light = nil,
	}
end
