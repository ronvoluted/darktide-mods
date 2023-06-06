local mod = get_mod("WillOfTheEmperor")

mod.debug_knock_down = function()
	local player_unit = Managers.player:local_player_safe(1).player_unit

	PlayerDeath.knock_down(player_unit)
end

mod:command("debug_knock_down", "Knock down player", function()
	mod.debug_knock_down()
end)

mod.setup = function()
	-- Load Psykhanium
	-- Teleport to center
	-- Despawn all enemies
end

for i, test in pairs(mod.tests) do
	test()
end
