local DLS = get_mod("DarktideLocalServer")

local root_path = {
	description = "return Darktide folder",
	fun = function()
		return DLS.get_darktide_path()
	end,
	expected = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Warhammer 40,000 DARKTIDE",
}

local mods_path = {
	description = "return mods folder",
	fun = function()
		return DLS.get_root_mods_path()
	end,
	expected = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Warhammer 40,000 DARKTIDE\\mods",
}

local mod_path = {
	description = "return current mod's root folder",
	fun = function()
		return DLS.get_mod_path(DLS)
	end,
	expected = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Warhammer 40,000 DARKTIDE\\mods\\DarktideLocalServer",
}

local mod_path_relative = {
	description = "return a path relative current mod's root folder",
	fun = function()
		return DLS.get_mod_path(DLS, "ribbit/diary.md")
	end,
	expected = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Warhammer 40,000 DARKTIDE\\mods\\DarktideLocalServer\\ribbit\\diary.md",
}

local filename_beginning_with_mod_name = {
	description = 'resolve filename beginning with mod name to path inside mod root folder',
	fun = function()
	return DLS.absolute_path("DarktideLocalServer_file.pdf")
	end,
	expected = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Warhammer 40,000 DARKTIDE\\mods\\DarktideLocalServer\\DarktideLocalServer_file.pdf",
}

local absolute_filename = {
	description = 'resolve filename to absolute path inside "/audio" folder',
	fun = function()
	return DLS.absolute_path("melody.wav")
	end,
	expected = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Warhammer 40,000 DARKTIDE\\mods\\DarktideLocalServer\\melody.wav",
}

local absolute_relative = {
	description = "resolve relative path to absolute path inside outer mod folder",
	fun = function()
		return DLS.absolute_path("DarktideLocalServer\\potato\\chips\\chicken.jpg")
	end,
	expected = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Warhammer 40,000 DARKTIDE\\mods\\DarktideLocalServer\\potato\\chips\\chicken.jpg",
}

local absolute_unchanged = {
	description = "return absolute path unchanged",
	fun = function()
		return DLS.absolute_path("C:\\Windows\\explorer.exe")
	end,
	expected = "C:\\Windows\\explorer.exe",
}

DLS._tests.suites["path_utilities"] = {
	description = "Path utilities",
	tests = {
		root_path,
		mods_path,
		mod_path,
		mod_path_relative,
		absolute_filename,
		filename_beginning_with_mod_name,
		absolute_relative,
		absolute_unchanged,
	},
}
