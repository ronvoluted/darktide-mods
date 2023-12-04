local mod = get_mod("ScrubsVermin")

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

mod.all_mods_loaded_functions = {}
mod.show_scrubsvermin = false
local PASS_CLASS = "ScrubsVermin"
local PASS_PATH = "ScrubsVermin/scripts/mods/ScrubsVermin/modules/scrubsvermin_pass"

mod:io_dofile("ScrubsVermin/scripts/mods/ScrubsVermin/modules/texture_loading")
mod:add_require_path(PASS_PATH)

mod:hook("UIHud", "init", function(func, self, elements, visibility_groups, params)
	if not table.find_by_key(elements, "class_name", PASS_CLASS) then
		table.insert(elements, {
			class_name = PASS_CLASS,
			filename = PASS_PATH,
			use_hud_scale = true,
			visibility_groups = { "alive" },
		})
	end

	return func(self, elements, visibility_groups, params)
end)

mod.on_all_mods_loaded = function()
	mod.DLS = get_mod("DarktideLocalServer")

	if not mod.DLS then
		mod:echo(
			'Required mod "Darktide Local Server" not found: Download from Nexus Mods and make sure "DarktideLocalServer" is in mod_load_order.txt'
		)

		mod:disable_all_hooks()
		mod:disable_all_commands()

		return
	end

	for _, fun in pairs(mod.all_mods_loaded_functions) do
		fun()
	end
end

mod.on_game_state_changed = function(state, sub_state_name)
	if state == "exit" and sub_state_name == "GameplayStateRun" then
		mod.show_scrubsvermin = false
	end
end

mod.on_unload = function()
	mod.show_scrubsvermin = false
end

mod:command("scrubsvermin", "He's going to be trouble...", function()
	if not mod.show_scrubsvermin then
		if mod.frames_status.loaded then
			mod.show_scrubsvermin = true
		else
			mod.load_textures():next(function()
				mod.show_scrubsvermin = true
			end)
		end
	else
		mod.show_scrubsvermin = false
	end
end)
