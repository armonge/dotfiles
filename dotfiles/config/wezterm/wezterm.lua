-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.scrollback_lines = 105500

-- For example, changing the color scheme:
config.color_scheme = "tokyonight_storm"
config.font = wezterm.font("JetBrains Mono")
config.allow_win32_input_mode = true
config.use_dead_keys = false
config.native_macos_fullscreen_mode = true
config.integrated_title_button_style = "Gnome"

config.keys = {

	{

		key = "UpArrow",
		mods = "ALT",
		action = act.ToggleFullScreen,
	},
}
for i = 1, 8 do
	-- ALT + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "ALT",
		action = act.ActivateTab(i - 1),
	})
end

config.keys = {
	{ key = "{", mods = "SHIFT|ALT", action = act.MoveTabRelative(-1) },
	{ key = "}", mods = "SHIFT|ALT", action = act.MoveTabRelative(1) },
}

-- and finally, return the configuration to wezterm
return config
