local mod = get_mod("DarktideLocalServer")

local enable_portproxy = false
local binaries_path_handle = Mods.lua.io.popen("cd")
local binaries_path = binaries_path_handle:read()
binaries_path_handle:close()
local config_path = table.concat({
	binaries_path:gsub("binaries", "mods"),
	mod:get_name(),
	"bin",
	"config.json",
}, "\\")
local config_handle = Mods.lua.io.open(config_path, "rb")

if config_handle then
	local config_json = config_handle:read("*a")
	config_handle:close()

	if config_json then
		local ok, config = pcall(cjson.decode, config_json)
		if ok and type(config) == "table" then
			enable_portproxy = config.enable_portproxy == true
		end
	end
end

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = false,
	options = {
		widgets = {
			{
				setting_id = "enable_portproxy",
				type = "checkbox",
				tooltip = "enable_portproxy_description",
				default_value = enable_portproxy,
			},
		},
	},
}
