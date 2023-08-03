# Audio Plugin

**Library for Warhammer 40,000: Darktide mods to enable playing custom audio files and managing WWise events**

WIP! The WWise utilities are not ready for use but will be used to easily mute, replace, hook or log specific audio events. See [Limitations](#)

[Available at Nexus Mods](https://www.nexusmods.com/warhammer40kdarktide/mods/196)

## Usage

### Initialise library

A specific mod load order is not required.

```lua
local Audio

mod.on_all_mods_loaded = function()
	Audio = get_mod("Audio")
end
```

### Copy files
Place audio files in a `"media"` folder directly at the root of your mod folder.

### Play audio

```lua
Audio.play("quack.mp3")
```

### Function signature
```lua
Audio.play(path, source_position, decay, min_distance, max_distance, override_position, override_rotation)
```

`path` is the only required argument and the file can be almost any audio type (mp3, wav, ogg, opus, etc. Midi not supported.)

- **path** `string`: Filename to play. Can be an absolute path, or if relative, will automatically resolve for the mod that called it
- **source_position** `Vector3`: Direction of audio. If nil, will treat as 2D audio and use the player's position.
- **decay** `float`: How rapidly volume drops off. Suggested range is 0 - 0.05, defaults to 0.
- **min_distance** `float (metres)`: The minimum distance for which volume will be always be 100%, defaults to 0.
- **max_distance** `float (metres)`: The distance at which volume drops to 0%, defaults to 100.
- **audio_type** `string ("music" | "sfx" | "vo")`: Used to allow game settings to adjust volume (WIP)
- **override_position** `Vector3`: Position if you want to use a listener different to player for calculating volume/panning
- **override_rotation** `Quaternion`: Rotation to orient `override_position` if used

**return** `string`: The CLI command sent to ffplay to play the file

### Paths

The library first assumes audio files are in a "media" folder directly inside your mod folder but will resolve to a reasonable absolute path if you provide a relative path. These are all equivalent:
```lua
Audio.play("quack.mp3")
Audio.play("media/quack.mp3")
Audio.play("MyMod/media/quack.mp3")
Audio.play("C:\\Program Files (x86)\\Steam\\steamapps\\common\\Warhammer 40,000 DARKTIDE\\mods\\MyMod\\media\\quack.mp3")
```

As are these:
```lua
Audio.play("scripts/mods/MyMod/modules/quack.mp3")
Audio.play("MyMod/scripts/mods/MyMod/modules/quack.mp3")
Audio.play("C:\\Program Files (x86)\\Steam\\steamapps\\common\\Warhammer 40,000 DARKTIDE\\mods\\MyMod\\scripts\\modules\\quack.mp3")
```

### Example playing audio as if it came from a unit:

```lua
local play_audio_from_unit(unit, path)
  local unit_position = Unit.local_position(unit, 1)

	Audio.play(path, unit_position, 0.02, nil, nil, "sfx")
end

play_audio_from_unit(dreg_shotgunner_unit, "ribbit.ogg")
```

### Example chat command
```lua
mod:command("play", "Play audio file", function(filename)
	Audio.play(filename or "default.opus")
end)
```

## Limitations
- **There is a ~0.03s lockup when excuted**, so it's not suitable for successive plays.
- Positional audio is only at moment of play— rotating the camera afterwards will not update its volume/panning.
- At the moment, audio cannot be stopped programatically once played. Open Task Manager and end `ffplay.exe` if you are stuck with a long-playing file.
- At the moment, **a stereo file must be used if you provide a `source_position`** for panning to work properly

## Licences

This mod makes use of FFplay Windows build version 2023-06-11-git-09621fd7d9 under the GPLv3 license from [gyan.dev](https://www.gyan.dev/ffmpeg/builds/) unmodified.

This software uses code of [FFMpeg](http://ffmpeg.org) licensed under the [LGPLv2.1](http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html) and its source can be downloaded [here](https://github.com/GyanD/codexffmpeg/releases/tag/2023-06-11-git-09621fd7d9).

