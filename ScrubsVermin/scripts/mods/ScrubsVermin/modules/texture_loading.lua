local mod = get_mod("ScrubsVermin")
local Promise = require("scripts/foundation/utilities/promise")

local texture_dir

mod.frames = mod:persistent_table("frames", {})
mod.frames_status = mod:persistent_table("frames_loaded", { loaded = false, loading = false })

mod.all_mods_loaded_functions["loading"] = function()
	texture_dir = mod.DLS.absolute_path("textures")

	mod.DLS.list_directory(texture_dir):next(function(contents)
		mod.frame_count = #contents
	end)
end

mod.load_textures = function()
	if #mod.frames == mod.frame_count then -- All frames loaded
		local promise = Promise:new()
		promise:resolve(mod.frames)

		return promise
	end

	mod.frames_status.loading = true

	local promises = {}

	for i = 1, mod.frame_count do
		local texture_path = string.format("%s\\scrubsvermin%s.png", texture_dir, i)

		promises[#promises + 1] = mod.DLS.get_image(texture_path):next(function(response)
			mod.frames[i] = response.texture
		end)
	end

	return Promise.all(unpack(promises))
		:next(function()
			mod.frames_status.loaded = true
			mod.frames_status.loading = false
		end)
		:catch(function()
			return Promise.rejected("Failed to load all images")
		end)
end
