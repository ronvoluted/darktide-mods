local LocalServer = get_mod("DarktideLocalServer")

--[[ 🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆🦆 ]]

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

local image_endpoint = string.format("localhost:%s/image", port)
local run_endpoint = string.format("localhost:%s/run", port)
local process_is_running_endpoint = string.format("localhost:%s/process_running", port)
local stop_process_endpoint = string.format("localhost:%s/stop_process", port)

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
