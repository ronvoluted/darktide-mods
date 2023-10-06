# Audio Plugin

## Library of audio/sound utilities for use in Warhammer 40,000: Darktide mods

### **[Available at Nexus Mods](https://www.nexusmods.com/warhammer40kdarktide/mods/196)**

- **Play custom audio files (with spatial positioning!)**
- Apply a range of audio filters/playback properties to custom audio
- Ergonomically trigger WWise sounds/events
- Use WWise utilities to hook/replace/silence/log game sounds
- Developed with unit tests for added reliability when used in other mods

This library mod was created to make it possible and easy to do things like replace explosion sounds with quacks, run a function whenever certain sounds play, replace Morrow's lines with Zola's or even your own recorded lines, silence a specific grunt or all lasgun sounds, play sound effects and dialogue voicelines on cue, debug Wwise and do all sorts of modifications.

<p align="center">
	<a href="https://ko-fi.com/ronvoluted">
		<img alt="Support me on ko-fi.com" src="https://ko-fi.com/img/githubbutton_sm.svg">
	</a>
</p>

## Quick start

> **Important**
> [Darktide Local Server](https://www.nexusmods.com/warhammer40kdarktide/mods/211) is a dependency and must be installed. Put AudioPlugin directly after DarktideLocalServer in your mod_load_order.txt.

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

This code:
- declares `Audio`
- waits for all mods to be loaded and:
  - initialises `Audio` with the library
  - creates the hook
  - makes this resilient to mod load orders where Audio is not loaded first
- hooks any event with "play_grenade_surface_impact" in its event name
- debounce using `delta` so that no more than 10 sounds a second can be triggered
- plays a local "squelch.mp3" file
- specifies the audio type as "sfx" so that Options -> Audio -> Volume -> Sound Effects Volume slider will affect it
- returns `false` so that the original hooked event, "play_grenade_surface_impact" will be silenced and not play

## Guide

### Playing WWise sounds

```lua
Audio.play(wwise_event_name_or_loc, unit_or_position_or_id, node_or_rotation_or_boolean)
```

Use this to play existing sound effects and voicelines from the game. Note that sounds may not always be triggerable, particularly if they're for equipment not currently equipped. If provided, `unit_or_position_or_id` should be either a unit or Vector3 for use with SFX events and a wwise_source_id number for use with `loc_` voicelines.
#### Level up sound
```lua
mod.play("wwise/events/ui/play_ui_eor_character_lvl_up")
```

#### Ogryn saying "Why you all look so gloomy? Smile!"
```lua
mod.play("loc_ogryn_a__combat_pause_one_liner_07")
```

#### Sound effect at a specific position
```lua
mod.play("wwise/events/cinematics/play_fatshark_splash", Vector3(10, 20, 30))
```

#### Sound effect attached to a specific unit (will move with it)
```lua
mod.play("wwise/events/cinematics/play_fatshark_splash", beast_of_nurgle_unit)
```
### Playing audio files

```lua
Audio.play_file(path, playback_settings, unit_or_position, decay, min_distance, max_distance, override_position, override_rotation)
```

Place audio files in an `"audio"` folder directly at the root of your mod folder. Custom audio uses ffplay under the hood and is best suited to short audio playback (see [Limitations](#)).

`path` is the only required argument and the file can be almost any audio type (mp3, wav, flac, ogg, opus, etc. Midi not supported.)

Besides `audio_type`, all the keys of `playback_settings` correspond to [options](https://ffmpeg.org/ffplay.html) and [filter](https://ffmpeg.org/ffmpeg-filters.html#Audio-Filters) flags from ffplay. The list below contains links directly to each option/filter's documentation which explains the syntax required.

- **path\*** `string`: Filename of the audio to play
- **playback_settings** `table`: 
  - **audio_type** `string (dialogue|music|sfx)`: Specify volume category to allow adjusting via game options
  - **[duration](https://ffmpeg.org/ffplay.html#toc-Main-options)** `string`: Play duration of the file
  - **[loop](https://ffmpeg.org/ffplay.html#toc-Main-options)** `number`: Number of times the file will loop. Defaults to `1`. Set to `0` to loop indefinitely.
  - **[pos](https://ffmpeg.org/ffplay.html#toc-Main-options)** `string`: Seek position
  - **[adelay](https://ffmpeg.org/ffmpeg-filters.html#adelay)** `string`: Delay one or more audio channels
  - **[aecho](https://ffmpeg.org/ffmpeg-filters.html#aecho)** `string`: Apply echoing to the input audio
  - **[afade](https://ffmpeg.org/ffmpeg-filters.html#afade-1)** `string`: Apply fade-in/out effect to input audio
  - **[atempo](https://ffmpeg.org/ffmpeg-filters.html#atempo)** `string`: Adjust speed of playback
  - **[chorus](https://ffmpeg.org/ffmpeg-filters.html#chorus)** `string`: Add a chorus effect to the audio
  - **[silenceremove](https://ffmpeg.org/ffmpeg-filters.html#silenceremove)** `string`: Remove silence from the audio
  - **[speechnorm](https://ffmpeg.org/ffmpeg-filters.html#speechnorm)** `string`: Normalise audio fo speech
  - **[stereotools](https://ffmpeg.org/ffmpeg-filters.html#stereotools)** `string`: Manage stereo signals
  - **[volume](https://ffmpeg.org/ffplay.html#toc-Main-options)** `number``: Further adjust volume. Range of 1 - 100.
- **unit_or_position** `userdata (Vector3|Unit)`:
  - If `Vector3`: location that audio will play from
  - If `Unit`: use that unit's position
  - If `nil`, will treat as 2D audio and use the player's position


- **decay** `float`: How rapidly volume drops off. Suggested range is 0   - 0.05. Defaults to 0.01.
- **min_distance** `float (metres)`: Distance from player for which volume will be always be 100%. Defaults to 0.
- **max_distance** `float (metres)`: Distance from player at which volume decays to 0%. Defaults to 100.
- **override_position** `Vector3`: Position if you want to use a listener different to player for calculating volume/panning
- **override_rotation** `Quaternion`: Set a custom listening rotation (e.g. if player is upside down) or use to align `override_position`

**return**
- play_file_id `number`: Reference ID for this play instance, used with `Audio.stop_file(play_file_id)`
- command `string`: The constructed CLI command sent to ffplay

#### Custom audio file
```lua
Audio.play_file("chime.mp3")
```

#### Custom audio file sounding as if it came from the centre of the map
```lua
Audio.play_file("howling.wav", Vector3.zero())
```

#### Play a custom audio file using every parameter

```lua
local play_file_id, command = Audio.play_file("ImperialAdvance.ogg", {
    duration = 10, -- Trim audio to 10 seconds
    loop = 3, -- Repeat for 3 iterations total
    adelay = "500|500", -- Delay playing for half a second (left|right channel)
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
  Quaternion.from_elements(0, 0, 0, 1), -- Override player rotation
)
```

#### Print reference ID for this play instance and the arguments sent to ffplay
1 `play_file()` = 1 `play_file_id` = 1 ffplay instance

```lua
print(play_file_id, command) 
```

### Stopping custom audio files

Note that this is currently quite slow and causes a lockup of ~30ms.

```lua
Audio.stop_file(play_file_id)
```

- **play_file_id** `number`: The `play_file_id` returned from `play_file()`. If omitted, the function will stop **all** instances of ffplay_dt.exe

### Checking whether an audio file is playing

**On roadmap to implement. Returns `nil` for now.**

```lua
Audio.is_file_playing(play_file_id)
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

### Hooking Wwise sounds

```lua
Audio.hook_sound(pattern, callback)
```

- **pattern\*** `string`: Lua match pattern for the event/s to hook, allowing wildcard logic instead of only strictly matching full strings
- **callback\*** `function`: Callback function that will run when an event is hooked. If this function returns a value of `false`, the hooked event will be silenced. The following arguments are passed, however their meaning will differ between Wwise sound events and Wwise external dialogue events:
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


> **Note**
> If `Audio.play_file()` will be rapidly called within a hook, it's good practice to [debounce](#hook-grenade-bounce-events-to-play-custom-audio) the plays using `delta` and a minium thereshold of 0.1 seconds 

### Wwise sound events

These are SFX with a resource path of `"wwise/events/xxx/xxx"`.

#### Arguments passed to `Audio.hook_sound()` callback `function()`:

- **sound_type** `string (2d_sound|3d_sound|start_stop_event|external_sound|source_sound|unit_sound)`: The type of WWise event triggered, determined by `position_or_unit_or_id` variable type
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
Audio.hook_sound("play_bullet_hits_gen", function(sound_type, sound_name, delta, position_or_unit_or_id)
  if delta == nil or delta > 0.1 then
    Audio.play("wwise/events/weapon/play_explosion_grenade_frag", position_or_unit_or_id)
    Audio.play("wwise/events/weapon/play_explosion_refl_gen", position_or_unit_or_id)
  end
end)
```

This code:
- hooks events with a `"play_bullet_hits_gen"` match pattern
- receives the time in seconds since this hook was last run (`nil` if first time running) to the callback function
- receives the original position of the bullet hits to the callback function
- debounces so that the explosions can only play once every 0.1 seconds
- passes the original position to `play()` so that the explosions sound closer/furthe and more left/right accordingly
### WWise external dialogue events

These are dialogue lines with a resource path of `"wwise/externals/loc_xxx"`. Both `Audio.hook_sound()` and `Audio.play()` will automatically handle the `"wwise/externals/"` portion so you can just use the `"loc_xxx"` sound name for those functions. If you use non Audio Plugin functions, remember to use the full path.

#### Arguments passed to `Audio.hook_sound()` callback `function()`:

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
	mod,
	"com_wheel_vo_need_health",
	function(sound_type, sound_name, delta, position_or_unit_or_id)
		local new_sound_name = sound_name:gsub("need_health", "thank_you")
		new_sound_name = new_sound_name:sub(1, -3) .. "01"

		Audio.play(new_sound_name, position_or_unit_or_id)

		return false
	end
)
```

Using `"loc_zealot_female_c__com_wheel_vo_thank_you_06"` as an example of a hooked match, this code:

1. Hook WWise events matching the pattern `"com_wheel_vo_need_health"`
2. Replace `"need_health"` with `"thank_you"` so that the new sound name is `"loc_zealot_female_c__com_wheel_vo_thank_you_06"`
3. Not all events have the same number of alternatives. If `"loc_zealot_female_c__com_wheel_vo_thank_you_XX"` only went up to `05`, attempting to trigger `06` could cause a crash. We use `"loc_zealot_female_c__com_wheel_vo_thank_you_01"` here just in case but if you know the existing `loc_xxx_XX` options ahead of time you could clamp/randomise this suffix.
4. Play the new sound name at the original source using its `wwise_source_id` given by `position_or_unit_or_id`
5. Return `false` from the hook to silence the original `"need_health"` event

### Silencing sounds

Besides returning `false` in the callback function of `Audio.hook_sound()` to silence an event, you can also directly silence events with `Audio.silence_sounds()`. This is useful if your hook's match pattern matches multiple events but you do not want to call a callback multiple times.

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
Silencing in the above manner can be reversed. Use the same function signature with `Audio.unsilence_sounds()` to unsilence them. Note that this will not override a return of `false` from the `Audio.hook_sound()` callback.

### Checking silenced sounds

You can also check whether an event name is currently being silenced with:

```lua
Audio.is_sound_silenced(wwise_event_name)
```

## Limitations
- Audio file spatial positioning is locked-in at moment of play— moving the player afterwards will not update its volume/panning (no Doppler effects/approaching sounds)
- Starting more than ~10 audio files within a second can cause performance issues. You can [`loop`](#playing-audio-files) them multiple times with no issue however.

## Roadmap
- Fix slow beta implementation of `stop_file`
- Finish implementing `is_file_playing` to check whether a file is still playing
- Finish implementing logging utilities to crowdsource building list of known WWise events
- Add option to toggle logging silenced sounds or not
- Build more unit tests coverage

## Licences

This mod makes use of FFplay Windows build version 2023-06-11-git-09621fd7d9 under the GPLv3 license from [gyan.dev](https://www.gyan.dev/ffmpeg/builds/) unmodified.

This software uses code of [FFMpeg](http://ffmpeg.org) licensed under the [LGPLv2.1](http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html) and its source can be downloaded [here](https://github.com/GyanD/codexffmpeg/releases/tag/2023-06-11-git-09621fd7d9).
