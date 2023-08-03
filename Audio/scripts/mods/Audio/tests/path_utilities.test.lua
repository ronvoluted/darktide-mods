local mod = get_mod("Audio")

local root_path = {
	description = "return Darktide folder",
	fun = function(suite_setup_value, test_setup_value)
		return mod.get_root_path()
	end,
	expected = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Warhammer 40,000 DARKTIDE",
}

local mods_path = {
	description = "return mods folder",
	fun = function()
		return mod.get_mods_path()
	end,
	expected = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Warhammer 40,000 DARKTIDE\\mods",
}

local mod_path = {
	description = "return current mod's root folder",
	fun = function()
		return mod.mod_path("ribbit/diary.md")
	end,
	expected = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Warhammer 40,000 DARKTIDE\\mods\\Audio\\ribbit\\diary.md",
}

local mod_path_relative = {
	description = "return a path relative current mod's root folder",
	fun = function()
		return mod.mod_path("ribbit/diary.md")
	end,
	expected = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Warhammer 40,000 DARKTIDE\\mods\\Audio\\ribbit\\diary.md",
}

local absolute_filename = {
	description = "resolve filename to absolute path inside media folder",
	fun = function()
		return mod.absolute_path("melody.wav")
	end,
	expected = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Warhammer 40,000 DARKTIDE\\mods\\Audio\\media\\melody.wav",
}

local absolute_relative = {
	description = "resolve relative path to absolute path inside mods folder",
	fun = function()
		return mod.absolute_path("potato/chips/chicken.jpg")
	end,
	expected = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Warhammer 40,000 DARKTIDE\\mods\\Audio\\potato\\chips\\chicken.jpg",
}

local absolute_unchanged = {
	description = "return absolute path unchanged",
	fun = function()
		return mod.absolute_path("C:\\Windows\\explorer.exe")
	end,
	expected = "C:\\Windows\\explorer.exe",
}

mod._tests.suites["paths"] = {
	description = "Path utilities",
	tests = {
		root_path,
		mods_path,
		mod_path,
		mod_path_relative,
		absolute_filename,
		absolute_relative,
		absolute_unchanged,
	},
}
