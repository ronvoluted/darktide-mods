local mod = get_mod("Coal")

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

local DLS = get_mod("DarktideLocalServer")

local material_slots_to_texture_objects = mod:persistent_table("material_slots_to_texture_objects", {})

mod.on_all_mods_loaded = function()
	if #material_slots_to_texture_objects == 3 then
		return
	end

	DLS.load_directory_textures("textures")
		:next(function(file_names_to_texture_objects)
			table.merge(material_slots_to_texture_objects, file_names_to_texture_objects)
		end)
		:catch(function(error)
			mod:dtf(error, "Coal_error_loading_textures", 99)
		end)
end

mod:hook(
	UnitSpawnerManager,
	"spawn_network_unit",
	function(fun, self, unit_name, unit_template_name, position, rotation, material, item, ...)
		local unit, game_object_id = fun(self, unit_name, unit_template_name, position, rotation, material, item, ...)

		if item and item.base_unit == "content/weapons/player/ranged/throwing_rock_ogryn/throwing_rock_ogryn_01" then
			DLS.set_materials_on_unit(unit, material_slots_to_texture_objects)
		end

		return unit, game_object_id
	end
)

mod:hook_safe(CLASS.RandomizedFriendRockUnit, "init", function(self, context, slot)
	DLS.set_materials_on_unit(slot.unit_1p, material_slots_to_texture_objects)
	DLS.set_materials_on_unit(slot.unit_3p, material_slots_to_texture_objects)
end)
