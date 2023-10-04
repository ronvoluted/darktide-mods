# Darktide Local Server (mod)

## Small server for loading custom textures and running CLI commands asynchronously

This is the mod counterpart to the [Darktide Local Server](https://github.com/ronvoluted/darktide-local-server) server and provides utility functions to it. See the documentation in that repository for more low level details.

The server also ensures that only one instance of it is ever running, so multiple mods using this mod as a dependency will not spawn multiple servers.

### Custom textures

The only[*](https://github.com/ronvoluted/darktide-local-server#the-only-way-to-load-images) way to load images into the game is to fetch them via URL. Using the local server avoids having to host images online which would have to serve requests every day for every mod user, every time they launched the game, for every image loaded.

### Asynchronous commands

In Lua we have access to `os.execute` and `io.popen` but both of them are blocking operations. There is a minimum 30ms threadlock even just for a a simple `echo For the Emperor!` each time you fire the call. Delegating command executions to the local server allows you to run these asynchronously.

### **[Available at Nexus Mods](https://www.nexusmods.com/warhammer40kdarktide/mods/211)**

## Usage

### Initialise mod
```lua
local LocalServer

mod.on_all_mods_loaded = function()
	LocalServer = get_mod("DarktideLocalServer")

	if not LocalServer then
		mod:echo(
			'Required mod "Darktide Local Server" not found: Download from Nexus Mods and include in mod_load_order.txt'
		)
		mod:disable_all_hooks()
		mod:disable_all_commands()
	end
end
```

> **Note**
> The first time a player runs the game with the mod installed, they may be prompted to allow access for the server. "Public networks" does not need to and should not be set.
>
> ![Windows Firewall Allow DarktideLocalServer](https://github.com/ronvoluted/darktide-mods/blob/main/DarktideLocalServer/WindowsFirewall.png?raw=true)


### Images

```lua
LocalServer.get_image(path)
```

This is a wrapper around `Managers.url_loader.load_texture` so if you were previously using something like this:
```lua
local texture_promise = Managers.url_loader:load_texture("https://webservertextures.dt/ForTheEmperor.png")
```

You can now use this to load an image locally:
```lua
local texture_promise = LocalServer.get_image("C:/textures/ForTheEmperor.png")
```

### Commands

```lua
LocalServer.run_command(command)
```

The first argument in `command` must be the path to a whitelisted executable and surrounded by double quotes if it contains spaces. You may need to be mindful of how backslashes `\` and double-quotes `"` are escaped.

> **Note**
> The following executables are for demonstrative purposes. To have an executable whitelisted, file an issue at [github.com/ronvoluted/darktide-local-server](https://github.com/ronvoluted/darktide-local-server/issues/new?title=Whitelist%20request)

#### Basic examples

```lua
-- Open Calculator
LocalServer.run_command("calculator")

-- Handle the response when the promise is fulfilled
LocalServer.run_command("calculator"):next(function(response)
	mod:dump(response)
end)

-- Handle the promise as a reference
local request = LocalServer.run_command("calculator")

requst:next(function(response)
	mod:dump(response)
end)
```

#### Construct arguments
```lua
local executable_path = "C:/Program Files (x86)/Steam/steamapps/common/Warhammer 40,000 DARKTIDE/mods/YourMod/bin/youtube-dl"
local video_url = "https://youtube.com/watch?v=9eZOL-S7KGw"
local retries = 5

LocalServer.run_command(string.format("%s %s --retries %s", executable_path, video_url, retries))
```

#### Parse JSON and handle errors

```lua
local command = "notepad ForTheEmperor!.txt"
local promise = LocalServer.run_command(command)

promise:next(function(result)
		local response = cjson.decode(result.body)

		print(response.success, response.pid)
	end)
	:catch(function(error)
		local success = error.body and cjson.decode(error.body).success

		if success == false then
			Audio:dump({
				command = command,
				status = error.status,
				body = error.body,
				description = error.description,
				headers = error.headers,
				response_time = error.response_time,
			}, string.format("Server run command failed: %s", os.date()), 2)
		end
	end)
```

The JSON returned is not stdout from the executable, but always an object with this format:

```ts
{
	"success": true | false,
	"pid": number | undefined // Process ID of the created executable instance
}
```

#### Real example

See an [implementation in Audio Plugin](https://github.com/ronvoluted/darktide-mods/blob/main/Audio/scripts/mods/Audio/modules/play_file.lua#L183-L219) where a top level table, `played_files`, is immediately returned while pending, then later filled with data once the promise has fulfilled. This allows the code consuming it to avoid working with promises.

### Changing port number

The default port used by Darktide Local Server is `41012` ([explanation of why](https://github.com/ronvoluted/darktide-local-server#why-is-the-default-port-41012)). Players can change this by editing the `config.json` file found in "bin". For example, to set the number to `1234`:

```json
{
	"port": 1234
}
```
