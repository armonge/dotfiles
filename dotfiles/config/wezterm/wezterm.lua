-- Pull in the wezterm API
-- local wezterm = require("wezterm")
-- local act = wezterm.action

-- -- This table will hold the configuration.
-- local config = {}
--
-- -- In newer versions of wezterm, use the config_builder which will
-- -- help provide clearer error messages
-- if wezterm.config_builder then
--   config = wezterm.config_builder()
-- end
--
-- -- This is where you actually apply your config choices
-- config.scrollback_lines = 105500
-- config.color_scheme = "Tokyo Night Storm (Gogh)"
-- config.font = wezterm.font("JetBrains Mono")
-- config.allow_win32_input_mode = true
-- config.use_dead_keys = false
-- config.native_macos_fullscreen_mode = true
-- config.integrated_title_button_style = "Gnome"
-- config.enable_kitty_keyboard = true
--
-- config.keys = {
--   { key = "UpArrow",   mods = "ALT",        action = act.ToggleFullScreen },
--   { key = "l",         mods = "ALT",        action = wezterm.action.ShowLauncher },
--   { key = "UpArrow",   mods = "CTRL|SHIFT", action = wezterm.action.MoveTabRelative(-1) },
--   { key = "DownArrow", mods = "CTRL|SHIFT", action = wezterm.action.MoveTabRelative(1) },
-- }
-- for i = 1, 8 do
--   -- ALT + number to activate that tab
--   table.insert(config.keys, {
--     key = tostring(i),
--     mods = "ALT",
--     action = act.ActivateTab(i - 1),
--   })
-- end
--
-- -- and finally, return the configuration to wezterm
-- return config

local Config = require("config")

require("events.left-status").setup()
require("events.right-status").setup({ date_format = "%a %H:%M:%S" })
require("events.tab-title").setup({ hide_active_tab_unseen = false, unseen_icon = "circle" })
require("events.new-tab-button").setup()

return Config:init()
    :append(require("config.appearance"))
    :append(require("config.bindings"))
    :append(require("config.domains"))
    :append(require("config.fonts"))
    :append(require("config.general"))
    :append(require("config.launch")).options
