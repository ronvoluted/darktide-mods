local dmf = get_mod("DMF")

local _io = dmf:persistent_table("_io")
local _os = dmf:persistent_table("_os")

_io.initialized = _io.initialized or false
_os.initialized = _os.initialized or false

if not _io.initialized then
	_io = dmf.deepcopy(Mods.lua.io)
end

if not _os.initialized then
	_os = dmf.deepcopy(Mods.lua.os)
end

local APPDATA_DIR = _os.getenv("AppData") .. "\\Fatshark\\Darktide\\"
local CONFIG_PATH = APPDATA_DIR .. "user_settings.config"
local BACKUP_PATH = APPDATA_DIR .. "user_settings_backup.config"

_os.execute(string.format('copy /b "%s" "%s" > nul', CONFIG_PATH, BACKUP_PATH))
