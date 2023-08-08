local mod = get_mod("WillOfTheEmperor")

--[[
	Applies a patch so that "MinionRagdoll._update_delayed_ragdoll_push_cache.lua"
	does not crash when `push_force_data` is nil, which can occur due to the rapid
	succession of ragdolls.
]]

mod:hook(MinionRagdoll, "_update_delayed_ragdoll_push_cache", function(fun, self)
	local delayed_ragdoll_push_cache = self._delayed_ragdoll_push_cache
	local index = 1

	while index <= self._delayed_ragdoll_push_index do
		local data = delayed_ragdoll_push_cache[index]
		local unit = data.unit
		local attack_direction = data.attack_direction:unbox()
		local push_force = data.push_force
		local push_force_data = data.push_force_data
		local added_force = false

		-- [[ BEGIN PATCH ]]
		if not push_force_data then
			push_force_data = {}
		end
		-- [[ END PATCH ]]

		for actor_name, force_scale in pairs(push_force_data) do
			local actor = Unit.actor(unit, actor_name)

			if actor then
				local force = push_force * force_scale

				Actor.add_impulse(actor, attack_direction * force)

				added_force = true
			end
		end

		if added_force then
			self:_clear_delayed_ragdoll_push_entry(index)
		else
			index = index + 1
		end
	end
end)
