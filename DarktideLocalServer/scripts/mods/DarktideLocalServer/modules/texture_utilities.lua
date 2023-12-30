local DLS = get_mod("DarktideLocalServer")

DLS.TEXTURES_STATUS = table.enum("error", "success", "loading")

DLS.load_textures = function(texture_filenames, textures_directory)
	local loaded_textures = {}
	local promises = {}

	for _, file_name in pairs(texture_filenames) do
		local file_path = DLS.absolute_path(string.format("%s/%s", textures_directory, file_name))

		promises[#promises + 1] = DLS.get_image(file_path):next(function(response)
			loaded_textures[file_name] = response
		end)
	end

	return Promise.all(unpack(promises))
		:next(function()
			return {
				status = DLS.TEXTURES_STATUS.success,
				texture_objects = loaded_textures,
			}
		end)
		:catch(function(error)
			return {
				status = DLS.TEXTURES_STATUS.error,
				error = error,
			}
		end)
end

DLS.load_directory_textures = function(textures_directory)
	local function_caller_mod_name = DLS.function_caller_mod_name()

	local absolute_path = DLS.absolute_path(textures_directory)

	return DLS.list_directory(absolute_path):next(function(texture_filenames)
		return DLS.load_textures(texture_filenames, absolute_path):next(function(response)
			if response.status == DLS.TEXTURES_STATUS.success then
				local file_names_to_texture_objects = {}

				for file_name, texture_object in pairs(response.texture_objects) do
					local file_name_without_extension = file_name:gsub("%.[^.]*$", "") -- strip everything from last period onwards

					file_names_to_texture_objects[file_name_without_extension] = texture_object
				end

				return file_names_to_texture_objects
			end

			if response.status == DLS.TEXTURES_STATUS.error then
				print("Failed to load textures for " .. function_caller_mod_name)
			end
		end)
	end)
end

DLS.set_material_on_unit_mesh = function(unit, material_slot, mesh_index, material_texture)
	if not Unit.alive(unit) then
		return
	end

	local mesh = Unit.mesh(unit, mesh_index)

	Material.set_resource(Mesh.material(mesh, mesh_index), material_slot, material_texture.texture or material_texture)
end

DLS.set_materials_on_unit = function(unit, material_slots_to_texture_objects)
	if not Unit.alive(unit) then
		return
	end

	for mesh_index = 1, Unit.num_meshes(unit) do
		local mesh = Unit.mesh(unit, mesh_index)

		for material_index = 1, Mesh.num_materials(mesh) do
			local mesh_material = Mesh.material(mesh, material_index)

			-- Use mesh index if explicitly provided
			if material_slots_to_texture_objects[mesh_index] then
				for material_slot, material_texture in pairs(material_slots_to_texture_objects[mesh_index]) do
					Material.set_resource(mesh_material, material_slot, material_texture)
				end
			end

			for material_slot, texture_object in pairs(material_slots_to_texture_objects) do
				if type(material_slot) ~= "number" then
					Material.set_resource(mesh_material, material_slot, texture_object.texture)
				end
			end
		end
	end
end
