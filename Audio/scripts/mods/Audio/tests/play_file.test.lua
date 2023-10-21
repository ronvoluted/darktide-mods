local Audio = get_mod("Audio")

local play_quack = {
	description = "play a quack sound",
	fun = function()
		local play_file_id, command = Audio.play_file("quack.ogg")

		return type(play_file_id) == "number"
			and string.starts_with(
				command,
				'"C:\\Program Files (x86)\\Steam\\steamapps\\common\\Warhammer 40,000 DARKTIDE\\mods\\Audio\\bin\\ffplay_dt.exe"'
			)
	end,
	expected = true,
}

Audio._tests.suites["play_file"] = {
	description = "Playing audio files",
	tests = {
		play_quack,
	},
}
