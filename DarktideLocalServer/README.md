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
local DLS

mod.on_all_mods_loaded = function()
	DLS = get_mod("DarktideLocalServer")

	if not DLS then
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

### Fetch images locally

```lua
DLS.get_image(path)
```

This is a wrapper around `Managers.url_loader.load_texture` so if you were previously using something like this:
```lua
local texture_promise = Managers.url_loader:load_texture("https://webservertextures.dt/ForTheEmperor.png")
```

You can now use this to load an image locally:
```lua
local texture_promise = DLS.get_image("C:/textures/ForTheEmperor.png")
```

> [!TIP]
> For a full working example of loading custom textures, take a look at the [source code for ScrubsVermin](https://github.com/ronvoluted/darktide-mods/tree/main/ScrubsVermin) which is a small mod made to demonstrate how to use `DLS.get_image()` with the UI.

### List directory contents

> [!IMPORTANT]
> The server will only list the contents of Darktide/mods folders and will otherwise fail

```lua
DLS.list_directory(
	"C:/Program Files (x86)/Steam/steamapps/common/Warhammer 40,000 DARKTIDE/mods/ForTheEmperor/scripts/mods/ForTheEmperor",
	true -- Navigate subdirectories
):next(function(contents)
	-- do something with `contents`
end)
```

The value of `contents` would be:
```
{
  "ForTheEmperor.lua"
  "ForTheEmperor_data.lua"
  "ForTheEmperor_localization.lua"
  "modules/add_strings.lua"
  "modules/custom_entry_actions.lua"
  "modules/dibs_option.lua"
  "modules/need_help.lua"
  "modules/wheel_options.lua"
}
```

#### Using all parameters

> [!TIP]
> See the [function's definition for full docstrings](https://github.com/ronvoluted/darktide-mods/blob/main/DarktideLocalServer/scripts/mods/DarktideLocalServer/DarktideLocalServer.lua#L104-L112).

```lua
DLS.list_directory(
	"C:/Program Files (x86)/Steam/steamapps/common/Warhammer 40,000 DARKTIDE/mods/SomeMod",
	true, -- Navigate subdirectories
	true, -- Include general metadata
	true, -- Include files if they have audio MIME type and include metad
	true, -- Include files if they have image MIME type and include metadata
	"TheBigE", -- prepend this to all `file_path`s
):next(function(contents)
	DLS:dump(contents, "contents", 99)
end)
```

Example dump (truncated here for brevity) of text, audio and image contents and subdirectories with metadata:
```
<contents>
	[1] = table
		[lookup_index] = 3 (number)
		[file_path] = TheBigE/magnum_6.ogg (string)
		[channels] = 2 (number)
		[duration] = 2.489990234375 (number)
		[sample_rate] = 44100 (number)
		[artist] = Clint Eastwood (string)
		[title] = Magnum Gunshot 6 (string)
		[album] = Weapon SFX Collection 40K (string)
		[track] = 6 (number)
	[2] = table
		[width] = 1920 (number)
		[height] = 804 (number)
		[last_modified] = 1686065582 (number)
		[file_size] = 402 (number)
		[lookup_index] = 2 (number)
		[file_path] = TheBigE/WillOfTheEmperor_6.jpg (string)
		[type] = file (string)
		[created_at] = 1701083573 (number)
		[mime_type] = image/jpeg (string)
	[3] ...
	[modules] = table
		[1] = table
			[last_modified] = 1701500497 (number)
			[mime_type] = text/x-lua (string)
			[file_size] = 1 (number)
			[type] = file (string)
			[file_path] = TheBigE/modules/add_strings.lua (string)
			[created_at] = 1701083570 (number)
			[lookup_index] = 5 (number)
		[2] ...
</contents>
```

### Run whitelisted executables

```lua
DLS.run_command(command)
```

The first argument in `command` must be the path to a whitelisted executable and surrounded by double quotes if it contains spaces. You may need to be mindful of how backslashes `\` and double-quotes `"` are escaped.

> **Note**
> The following executables are for demonstrative purposes. To have an executable whitelisted, file a request issue at [github.com/ronvoluted/darktide-local-server](https://github.com/ronvoluted/darktide-local-server/issues/new?assignees=ronvoluted&labels=enhancement&projects=&template=whitelist-request.md&title=Whitelist+request)

#### Basic examples

```lua
-- Open Calculator
DLS.run_command("calculator")

-- Handle the response when the promise is fulfilled
DLS.run_command("calculator"):next(function(response)
	mod:dump(response)
end)

-- Handle the promise as a reference
local request = DLS.run_command("calculator")

requst:next(function(response)
	mod:dump(response)
end)
```

#### Construct arguments
```lua
local executable_path = "C:/Program Files (x86)/Steam/steamapps/common/Warhammer 40,000 DARKTIDE/mods/YourMod/bin/youtube-dl"
local video_url = "https://youtube.com/watch?v=9eZOL-S7KGw"
local retries = 5

DLS.run_command(string.format("%s %s --retries %s", executable_path, video_url, retries))
```

#### Parse JSON and handle errors

```lua
local command = "notepad ForTheEmperor!.txt"
local promise = DLS.run_command(command)

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
