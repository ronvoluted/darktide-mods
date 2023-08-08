local mod = get_mod("Audio")

--[[
    Return Darktide installation directory.

    @returns {string} Absolute path.
--]]
mod.get_root_path = function()
	local binaries_path_handle = mod.io.popen("cd")
	local binaries_path = binaries_path_handle:read()
	binaries_path_handle:close()

	return binaries_path:gsub("binaries", ""):gsub("\\$", "")
end

--[[
    Return directory containing all mods.

    @returns {string} Absolute path.
--]]
mod.get_mods_path = function()
	local binaries_path_handle = mod.io.popen("cd")
	local binaries_path = binaries_path_handle:read()
	binaries_path_handle:close()

	return binaries_path:gsub("binaries", "mods")
end

--[[
    Return current mod's root directory (where "scripts" directory and ".mod" file are contained)
		or a path relative to it.

    @param {string} sub_path - Path to return relative to the root directory.
    @param {boolean} surround_quotes - If true, return with surrounding double quotes `"`.
    @returns {string} Absolute path.
--]]
mod.mod_path = function(sub_path, surround_quotes)
	sub_path = type(sub_path) == "string" and string.format("\\%s", sub_path:gsub("/", "\\")) or ""

	local path = string.format("%s\\%s%s", mod.get_mods_path(), mod:get_name(), sub_path)

	return surround_quotes and string.format('"%s"', path) or path
end

--[[
    Resolve a filepath to an absolute path. If filepath is relative, infers the
		originating mod which called it and resolves to its folder.

    @param {string} path - Filename without leading slash, or relative path, or absolute path.
    @returns {string} Absolute path. Resolves to mod media folder if `path` is a filename.
--]]
mod.absolute_path = function(path, surround_quotes)
	path = path:gsub("^/", ""):gsub("/", "\\")

	local absolute_path

	if path:sub(1, 2):match("^%a:") then
		absolute_path = path
	else
		local info = debug.getinfo(3, "S")
		local originating_mod_name = info.source:match("./../mods/([^/]+)/scripts/")

		if not originating_mod_name then
			info = debug.getinfo(2, "S")
			originating_mod_name = info.source:match("./../mods/([^/]+)/scripts/")
		end

		if originating_mod_name == "Tests" then
			originating_mod_name = mod:get_name()
		end

		local scripts_path_relative_to_mod_root =
			string.format("%s\\scripts\\mods\\%s\\", originating_mod_name, originating_mod_name)
		local media_path_relative_to_mod_root = string.format("%s\\media\\", originating_mod_name)

		if string.sub(path, 1, #scripts_path_relative_to_mod_root) == scripts_path_relative_to_mod_root then
			absolute_path = string.format("%s\\%s", mod.get_mods_path(), path)
		elseif string.sub(path, 1, #media_path_relative_to_mod_root) == media_path_relative_to_mod_root then
			absolute_path = string.format("%s\\%s", mod.get_mods_path(), path)
		elseif path:match("\\") then
			absolute_path = string.format("%s\\%s\\%s", mod.get_mods_path(), originating_mod_name, path)
		else
			absolute_path = string.format("%s\\%s\\media\\%s", mod.get_mods_path(), originating_mod_name, path)
		end
	end

	return surround_quotes and string.format('"%s"', absolute_path) or absolute_path
end
