local Audio = get_mod("Audio")
local DLS = get_mod("DarktideLocalServer")

AudioFilesHandler = class("AudioFilesHandler")

local get_nested_table = function(table_, branch_path)
	local path_segments = {}

	for match in branch_path:gmatch("[^/]+") do
		table.insert(path_segments, match)
	end

	local nested_table = table_

	for i = 1, #path_segments do
		local key = path_segments[i]

		if nested_table[key] then
			nested_table = nested_table[key]
		else
			nested_table = nil
			break
		end
	end

	return nested_table
end

---Provides a handler for reading and accessing a list of audio files in a directory
---@param path string Absolute path to directory containing audio files
---@param sub_directory_override string If provided, will read from subdirectory of "audio"
---@param placeholder_table table List of files to fallback to before promise fulfills
AudioFilesHandler.init = function(self, path, sub_directory_override, placeholder_table)
	self._path = path
	self._path_root = sub_directory_override and sub_directory_override:gsub("/", ""):gsub("\\", "") or nil
	self._files = {}
	self._lookup_table = {}
	self._cursor_index = 1

	if placeholder_table then
		table.map(placeholder_table, function(placeholder)
			local entry = placeholder.file_path and placeholder or { name = placeholder }

			self._lookup_table[#self._lookup_table + 1] = entry

			return entry
		end, self._files)
	end

	DLS.list_directory(self._path, true, nil, true, nil, self._path_root):next(function(contents)
		self._files = contents
		self._lookup_table = getmetatable(contents)
		self._files_length = #self._lookup_table
	end)
end

AudioFilesHandler.list = function(self, sub_directory_path)
	return sub_directory_path and get_nested_table(self._files, sub_directory_path) or self._files
end

AudioFilesHandler.count = function(self)
	return self._files_length
end

AudioFilesHandler.lookup = function(self, lookup_index, return_with_metadata)
	if not lookup_index then
		return self._lookup_table
	end

	return return_with_metadata and self._lookup_table[lookup_index] or self._lookup_table[lookup_index].file_path
end

AudioFilesHandler.cursor_index = function(self)
	return self._cursor_index
end

AudioFilesHandler.current = function(self, return_with_metadata)
	if return_with_metadata then
		return self._lookup_table[self._cursor_index]
	else
		return self._lookup_table[self._cursor_index].file_path
	end
end

AudioFilesHandler.next = function(self, return_with_metadata)
	self._cursor_index = self._cursor_index + 1

	if self._cursor_index > self._files_length then
		self._cursor_index = 1
	end

	if return_with_metadata then
		return self._lookup_table[self._cursor_index]
	else
		return self._lookup_table[self._cursor_index].file_path
	end
end

AudioFilesHandler.random = function(self, sub_directory_path, return_with_metadata)
	if not sub_directory_path then
		local randomIndex = math.random(1, self._files_length)

		return return_with_metadata and self._lookup_table[randomIndex] or self._lookup_table[randomIndex].file_path
	end

	local sub_directory_table = get_nested_table(self._files, sub_directory_path)

	local randomIndex = math.random(1, #sub_directory_table)

	return return_with_metadata and sub_directory_table[randomIndex] or sub_directory_table[randomIndex].file_path
end

--[[
	This wrapper around `Class:new()` is required to determine which mod was the originating caller. Under the hood,
	`absolute_path()` uses `function_caller_mod_name()` to determine the path to the mod's directory. That path must
	be initialised here and not inside the init function. This is so that it resolves to the calling mod's directory
  and not Audio's directory, which would be the case if the other mod directly called `AudioFilesHandler:new()`.
]]
Audio.new_files_handler = function(placeholder_table, sub_directory_override)
	return AudioFilesHandler:new(
		DLS.absolute_path(sub_directory_override or ""),
		sub_directory_override,
		placeholder_table
	)
end
