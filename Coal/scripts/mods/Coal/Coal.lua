local mod = get_mod("Coal")

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

local DLS = get_mod("DarktideLocalServer")

local loaded_textures = mod:persistent_table("loaded_textures", {})
local material_textures_table = mod:persistent_table("material_textures_table", {})

mod.on_all_mods_loaded = function()
	if #material_textures_table == 3 then
		return
	end

	DLS.load_directory_textures("textures")
		:next(function(response)
			if response.status == DLS.TEXTURES_STATUS.success then
				for file_name, texture in pairs(response.textures) do
					loaded_textures[file_name] = texture
				end

				table.merge(material_textures_table, {
					base_bc = loaded_textures["base_bc.jpg"],
					base_nm = loaded_textures["base_nm.jpg"],
					base_orm = loaded_textures["base_orm.jpg"],
				})
			end

			if response.status == DLS.TEXTURES_STATUS.error then
				print("Failed to load textures")
			end
		end)
		:catch(function(error)
			mod:dump(error, "Error loading textures", 99)
		end)
end

mod:hook(
	UnitSpawnerManager,
	"spawn_network_unit",
	function(fun, self, unit_name, unit_template_name, position, rotation, material, item, ...)
		local unit, game_object_id = fun(self, unit_name, unit_template_name, position, rotation, material, item, ...)

		if item and item.base_unit == "content/weapons/player/ranged/throwing_rock_ogryn/throwing_rock_ogryn_01" then
			DLS.set_materials_on_unit(unit, material_textures_table)
		end

		return unit, game_object_id
	end
)

mod:hook_safe(CLASS.RandomizedFriendRockUnit, "init", function(self, context, slot)
	DLS.set_materials_on_unit(slot.unit_1p, material_textures_table)
	DLS.set_materials_on_unit(slot.unit_3p, material_textures_table)
end)
