local DLS = get_mod("Audio")

local list_dir = {
	description = "list contents of Darktide Local Server scripts",
	async_fun = function()
		return DLS.list_directory(
			"C:/Program Files (x86)/Steam/steamapps/common/Warhammer 40,000 DARKTIDE/mods/DarktideLocalServer/scripts/mods/DarktideLocalServer"
		):next(function(contents)
			return type(contents) == "table"
				and table.contains(contents, "DarktideLocalServer.lua")
				and table.contains(contents, "DarktideLocalServer_data.lua")
				and table.contains(contents, "DarktideLocalServer_localization.lua")
		end)
	end,
	expected = true,
}

local list_special_dir_name = {
	description = "list contents of directory containing spaces and special chars",
	async_fun = function()
		return DLS.list_directory(
			"C:\\Program Files (x86)\\Steam\\steamapps\\common\\Warhammer 40,000 DARKTIDE\\mods\\DarktideLocalServer\\tests\\big E says hello"
		):next(function(contents)
			return type(contents) == "table" and table.contains(contents, "a.txt") and table.contains(contents, "b.rs")
		end)
	end,
	expected = true,
}

local list_dir_info = {
	description = "list contents with subdirectories and general and audio info",
	async_fun = function()
		return DLS.list_directory(
			"C:/Program Files (x86)/Steam/steamapps/common/Warhammer 40,000 DARKTIDE/mods/Audio/audio",
			true,
			true
		)
			:next(function(contents)
				if type(contents) == "table" then
					for _, file in pairs(contents) do
						if file.name == "quack.ogg" and file.created_at == 1691029055 and file.sample_rate == 44100 then
							return true
						end
					end
				end
			end)
	end,
	expected = true,
}

local darktide_only = {
	description = "return nil if path is not a subdirectory of Darktide",
	async_fun = function()
		return DLS.list_directory("C:/Program Files"):next(function(contents)
			if type(contents) == "nil" then
				return true
			end
		end)
	end,
	expected = true,
}

DLS._tests.suites["list_directory"] = {
	description = "Listing directories",
	tests = {
		list_dir,
		list_special_dir_name,
		list_dir_info,
		darktide_only,
	},
}
