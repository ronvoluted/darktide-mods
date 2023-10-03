local Audio = get_mod("Audio")

local io = Mods.lua.io

--[[
    Conditionally surround a string with double quotes.

		@param {boolean} surround_quotes - If true, return `str` with surrounding double quotes `"`.
    @returns {string} Absolute path.
--]]
local double_quote = function(str, surround_quotes)
	return surround_quotes and string.format('"%s"', str) or str
end

--[[
    Return Darktide installation directory.

    @returns {string} Absolute path.
--]]
Audio.get_darktide_path = function(surround_quotes)
	local binaries_path_handle = io.popen("cd")
	local binaries_path = binaries_path_handle:read()
	binaries_path_handle:close()

	local root_path = binaries_path:gsub("binaries", ""):gsub("\\$", "")

	return double_quote(root_path, surround_quotes)
end

--[[
    Return directory containing all mods.

    @returns {string} Absolute path.
--]]
Audio.get_root_mods_path = function(surround_quotes)
	local binaries_path_handle = io.popen("cd")
	local binaries_path = binaries_path_handle:read()
	binaries_path_handle:close()

	local all_mods_path = binaries_path:gsub("binaries", "mods")

	return double_quote(all_mods_path, surround_quotes)
end

--[[
    Return current mod's root directory (where "scripts" directory and ".mod" file are contained)
		or a path relative to it.

    @param {string} sub_path - Path to return relative to the root directory.
    @param {boolean} surround_quotes - If true, return with surrounding double quotes `"`.
    @returns {string} Absolute path.
--]]
Audio.get_mod_path = function(mod, sub_path, surround_quotes)
	sub_path = type(sub_path) == "string" and string.format("\\%s", sub_path:gsub("/", "\\")) or ""

	local path = string.format("%s\\%s%s", Audio.get_root_mods_path(), mod:get_name(), sub_path)

	return double_quote(path, surround_quotes)
end

--[[
    Resolve a filepath to an absolute path. If filepath is relative, infers the
		originating mod which called it and resolves to its folder.

    @param {string} path - Filename without leading slash, or relative path, or absolute path.
    @returns {string} Absolute path.
--]]
Audio.absolute_path = function(path, working_directory, surround_quotes)
	path = path:gsub("^/", ""):gsub("/", "\\")

	local absolute_path

	if working_directory then
		working_directory = working_directory:gsub("/", "\\")
		absolute_path = string.format("%s\\%s", working_directory, path)

		return double_quote(absolute_path, surround_quotes)
	end

	-- Path is already an absolute path
	if path:sub(1, 2):match("^%a:") then
		absolute_path = path

		return double_quote(absolute_path, surround_quotes)
	end

	local root_mods_path = Audio.get_root_mods_path()
	local caller_mod_name = Audio.function_caller_mod_name()

	if string.starts_with(path, caller_mod_name) then
		absolute_path = string.format("%s\\%s", root_mods_path, path)
	else
		absolute_path = string.format("%s\\%s\\audio\\%s", root_mods_path, caller_mod_name, path)
	end

	return double_quote(absolute_path, surround_quotes)
end
