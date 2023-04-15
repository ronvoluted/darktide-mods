local mod = get_mod("CustomResolutions")

local custom_options = mod:get("options")
local append_position = mod:get("append_position")
local backed_up = mod:persistent_table("backed_up")

-- Temporary migration code
local append_to_start = mod:get("append_to_start")
if append_to_start == 1 or append_to_start == 0 then
	append_position = append_to_start == 1 and "start" or "end"
	mod:set("append_position", append_position)
end

local function get_current_resolutions(render_settings)
	for _, setting in ipairs(render_settings.settings) do
		if type(setting) == "table" and setting.id == "resolution" and type(setting.options) == "table" then
			local display_names = {}
			local highest_id = 0

			for i, option in ipairs(setting.options) do
				if type(option.id) == "number" then
					if type(option.display_name) == "string" then
						display_names[option.display_name] = i
					end

					if option.id > highest_id then
						highest_id = option.id
					end
				end
			end

			return setting.options, display_names, highest_id
		end
	end
end

local function append_custom_options(render_settings)
	local options, display_names, highest_id = get_current_resolutions(render_settings)

	if append_position == "start" then
		highest_id = 0

		for i = 1, #options do
			options[i].id = options[i].id + #custom_options
		end
	end

	for i, custom_option in ipairs(custom_options) do
		if display_names[custom_option.display_name] then -- Update if already inserted
			local index = display_names[custom_option.display_name]

			options[index].width = custom_option.width
			options[index].height = custom_option.height
		else -- Insert custom resolution
			highest_id = highest_id + 1
			local index = append_position == "start" and i or #options + 1

			table.insert(options, index, {
				id = highest_id,
				display_name = custom_option.display_name,
				width = custom_option.width,
				height = custom_option.height,
				ignore_localization = true,
				output_screen = 1,
				adapter_index = 1,
			})
		end
	end
end

mod:hook_require("scripts/settings/options/render_settings", function(render_settings)
	if append_position == nil then
		mod:set("append_position", "end")
	end

	if not custom_options or #custom_options == 0 then
		mod:set("options", {})
		return
	end

	append_custom_options(render_settings)

	if not backed_up.done then
		mod:io_dofile("CustomResolutions/scripts/mods/CustomResolutions/Backup")
		backed_up.done = true
	end
end)

mod.on_unload = function()
	mod:set("append_to_start", nil)
end
