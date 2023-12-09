local mod = get_mod("JukeboxOld")

local INTERVAL = 0.5
local delta = 0
local dance_emote_slot

mod.dancing = false

mod.dance = function(dancing)
	if dancing == false then
		mod.dancing = false
		delta = 0

		return
	end

	for slot, data in pairs(Managers.player:local_player_safe(1)._profile.loadout_item_data) do
		if
			data.id == "content/items/animations/emotes/emote_human_personality_006_squat_01"
			or data.id == "content/items/animations/emotes/emote_ogryn_affirmative_006_thumbs_up_02"
		then
			dance_emote_slot = slot
		end
	end

	if dance_emote_slot then
		mod.dancing = true
	end
end

mod.update_functions["dance"] = function(dt)
	if mod._settings.dance and mod.dancing then
		local player_unit = Managers.player:local_player_safe(1).player_unit
		local input_extension = ScriptUnit.extension(player_unit, "input_system")

		if not player_unit or not input_extension then
			return
		end

		local move = input_extension:get("move")
		local movement = Vector3.length_squared(move)

		if move and movement and movement > 0 then
			mod.dancing = false
			delta = 0
			return
		end

		if delta > INTERVAL then
			Managers.state.emote:trigger_emote(player_unit, dance_emote_slot)
			delta = 0
		else
			delta = delta + dt
		end
	end
end
