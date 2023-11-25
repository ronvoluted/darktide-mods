local LocalServer = get_mod("DarktideLocalServer")

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

local DMF = get_mod("DMF")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")

---@class Promise
local Promise = class("Promise")

if not DMF:get("developer_mode") then
	DMF:set("developer_mode", true)
	DMF.load_developer_mode_settings()
end

if not DMF:get("show_developer_console") then
	DMF:set("show_developer_console", true)
end

DMF.load_dev_console_settings()

local binaries_path_handle = Mods.lua.io.popen("cd")
local binaries_path = binaries_path_handle:read()
binaries_path_handle:close()
local bin_path = table.concat({
	binaries_path:gsub("binaries", "mods"),
	LocalServer:get_name(),
	"bin",
}, "\\")

Mods.lua.io.popen(string.format('"%s\\start_server"', bin_path)):close()

local config_handle = Mods.lua.io.open(bin_path .. "\\config.json", "rb")
local config_json = config_handle and config_handle:read("*a")
config_handle:close()
local config = cjson.decode(config_json)
local port = config and config.port or 41012
local host = string.format("localhost:%s/", port)
local image_endpoint = host .. "image"
local list_directory_endpoint = host .. "list_directory"
local run_endpoint = host .. "run"
local process_is_running_endpoint = host .. "process_running"
local stop_process_endpoint = host .. "stop_process"

LocalServer.get_port = function()
	return port
end

LocalServer.get_image = function(path)
	local encoded_path = Http.url_encode(path)
	local image_url = string.format("%s?path=%s", image_endpoint, encoded_path)

	local image = Managers.url_loader:load_texture(image_url):catch(function(error)
		LocalServer:dump({
			url = image_url,
			path = encoded_path,
			status = error.status,
			body = error.body,
			description = error.description,
			headers = error.headers,
			response_time = error.response_time,
		}, string.format("Requested image failed: %s", os.date()), 8)
	end)

	return image
end

---List the contents of a directory. Will fail if not a subdirectory of Darktide.
---@param path string Directory to query
---@param sub_directories boolean Include subdirectories
---@param general_info boolean Include general info
---@param audio_info boolean Include info for audio files
---@param image_info boolean Include info for image files
---@return Promise table Contents of the directory. Will be a nested table if `sub_directories` or any `_info` parameters are true
LocalServer.list_directory = function(path, sub_directories, general_info, audio_info, image_info)
	local encoded_path = Http.url_encode(path)

	local list_url = BackendUtilities.url_builder(string.format(list_directory_endpoint, port))
		:query("path", encoded_path)
		:query("sub_directories", sub_directories)
		:query("general_info", general_info)
		:query("audio_info", audio_info)
		:query("image_info", image_info)
		:to_string()

	return Managers.backend
		:url_request(list_url)
		:next(function(response)
			return response.body.contents
		end)
		:catch(function(error)
			LocalServer:dump({
				url = list_url,
				path = path,
				status = error.status,
				body = error.body,
				description = error.description,
				headers = error.headers,
				response_time = error.response_time,
			}, string.format("Could not list directory (%s)", os.date()), 8)
		end)
end

LocalServer.run_command = function(command)
	local request = Managers.backend:url_request(run_endpoint, {
		method = "POST",
		body = { command = command },
	})

	return request
end

LocalServer.process_is_running = function(pid)
	return Managers.backend:url_request(string.format("%s?pid=%s", process_is_running_endpoint, pid))
end

LocalServer.stop_process = function(pid)
	Managers.backend:url_request(string.format("%s?pid=%s", stop_process_endpoint, pid))
end
