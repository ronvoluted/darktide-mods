# Audio Plugin

## Library of audio/sound utilities for use in Warhammer 40,000: Darktide mods

### **[Available at Nexus Mods](https://www.nexusmods.com/warhammer40kdarktide/mods/196)**

- **Play custom audio files (with spatial positioning!)**
- Apply a range of audio filters/playback properties to custom audio
- Ergonomically trigger Wwise events/dialogue
- Use Wwise utilities to hook/replace/silence/log game sounds
- Developed with unit tests for added reliability when used in other mods

This was created to make it possible and easy to do things like replace explosion sounds with quacks, run a function whenever certain sounds play, replace Morrow's lines with Zola's or even your own recorded lines, silence all lasgun sounds or just one specific footstep SFX, log sounds to console when they occur, play Wwise sound events and dialogue voicelines on cue, use your own music, debug Wwise and open up a world of potential mods.

<p align="center">
	<a href="https://ko-fi.com/ronvoluted">
		<img alt="Support me on ko-fi.com" src="https://ko-fi.com/img/githubbutton_sm.svg">
	</a>
</p>

## Quick start

> **Important**
> [Darktide Local Server](https://www.nexusmods.com/warhammer40kdarktide/mods/211) is a dependency and must be installed. Put Audio directly after DarktideLocalServer in your mod_load_order.txt.
> Developer Mode and Show Developer Console currently must also be On to avoid window issues.

### Hook grenade bounce events to play custom audio

```lua
local Audio

mod.on_all_mods_loaded = function()
  Audio = get_mod("Audio")

  Audio.hook_sound("play_grenade_surface_impact", function(sound_type, sound_name, delta)
    if delta == nil or delta > 0.1 then
      Audio.play_file("squelch.mp3", { audio_type = "sfx" })
    end

    return false
  end)
end
```

#### Explanation:
- declare `Audio`
- wait for all mods to be loaded which:
  - initialises `Audio` with the library
  - creates the hook
  - makes this resilient to mod load orders where Audio is not loaded first
- hook any event with "play_grenade_surface_impact" in its event name
- debounce using `delta` so that no more than 10 sounds a second can be triggered
- play a local file from ".../Warhammer 40,000 DARKTIDE/mods/YourMod/audio/squelch.mp3"
- specify the audio type as "sfx" so that Options -> Audio -> Volume -> Sound Effects Volume slider will affect it
- return `false` so that the original hooked event, "play_grenade_surface_impact", will be silenced and not play

## Table of Contents

<ol>
  <li><details>
    <summary><a href="#playing-wwise-sounds">Playing Wwise sounds</a></summary>
    <ul>
      <li><a href="#level-up-sound">Level up sound</a></li>
      <li><a href="#ogryn-saying-why-you-all-look-so-gloomy-smile">Ogryn saying "Why you all look so gloomy? Smile!"</a></li>
      <li><a href="#sound-effect-at-a-specific-position">Sound effect at a specific position</a></li>
      <li><a href="#sound-effect-attached-to-a-specific-unit-will-move-with-it">Sound effect attached to a specific unit</a></li>
    </ul>
  </details></li>

  <li><details>
    <summary><a href="#playing-audio-files">Playing audio files</a></summary>
    <ul>
      <li><a href="#custom-audio-file">Custom audio file
      <li><a href="#custom-audio-file-sounding-as-if-it-came-from-the-centre-of-the-map">Custom audio file sounding as if it came from the centre of the map
      <li><a href="#allowing-game-options-to-adjust-volume-and-running-a-callback-once-the-file-finishes-playing">Allowing game options to adjust volume and running a callback once the file finishes playing
      <li><a href="#play-a-custom-audio-file-using-every-parameter">Play a custom audio file using every parameter
      <li><a href="#print-reference-id-for-this-play-instance-and-the-arguments-sent-to-ffplay">Print reference ID for this play instance and the arguments sent to ffplay
      </ul>
  </details></li>

  <li><a href="#stopping-custom-audio-files">Stopping custom audio files</a></li>

  <li><details>
    <summary><a href="#checking-whether-an-audio-file-is-playing">Checking whether an audio file is playing</a></summary>
    <ul>
      <li><a href="#setting-track_status">Setting <code>track_status</code></a></li>
    </ul>
  </details></li>

  <li>
    <a href="#path-handling-with-play_file">Path handling with <code>play_file</code></a>
  </li>

  <li><details>
    <summary><a href="#working-with-directories-using-the-file-handler">Working with directories using file handler</a></summary>
    <ul>
      <li>
        <a href="#initialising-the-file-handler">Initialising the file handler</a>
      </li>
      <li>
        <a href="#list-contents-of-the-root-directory">List contents of the root directory</a>
      </li>
      <li>
        <a href="#list-the-contents-of-a-subdirectory-of-root-folder">List the contents of a subdirectory of root folder</a>
      </li>
      <li>
        <a href="#get-count-of-audio-files">Get count of audio files</a>
      </li>
      <li>
        <a href="#get-flat-lookup-table-of-files">Get flat lookup table of files</a>
      </li>
      <li>
        <a href="#lookup-a-file-via-lookup_index">Lookup a file via <code>lookup_index</code></a>
      </li>
      <li>
        <a href="#lookup-a-file-via-lookup_index-and-return-with-metadata">Lookup a file via <code>lookup_index</code> and return with metadata</a>
      </li>
      <li>
        <a href="#play-a-random-file">Play a random file</a>
      </li>
      <li>
        <a href="#get-a-random-file-and-return-with-metadata">Get a random file and return with metadata</a>
      </li>
      <li>
        <a href="#iterate-over-files">Iterate over files</a>
      </li>
    </ul>
  </details></li>

  <li><details>
    <summary><a href="#hooking-wwise-sounds">Hooking Wwise sounds</a></summary>
    <ul>
      <li>
        <a href="#empty-example-with-all-parametersreturn-values">Empty example with all parameters/return values</a>
      </li>
    </ul>
  </details></li>

  <li><details>
    <summary><a href="#wwise-sound-events">Wwise sound events</a></summary>
    <ul>
      <li>
        <a href="#arguments-passed-to-hook_sound-callback-function">Arguments passed to <code>hook_sound()</code> callback function</a>
      </li>
      <li><a href="#mute-all-ui-sounds">Mute all UI sounds</a></li>
      <li>
        <a href="#add-explosions-to-bullet-impacts-debounced-to-01-seconds">Add explosions to bullet impacts</a>
      </li>
    </ul>
  </details></li>

  <li><details>
    <summary><a href="#wwise-external-dialogue-events">Wwise external dialogue events</a></summary>
    <ul>
      <li>
        <a href="#arguments-passed-to-hook_sound-callback-function-1">Arguments passed to <code>hook_sound()</code> callback function</a>
      </li>
      <li>
        <a href="#play-dial-up-modem-sounds-whenever-hadron-speaks">Play dial-up modem sounds whenever Hadron speaks</a>
      </li>
      <li>
        <a href="#replace-i-need-healing-comms-wheel-voicelines-with-thanks">Replace "I need healing!" comms wheel voicelines with "Thanks!"</a>
      </li>
    </ul>
  </details></li>

  <li><details>
    <summary><a href="#silencing-sounds">Silencing sounds</a></summary>
    <ul>
      <li>
        <a href="#silence-a-single-match-pattern">Silence a single match pattern</a>
      </li>
      <li>
        <a href="#silence-multiple-match-patterns">Silence multiple match patterns</a>
      </li>
    </ul>
  </details></li>

  <li>
    <a href="#unsilencing-sounds">Unsilencing sounds</a>
  </li>

  <li>
    <a href="#checking-silenced-sounds">Checking silenced sounds</a>
  </li>

  <li>
    <a href="#limitations">Limitations</a>
  </li>

  <li>
    <a href="#roadmap">Roadmap</a>
  </li>

  <li>
    <a href="#licences">Licences</a>
  </li>
</ol>

## Guide

### Playing Wwise sounds

```lua
Audio.play(wwise_event_name_or_loc, unit_or_position_or_id, node_or_rotation_or_boolean)
```

**return** `number`: The Wwise source ID of this sound.

Use this to play existing sound effects and voicelines from the game. Note that sounds may not always be triggerable, particularly if they're for equipment not currently equipped. If provided, `unit_or_position_or_id` should be either a unit or Vector3 for use with SFX events and a wwise_source_id number for use with `loc_` voicelines.
#### Level up sound
```lua
Audio.play("wwise/events/ui/play_ui_eor_character_lvl_up")
```

#### Ogryn saying "Why you all look so gloomy? Smile!"
```lua
Audio.play("loc_ogryn_a__combat_pause_one_liner_07")
```

#### Sound effect at a specific position
```lua
Audio.play("wwise/events/cinematics/play_fatshark_splash", Vector3(10, 20, 30))
```

#### Sound effect attached to a specific unit (will move with it)
```lua
Audio.play("wwise/events/cinematics/play_fatshark_splash", beast_of_nurgle_unit)
```
### Playing audio files

```lua
Audio.play_file(path, playback_settings, unit_or_position, decay, min_distance, max_distance, override_position, override_rotation)
```

Place audio files in an "audio" folder directly at the root of your mod folder. Custom audio uses ffplay under the hood and is best suited to short audio playback (see [Limitations](#limitations)).

`path` is the only required argument and the file can be almost any audio type (mp3, wav, flac, ogg, opus, etc. Midi not supported.) but Opus is recommended.

Besides `audio_type` and `track_status`, all the keys of `playback_settings` correspond to [options](https://ffmpeg.org/ffplay.html) and [filter](https://ffmpeg.org/ffmpeg-filters.html#Audio-Filters) flags from ffplay. The list below contains links directly to each option/filter's documentation which explains the syntax required.

- **path\*** `string`: Filename of the audio to play
- **playback_settings** `table`: 
  - **audio_type** `string (dialogue|music|sfx)`: Specify volume category to allow adjusting via game options
  - **track_status** `boolean|function`: If any truthy value, will enable the use of `is_file_playing()` which will be updated every 1s. If `track_status` is a function, it will also be run as a callback after the file stops playing. The callback currently receives no parameters (suggestions welcome for useful data to pass back).
  - **[duration](https://ffmpeg.org/ffplay.html#toc-Main-options)** `string`: Play duration of the file
  - **[loop](https://ffmpeg.org/ffplay.html#toc-Main-options)** `number`: Number of times the file will loop. Defaults to `1`. Set to `0` to loop indefinitely.
  - **[pos](https://ffmpeg.org/ffplay.html#toc-Main-options)** `string`: Seek position
  - **[adelay](https://ffmpeg.org/ffmpeg-filters.html#adelay)** `string`: Delay one or more audio channels
  - **[aecho](https://ffmpeg.org/ffmpeg-filters.html#aecho)** `string`: Apply echoing to the input audio
  - **[afade](https://ffmpeg.org/ffmpeg-filters.html#afade-1)** `string`: Apply fade-in/out effect to input audio
  - **[atempo](https://ffmpeg.org/ffmpeg-filters.html#atempo)** `string`: Adjust speed of playback
  - **[chorus](https://ffmpeg.org/ffmpeg-filters.html#chorus)** `string`: Add a chorus effect to the audio
  - **[silenceremove](https://ffmpeg.org/ffmpeg-filters.html#silenceremove)** `string`: Remove silence from the audio
  - **[speechnorm](https://ffmpeg.org/ffmpeg-filters.html#speechnorm)** `string`: Normalise audio for speech
  - **[stereotools](https://ffmpeg.org/ffmpeg-filters.html#stereotools)** `string`: Manage stereo signals
  - **[volume](https://ffmpeg.org/ffplay.html#toc-Main-options)** `number`: Further adjust volume. Range of 1 - 100.
- **unit_or_position** `userdata (Vector3|Unit)`:
  - If `Vector3`: location that audio will play from
  - If `Unit`: use that unit's position
  - If `nil`, will treat as 2D audio and use the player's position


- **decay** `float`: How rapidly volume drops off. Suggested range is 0   - 0.05. Defaults to 0.01.
- **min_distance** `float (metres)`: Distance from player for which volume will be always be 100%. Defaults to 0.
- **max_distance** `float (metres)`: Distance from player at which volume decays to 0%. Defaults to 100.
- **override_position** `Vector3`: Position if you want to use a listener different to player for calculating volume/panning
- **override_rotation** `Quaternion`: Set a custom listening rotation (e.g. if player is upside down) or use to align `override_position`

**return:**
- play_file_id `number`: Reference ID for this play instance, used with `stop_file(play_file_id)` and `is_file_playing(play_file_id)`
- command `string`: The constructed CLI command sent to ffplay

#### Custom audio file
```lua
Audio.play_file("chime.mp3")
```

#### Custom audio file sounding as if it came from the centre of the map
```lua
Audio.play_file("howling.wav", Vector3.zero())
```

#### Allowing game options to adjust volume and running a callback once the file finishes playing
```lua
local play_file_id = Audio.play_file("ImmortalImperium.opus", {
  audio_type = "music",
  track_status = function()
    Jukebox.queue_next_track()
  end,
})
```

#### Play a custom audio file using every parameter

```lua
local play_file_id, command = Audio.play_file("ImperialAdvance.ogg", {
    audio_type = "music", -- Use game's music volume options to adjust volume
    track_status = function() print("For the Emperor!") end, -- Run a callback function when the file stops
    duration = 10, -- Trim audio to 10 seconds
    loop = 3, -- Repeat for 3 iterations total
    adelay = "500:all=1", -- Delay playing all channels for half a second
    aecho = "0.8:0.9:1000:0.3", -- Sound like an open air concert in the mountains
    afade = "t=in:ss=0:d=3", -- Fade in over 3 seconds
    atempo = 2, -- Play at 200% speed
    chorus = "0.6:0.9:50|60:0.4|0.32:0.25|0.4:2|1.3", -- Apply chorus effect
    silenceremove = "start_periods=1:stop_periods=1", -- Trim silence
    speechnorm = "e=50:r=0.0001:l=1", -- Normalise speech with moderate and slow amplification
    stereotools = "mode=ms>lr", -- Use mono as stereo
    volume = 85, -- Adjust volume to 85%
  },
  vox_radio_unit, -- play from an Imperial propaganda boombox's position
  0.05, -- Set rate of volume dropoff as you get further away to 0.05
  5, -- If within 5 meters, play at 100% volume
  80, -- If further than 80 meters, play at 0% volume
  Vector3(-30, 20, -10), -- Override player position, listening as if you were somewhere else
  Quaternion.from_elements(0, 0, 0, 1) -- Override player rotation
)
```

#### Print reference ID for this play instance and the arguments sent to ffplay
1 `play_file()` = 1 `play_file_id` = 1 ffplay instance

```lua
print(play_file_id, command) 
```

### Stopping custom audio files

```lua
Audio.stop_file(play_file_id)
```

- **play_file_id** `number`: The `play_file_id` returned from `play_file()`. If omitted, the function will stop **all** playing files.

### Checking whether an audio file is playing

```lua
Audio.is_file_playing(play_file_id)
```
- **play_file_id*** `number`: The `play_file_id` returned from `play_file()`.

**return** `boolean`: Whether the file's status is playing.

> **Important**
> To make use of this, `track_status` must be set in the `playback_settings` parameter of `play_file()`. Under the hood, the ffplay instance attached to the file is tracked using a server request once every second.

#### Setting `track_status`

```lua
local play_file_id = Audio.play_file("fire_sfx_08.opus", {
  audio_type = "sfx",
  track_status = true, -- This enables the use of `is_file_playing`
})
```

```lua
local play_file_id = Audio.play_file("bob_voiceline_for_the_emperor.opus", {
  audio_type = "music",
  track_status = function() -- Callback functions will also allow `is_file_playing` to work
    Audio.play("jane_voiceline_for_the_emperor_reply.opus")
  end,
})
```

### Path handling with `play_file()`

- Forward slashes "/" or escaped backward slashes "\\\\" can be used.
- Absolute paths will be used as-is
- Paths beginning with your mod name will be relative to ".../Warhammer 40,000 DARKTIDE/mods/"
- Otherwise, paths will be relative to ".../Warhammer 40,000 DARKTIDE/mods/YourModName/audio/"

These are all equivalent:
```lua
Audio.play_file("C:/Program Files (x86)/Steam/steamapps/common/Warhammer 40,000 DARKTIDE/mods/MyMod/audio/sfx/quack.mp3")
Audio.play_file("MyMod/audio/sfx/quack.mp3")
Audio.play_file("sfx/quack.mp3")
```

As are these:
```lua
Audio.play_file("C:/Program Files (x86)/Steam/steamapps/common/Warhammer 40,000 DARKTIDE/mods/MyMod/scripts/mods/MyMod/arbitrary_folder/quack.mp3")
Audio.play_file("MyMod/arbitrary_folder/quack.mp3")
```

### Working with directories using the file handler

If you have many files to play you may not want to hardcode the paths to all of them, or you may not even know what they will be in advance if you allow players to add their own audio. You can use `new_files_handler()` to read a directory's audio contents, get metadata, lookup a flat table of all files or play random files.

```lua
Audio.new_files_handler(placeholder_table, sub_directory_override)
```

- **placeholder_table** `table`: Optional list of files to fallback to before promise fulfills
- **sub_directory_override** `string`: Optional. If provided, will start from subdirectory of "audio" as root. Only supports 1 level down from "audio".

**return** `AudioFilesHandler`: An initialised instance of the `AudioFilesHandler` class

#### Initialising the file handler

```lua
local audio_files

mod.on_all_mods_loaded = function()
  audio_files = Audio.new_files_handler()
end
```

This will create a handle to a list of contents for the audio files in your mod's "audio" directory. e.g. "...Warhammer 40,000 DARKTIDE/mods/YourMod/audio". Non-audio files will be ignored based on the MIME type of their file extension.

> [!NOTE]
> When `AudioFilesHandler` is initialised, its `init` function will await a promise in the background as it reads the directory contents. For reference, scanning a folder of 4,226 files nested in sub directories to find and process 128 audio files took 3 seconds on an SSD.

For the rare circumstance where you need to play files in the first few seconds after mods load, there is an option to provide a `placeholder_table` fallback that will be used before the promise fulfills:

```lua
audio_files = Audio.new_files_handler({ "woof.wav", "bark.mp3" })
```

While it's recommended to organise your "audio" folder as the root of your audio files, you can also start the file handler in a subdirectory of "audio" by passing a `sub_directory_override` 2nd parameter:

```lua
audio_files = Audio.new_files_handler(nil, "sfx/gunshots")
-- root path will be "...Warhammer 40,000 DARKTIDE/mods/YourMod/audio/sfx/gunshots"
```

Once initialised, you can access a range of methods on the instance:

#### List the contents of "...Warhammer 40,000 DARKTIDE/mods/YourMod/audio"

```lua
mod:dump(audio_files:list(), 'contents of "audio" folder', 99)
```

```
<contents of "audio" folder>
[1] = table
  [lookup_index] = 2 (number)
  [file_path] = bark.mp3 (string)
  [channels] = 2 (number)
  [duration] = 1.6119999885559082 (number)
  [sample_rate] = 44100 (number)
[2] = table
  [lookup_index] = 1 (number)
  [file_path] = woof.wav (string)
  [channels] = 1 (number)
  [duration] = 1.0420000553131104 (number)
  [sample_rate] = 44100 (number)
[sfx] = table
  [gunshots] = table
    [1] = table
      [lookup_index] = 3 (number)
      [file_path] = sfx/gunshots/magnum_6.ogg (string)
      [channels] = 2 (number)
      [duration] = 2.489990234375 (number)
      [sample_rate] = 44100 (number)
      [artist] = Clint Eastwood (string)
      [title] = Magnum Gunshot 6 (string)
      [album] = Weapon SFX Collection 40K (string)
      [track] = 6 (number)
</contents of "audio" folder>
```

#### List the contents of a subdirectory of the "audio" folder

```lua
mod:dump(audio_files:list("sfx/gunshots"), 'contents of "audio/sfx/gunshots" folder', 99)
```

```
<contents of "audio/sfx/gunshots" folder>
[1] = table
  [lookup_index] = 3 (number)
  [file_path] = sfx/gunshots/magnum_6.ogg (string)
  [channels] = 2 (number)
  [duration] = 2.489990234375 (number)
  [sample_rate] = 44100 (number)
  [artist] = Clint Eastwood (string)
  [title] = Magnum Gunshot 6 (string)
  [album] = Weapon SFX Collection 40K (string)
  [track] = 6 (number)
</contents of "audio/sfx/gunshots" folder>
```

#### Get count of audio files

```lua
local num_audio_files = audio_files:count() -- 3
```

#### Get flat lookup table of files

In addition to the nested tree structure returned from `audio_files:list()`, a flat table of all files is also generated with each file assigned a unique `lookup_index`. This can be simpler to iterate over than the nested table.

```lua
mod:dump(audio_files:lookup())
```

```
[1] = table
  [lookup_index] = 1 (number)
  [file_path] = woof.wav (string)
  [channels] = 1 (number)
  [duration] = 1.0420000553131104 (number)
  [sample_rate] = 44100 (number)
[2] = table
  [lookup_index] = 2 (number)
  [file_path] = bark.mp3 (string)
  [channels] = 2 (number)
  [duration] = 1.6119999885559082 (number)
  [sample_rate] = 44100 (number)
[3] = table
  [lookup_index] = 3 (number)
  [file_path] = sfx/gunshots/magnum_6.ogg (string)
  [channels] = 2 (number)
  [duration] = 2.489990234375 (number)
  [sample_rate] = 44100 (number)
  [artist] = Clint Eastwood (string)
  [title] = Magnum Gunshot 6 (string)
  [album] = Weapon SFX Collection 40K (string)
  [track] = 6 (number)
```

#### Lookup a single file via `lookup_index`

```lua
print(audio_files:lookup(2)) -- "bark.mp3"
```

#### Lookup a file via `lookup_index` and return with metadata

```lua
print(audio_files:lookup(2, true))
```

```
[lookup_index] = 2 (number)
[file_path] = bark.mp3 (string)
[channels] = 2 (number)
[duration] = 1.6119999885559082 (number)
[sample_rate] = 44100 (number)
```

#### Play a random file

```lua
Audio.play_file(audio_files:random()) -- any random file in "audio" and subdirectories
Audio.play_file(audio_files:random("sfx")) -- "audio/sfx" and subdirectories
Audio.play_file(audio_files:random("sfx/gunshots")) -- "audio/sfx/gunshots" and subdirectories
```

#### Get a random file and return with metadata

```lua
local random_file = (audio_files:random(nil, true))
local random_sfx_file = (audio_files:random("sfx", true))
local random_gunshot_file = (audio_files:random("sfx/gunshots", true))
```

#### Iterate over files

Mainly used for debugging.

```lua
-- return file_path only
local next_file_path = audio_files:next()
Audio.play_file(next_file_path)

-- return with metadata
local next_file = audio_files:next(true)
Audio.play_file(next_file.file_path)
mod:dump(next_file)

-- return current file of iterator (with metadata)
local current_file = audio_files:current(true)
mod:dump(current_file)

-- return current cursor index of iterator
local current_cursor_index = audio_files:cursor_index()
print(current_cursor_index)
```

### Hooking Wwise sounds

```lua
Audio.hook_sound(pattern, callback)
```

- **pattern\*** `string`: Lua match pattern for the event/s to hook, allowing wildcard logic instead of only strictly matching full strings
- **callback\*** `function`: Callback function that will run when an event is hooked. Optionally, if this function returns a value of `false` (not just `nil`) the hooked event will be silenced. The following arguments are passed, however their meaning will differ between Wwise sound events and Wwise external dialogue events:
  - sound_type
  - sound_name
  - delta
  - position_or_unit_or_id
  - optional_a
  - optional_b

#### Empty example with all parameters/return values

```lua
Audio.hook_sound("xxx", function(sound_type, sound_name, delta, position_or_unit_id, optional_a, optional_b)
  --
  return false
end)
```


> [!TIP]
> If `play_file()` will be rapidly called within a hook, it's good practice to [debounce](#add-explosions-to-bullet-impacts-debounced-to-01-seconds) the plays using `delta` and a minimum thereshold of 0.1 seconds 

### Wwise sound events

These are SFX with a resource path of `"wwise/events/xxx/xxx"`.

#### Arguments passed to `hook_sound()` callback function:

- **sound_type** `string (2d_sound|3d_sound|start_stop_event|external_sound|source_sound|unit_sound)`: The type of Wwise event triggered, determined by `position_or_unit_or_id` variable type
- **sound_name** `string`: The `wwise_event_name` e.g. "wwise/events/player/play_footstep_boots_medium"
- **delta** `number|nil`: Time in seconds since the function has last run or `nil` if never run
- **position_or_unit_or_id** `userdata(Vector3|unit)|number`: Argument used by Wwise in various ways
- **optional_a** `number|userdata(Vector3|unit)`: Argument used by Wwise in various ways with "unit_sound" and "start_stop_event" events
- **optional_b** `number`: Argument used by Wwise with some "start_stop_event" events

#### Mute all UI sounds

```lua
Audio.hook_sound("wwise/events/ui/play", function()
  return false
end)
```

#### Add explosions to bullet impacts, debounced to 0.1 seconds
```lua
Audio.hook_sound("play_bullet_hits_gen", function(_, __, delta, position_or_unit_or_id)
  if delta == nil or delta > 0.1 then
    Audio.play("wwise/events/weapon/play_explosion_grenade_frag", position_or_unit_or_id, {
      audio_type = "sfx"
    })
    Audio.play("wwise/events/weapon/play_explosion_refl_gen", position_or_unit_or_id, {
      audio_type = "sfx"
    })
  end
end)
```

##### Explanation:
- hook events with a `"play_bullet_hits_gen"` match pattern
- from the the callback function:
  - ignore `sound_type` and `sound_name` arguments
  - receive `delta`, the time in seconds since this hook was last run or `nil` if first time running 
  - receive `position_or_unit_or_id`, which in this case is the original position of the bullet hits
- debounce using `delta` so that sounds can only play once every 0.1 seconds, preventing rapid overlaps and framerate spikes
- play two Wwise events at the same time:
  - specify "sfx" to take into account the volume set in game Options
  - pass original position to `play()` so that the explosions sound closer/further and more left/right accordingly
### Wwise external dialogue events

These are dialogue lines with a resource path of `"wwise/externals/loc_xxx"`. Both `Audio.hook_sound()` and `Audio.play()` will automatically handle the `"wwise/externals/"` portion so you can just use the `"loc_xxx"` sound name for those functions. If you use non Audio Plugin functions, remember to use the full path.

#### Arguments passed to `hook_sound()` callback function:

- **sound_type** `string`: Always "external_sound"
- **sound_name** `string`: The `file_path` minus "wwise/externals/" e.g. "loc_veteran_male_b__lore_abhumans_one_a_03"
- **delta** `number|nil`: Time in seconds since the function has last run or `nil` if never run
- **position_or_unit_or_id** `number`: The `wwise_source_id` referring to a Wwise source
- **optional_a** `string`: The `sound_event` e.g. "wwise/events/vo/play_sfx_es_player_vo"
- **optional_b** `string`: The `sound_source` e.g. "es_vo_prio_1"

#### Play dial-up modem sounds whenever Hadron speaks
```lua
Audio.hook_sound("loc_tech_priest_a", function()
  Audio.play_file("dialup_modem_tone.wav")
end)
```
#### Replace "I need healing!" comms wheel voicelines with "Thanks!"

```lua
Audio.hook_sound(
	"com_wheel_vo_need_health",
	function(sound_type, sound_name, delta, position_or_unit_or_id)
		local new_sound_name = sound_name:gsub("need_health", "thank_you")
		new_sound_name = new_sound_name:sub(1, -3) .. "01"

		Audio.play(new_sound_name, position_or_unit_or_id)

		return false
	end
)
```

##### Using `"loc_zealot_female_c__com_wheel_vo_thank_you_06"` as an example of a hooked match:

1. Hook Wwise events matching the pattern `"com_wheel_vo_need_health"`
2. Replace `"need_health"` with `"thank_you"` so that the new sound name is `"loc_zealot_female_c__com_wheel_vo_thank_you_06"`
3. Not all events have the same number of alternatives. If `"loc_zealot_female_c__com_wheel_vo_thank_you_XX"` only went up to `05`, attempting to trigger `06` could cause a crash. We use `"loc_zealot_female_c__com_wheel_vo_thank_you_01"` here just in case but if you know the existing `loc_xxx_XX` options ahead of time you could clamp/randomise this suffix.
4. Play the new sound name at the original source using its `wwise_source_id` given by `position_or_unit_or_id`
5. Return `false` from the hook to silence the original `"need_health"` event

### Silencing sounds

Besides returning `false` in the callback function of `hook_sound()` to silence an event, you can also directly silence events with `silence_sounds()`. This is useful if your hook's match pattern matches multiple events but you do not want to call a callback multiple times.

#### Silence a single match pattern
```lua
Audio.silence_sounds("revolver")
```

#### Silence multiple match patterns
```lua
Audio.silence_sounds({
  "play_sfx_es_traitor_enforcer_executor_vo",
  "loc_explicator_a__hub_idle_conversation_one_b_01",
  "wwise/events/minions/play_terror_event_alarm",
})
```

### Unsilencing sounds
Silencing in the above manner can be reversed. Use the same function signature with `unsilence_sounds()` to unsilence them. Note that this will not override a return of `false` from the `hook_sound()` callback.

### Checking silenced sounds

You can also check whether an event name is currently being silenced with:

```lua
Audio.is_sound_silenced(wwise_event_name)
```

## Limitations
- Audio file spatial positioning is locked-in at moment of play— moving the player afterwards will not update its volume/panning (no Doppler effects/approaching sounds)
- Starting more than ~10 audio files within a second can cause performance issues. You can [`loop`](#playing-audio-files) them multiple times with no issue however.
- The developer console must be on, otherwise the game will minimise when running server commands. Methods to avoid this are beeing looked into.

## Roadmap
- [x] Fix slow beta implementation of `stop_file`~~
- [x] Finish implementing `is_file_playing` to check whether a file is still playing
- [x] Add table of contents to docs
- [x] Implement smarter path handling for filenames starting with the mod name
- [x] Build more unit tests
- [x] Add ability to play from folders/play random
- [ ] Add option to log to chat window
- [ ] Add option to toggle logging silenced sounds or not
- [ ] Refactor of `delta` calculation. Currently, multiple matching patterns for the same event will be treated as separate events.
- [ ] Add caption utilities
- [ ] Add beta implementation of live position-updateable audio files
- [ ] Finish implementing log-saving utilities to crowdsource building list of known Wwise events

## Licences

This mod makes use of FFplay Windows build version 2023-06-11-git-09621fd7d9 under the GPLv3 license from [gyan.dev](https://www.gyan.dev/ffmpeg/builds/) unmodified.

This software uses code of [FFMpeg](http://ffmpeg.org) licensed under the [LGPLv2.1](http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html) and its source can be downloaded [here](https://github.com/GyanD/codexffmpeg/releases/tag/2023-06-11-git-09621fd7d9).
