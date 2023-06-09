local music_tracks = {
	[1] = {
		soundtrack_number = 1,
		name = "Darktide Main Theme",
		music_game_state = "victory",
		soundtrack_duration = 257.727,
	},
	[2] = {
		disabled = true,
		soundtrack_number = 2,
		name = "The Uprising on Hive Tertium",
		soundtrack_duration = 164.443,
	},
	[3] = {
		disabled = true,
		soundtrack_number = 3,
		name = "Prison Break",
		soundtrack_duration = 158.644,
	},
	[4] = {
		soundtrack_number = 4,
		name = "Onboard the Tancred Bastion",
		music_zone = "prologue",
		soundtrack_duration = 117.684,
	},
	[5] = {
		soundtrack_number = 5,
		name = "Escaping the Prison Ship",
		music_zone = "prologue",
		music_objective = "prologue_combat",
		music_combat = "normal",
		music_game_state = "mission",
		event_intensity = "high",
		soundtrack_duration = 97.805,
	},
	[6] = {
		disabled = true,
		soundtrack_number = 6,
		name = "The Imperium Unites",
		soundtrack_duration = 93.234,
	},
	[7] = {
		soundtrack_number = 7,
		name = "Immortal Imperium",
		music_game_state = "mission",
		music_zone = "zone_1",
		music_objective = "demolition_event",
		event_intensity = "high",
		soundtrack_duration = 234.217,
	},
	[8] = {
		soundtrack_number = 8,
		name = "Dropship to Hive Tertium",
		music_game_state = "mission_briefing",
		soundtrack_duration = 141.377,
	},
	[9] = {
		soundtrack_number = 9,
		name = "Entering the Hive City",
		music_game_state = "mission_intro",
		music_zone = "zone_1",
		soundtrack_duration = 54.155,
	},
	[10] = {
		soundtrack_number = 10,
		name = "The Transit Horde",
		music_game_state = "mission",
		music_zone = "zone_1",
		music_combat = "horde_high",
		soundtrack_duration = 124.607,
	},
	[11] = {
		soundtrack_number = 11,
		name = "Imperium of Man",
		music_game_state = "loading",
		soundtrack_duration = 161.466,
	},
	[12] = {
		soundtrack_number = 12,
		name = "The Mourningstar",
		music_game_state = "main_menu",
		soundtrack_duration = 147.516,
	},
	[13] = {
		soundtrack_number = 13,
		name = "Disposal Unit (Imperium Mix)",
		music_game_state = "mission",
		music_zone = "zone_1",
		music_objective = "kill_event",
		event_intensity = "high",
		soundtrack_duration = 213.292,
	},
	[14] = {
		soundtrack_number = 14,
		name = "Late Night Entertainment",
		music_game_state = "mission_intro",
		music_zone = "zone_6",
		music_combat = "horde_high",
		soundtrack_duration = 116.875,
	},
	[15] = {
		soundtrack_number = 15,
		name = "Nightsider",
		music_game_state = "mission",
		music_zone = "zone_6",
		music_combat = "boss",
		soundtrack_duration = 182.050,
	},
	[16] = {
		disabled = true,
		soundtrack_number = 16,
		name = "City of Tertium",
		soundtrack_duration = 119.957,
	},
	[17] = {
		soundtrack_number = 17,
		name = "Broadcast Apparatus",
		music_game_state = "mission",
		music_zone = "zone_1",
		music_objective = "collect_event",
		event_intensity = "high",
		soundtrack_duration = 132.104,
	},
	[18] = {
		soundtrack_number = 18,
		name = "Apparatus Receiving",
		music_game_state = "mission",
		music_zone = "zone_1",
		music_objective = "collect_event",
		event_intensity = "low",
		soundtrack_duration = 142.553,
	},
	[19] = {
		soundtrack_number = 19,
		name = "Data Interference",
		music_game_state = "mission",
		music_zone = "zone_1",
		music_objective = "hacking_event",
		event_intensity = "high",
		soundtrack_duration = 134.455,
	},
	[20] = {
		soundtrack_number = 20,
		name = "Forge Manufactorum (Side A)",
		music_game_state = "mission_intro",
		music_zone = "zone_3",
		event_intensity = "high",
		soundtrack_duration = 68,
	},
	[21] = {
		soundtrack_number = 20,
		name = "Forge Manufactorum (Side B)",
		music_game_state = "mission",
		music_zone = "zone_3",
		music_combat = "horde_high",
		soundtrack_duration = 89,
	},
	[22] = {
		disabled = true,
		soundtrack_number = 21,
		name = "Atoma Prime",
		music_zone = "hub",
		soundtrack_duration = 235.183,
	},
	[23] = {
		soundtrack_number = 22,
		name = "Entering Throneside",
		music_game_state = "mission_intro",
		music_zone = "zone_5",
		soundtrack_duration = 106.243,
	},
	[24] = {
		soundtrack_number = 23,
		name = "Waiting to Strike",
		music_game_state = "mission",
		music_zone = "zone_1",
		music_objective = "fortification_event",
		event_intensity = "low",
		soundtrack_duration = 142.553,
	},
	[25] = {
		disabled = true,
		name = "Path of Trust",
		soundtrack_number = 24,
		music_game_state = "cinematic_pot",
		music_zone = "hub",
		event_intensity = "low",
		soundtrack_duration = 122.099,
	},
	[26] = {
		soundtrack_number = 25,
		name = "Unrest in Throneside",
		music_game_state = "mission",
		music_zone = "zone_5",
		music_combat = "horde_high",
		soundtrack_duration = 122.099,
	},
	[27] = {
		soundtrack_number = 26,
		name = "Transmission Commences",
		music_game_state = "mission",
		music_zone = "zone_4",
		music_objective = "scanning_event",
		event_intensity = "low",
		soundtrack_duration = 219.823,
	},
	[28] = {
		soundtrack_number = 27,
		name = "Offworld Auspex",
		music_game_state = "mission",
		music_zone = "zone_4",
		music_objective = "scanning_event",
		event_intensity = "high",
		soundtrack_duration = 154.282,
	},
	[29] = {
		soundtrack_number = 28,
		name = "Hive City Lowest Level (Side A)",
		music_game_state = "mission_intro",
		music_zone = "zone_2",
		soundtrack_duration = 117,
	},
	[30] = {
		soundtrack_number = 28,
		name = "Hive City Lowest Level (Side B)",
		music_game_state = "mission",
		music_zone = "zone_2",
		music_combat = "horde_high",
		soundtrack_duration = 93,
	},
	[31] = {
		soundtrack_number = 29,
		name = "The Torrent Fights Back",
		music_game_state = "mission",
		music_zone = "zone_2",
		music_combat = "boss",
		soundtrack_duration = 163.372,
	},
	[32] = {
		soundtrack_number = 30,
		name = "Warp Traveller",
		music_game_state = "mission",
		music_zone = "zone_6",
		music_combat = "horde_high",
		soundtrack_duration = 190.122,
	},
	[33] = {
		disabled = true,
		soundtrack_number = 31,
		name = "Debriefing",
		soundtrack_duration = 73.015,
	},
	[34] = {
		soundtrack_number = 32,
		name = "Escape Initiated",
		music_game_state = "mission",
		music_zone = "zone_1",
		music_objective = "escape_event",
		event_intensity = "high",
		soundtrack_duration = 78.892,
	},
	[35] = {
		soundtrack_number = 33,
		name = "Imperial Advance",
		music_game_state = "mission",
		music_zone = "zone_1",
		music_objective = "fortification_event",
		event_intensity = "high",
		soundtrack_duration = 122.203,
	},
	[36] = {
		soundtrack_number = 34,
		name = "Hab Block Bonanza",
		music_game_state = "mission",
		music_zone = "zone_1",
		music_combat = "boss",
		soundtrack_duration = 132.731,
	},
	[37] = {
		soundtrack_number = 35,
		name = "The Will of the Imperium",
		music_game_state = "mission",
		music_zone = "zone_1",
		music_objective = "demolition_event",
		event_intensity = "low",
		soundtrack_duration = 149.240,
	},
	[38] = {
		soundtrack_number = 36,
		name = "Write Transmit",
		music_game_state = "mission",
		music_zone = "zone_5",
		music_combat = "boss",
		duration = 160,
		soundtrack_duration = 193.596,
	},
	[39] = {
		soundtrack_number = 37,
		name = "Sublevel Data Interrogation",
		music_game_state = "mission",
		music_zone = "zone_1",
		music_objective = "hacking_event",
		event_intensity = "low",
		soundtrack_duration = 136.336,
	},
	[40] = {
		soundtrack_number = 38,
		name = "Reality Slipping",
		music_game_state = "mission",
		music_zone = "zone_4",
		music_combat = "horde_high",
		soundtrack_duration = 165.488,
	},
	[41] = {
		soundtrack_number = 39,
		name = "Heart of Heresy",
		music_game_state = "mission_intro",
		music_zone = "zone_4",
		soundtrack_duration = 114.471,
	},
	[42] = {
		soundtrack_number = 40,
		name = "Embrace of the Chaos Cult",
		music_game_state = "mission",
		music_zone = "zone_4",
		music_combat = "boss",
		soundtrack_duration = 122.360,
	},
	[43] = {
		soundtrack_number = 41,
		name = "Forge Chaos Detected",
		music_game_state = "mission",
		music_zone = "zone_3",
		music_combat = "boss",
		soundtrack_duration = 94.017,
	},
	[44] = {
		soundtrack_number = 42,
		name = "Last Man Standing",
		music_game_state = "mission",
		music_zone = "zone_1",
		music_objective = "last_man_standing",
		event_intensity = "high",
		soundtrack_duration = 130.563,
	},
	[45] = {
		disabled = true,
		soundtrack_number = 43,
		name = "The Emperor of Mankind",
		soundtrack_duration = 209.322,
	},
	[46] = {
		disabled = true,
		soundtrack_number = 44,
		name = "Admonition",
		soundtrack_duration = 143.885,
	},
	[47] = {
		disabled = true,
		soundtrack_number = 45,
		name = "The Imperium Unites Part 2 (Bonus Track)",
		soundtrack_duration = 78.004,
	},
	[48] = {
		disabled = true,
		soundtrack_number = 46,
		name = "Disposal Unit (Original Mix)",
		music_game_state = "mission",
		music_zone = "zone_1",
		music_objective = "kill_event",
		event_intensity = "low",
		soundtrack_duration = 183.539,
	},
	[49] = {
		disabled = true,
		soundtrack_number = 47,
		name = "Reality Slipping (Imperium Mix)",
		soundtrack_duration = 99.712,
	},
	[50] = {
		disabled = true,
		soundtrack_number = 48,
		name = "Transmission Commences (Late Night Mix)",
		soundtrack_duration = 233.250,
	},
	[51] = {
		soundtrack_number = 49,
		name = "Rejects Unite", -- Placeholder
		music_game_state = "mission",
		music_zone = "zone_1",
		music_objective = "gauntlet_event",
		event_intensity = "low",
		soundtrack_duration = 150,
	},
	[52] = {
		soundtrack_number = 50,
		name = "The Gauntlet", -- Placeholder
		music_game_state = "mission",
		music_zone = "zone_1",
		music_objective = "gauntlet_event",
		event_intensity = "high",
		soundtrack_duration = 150,
	},
	-- [53] = {
	-- 	soundtrack_number = 999,
	-- 	name = "None",
	-- 	music_game_state = "None",
	-- 	music_zone = "None",
	-- 	music_objective = "None",
	-- 	event_intensity = "None",
	-- 	soundtrack_duration = 60,
	-- },
}

return music_tracks
