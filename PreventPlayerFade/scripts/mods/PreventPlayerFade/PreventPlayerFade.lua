local mod = get_mod("PreventPlayerFade")

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

mod:hook_require("scripts/settings/breed/breeds/human_breed", function(bread_data)
	bread_data.fade = { min_distance = 0, max_distance = 0, max_height_difference = 0 }
end)

mod:hook_require("scripts/settings/breed/breeds/ogryn_breed", function(bread_data)
	bread_data.fade = { min_distance = 0, max_distance = 0, max_height_difference = 0 }
end)
