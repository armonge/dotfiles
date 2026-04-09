local wezterm = require("wezterm")
local platform = require("utils.platform")
local act = wezterm.action

local mod = {}

if platform.is_mac then
  mod.SUPER = "SUPER"
  mod.SUPER_REV = "SUPER|CTRL"
elseif platform.is_linux then
  mod.SUPER = "ALT"
  mod.SUPER_REV = "ALT|CTRL"
end

-- stylua: ignore
local keys = {
  { key = "Enter", mods = "SHIFT", action = wezterm.action { SendString = "\x1b\r" } },
  -- misc/useful --
  { key = 'F1',  mods = 'NONE', action = 'ActivateCopyMode' },
  { key = 'F2',  mods = 'NONE', action = act.ActivateCommandPalette },
  { key = 'F3',  mods = 'NONE', action = act.ShowLauncher },
  { key = 'F4',  mods = 'NONE', action = act.ShowLauncherArgs({ flags = 'FUZZY|TABS' }) },
  {
    key = 'F5',
    mods = 'NONE',
    action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),
  },
  -- Show all key bindings (like which-key)
  {
    key = '?',
    mods = 'LEADER',
    action = act.ShowLauncherArgs({ flags = 'FUZZY|KEY_ASSIGNMENTS', title = '🔑 Key Bindings' }),
  },
  { key = 'F6',  mods = 'NONE',    action = act.EmitEvent('scrollback.open-in-editor') },
  { key = 'F11', mods = 'NONE',    action = act.ToggleFullScreen },
  { key = 'F12', mods = 'NONE',    action = act.ShowDebugOverlay },
  { key = 'f',   mods = mod.SUPER, action = act.Search({ CaseInSensitiveString = '' }) },
  {
    key = 'u',
    mods = mod.SUPER_REV,
    action = wezterm.action.QuickSelectArgs({
      label = 'open url',
      patterns = {
        '\\((https?://\\S+)\\)',
        '\\[(https?://\\S+)\\]',
        '\\{(https?://\\S+)\\}',
        '<(https?://\\S+)>',
        '\\bhttps?://\\S+[)/a-zA-Z0-9-]+'
      },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.log_info('opening: ' .. url)
        wezterm.open_with(url)
      end),
    }),
  },

  -- quick select: git hash
  {
    key = 'g',
    mods = mod.SUPER_REV,
    action = wezterm.action.QuickSelectArgs({
      label = 'copy git hash',
      patterns = { '\\b[0-9a-f]{7,40}\\b' },
      action = wezterm.action_callback(function(window, pane)
        local hash = window:get_selection_text_for_pane(pane)
        window:copy_to_clipboard(hash, 'Clipboard')
      end),
    }),
  },
  -- quick select: file path
  {
    key = 'e',
    mods = mod.SUPER_REV,
    action = wezterm.action.QuickSelectArgs({
      label = 'copy file path',
      patterns = { '[\\w\\-\\./]+/[\\w\\-\\./]+' },
      action = wezterm.action_callback(function(window, pane)
        local path = window:get_selection_text_for_pane(pane)
        window:copy_to_clipboard(path, 'Clipboard')
      end),
    }),
  },

  -- cursor movement --
  { key = 'LeftArrow',  mods = mod.SUPER,     action = act.SendString '\u{1b}OH' },
  { key = 'RightArrow', mods = mod.SUPER,     action = act.SendString '\u{1b}OF' },
  { key = 'Backspace',  mods = mod.SUPER,     action = act.SendString '\u{15}' },

  -- copy/paste --
  { key = 'c',          mods = 'CTRL|SHIFT',  action = act.CopyTo('Clipboard') },
  { key = 'v',          mods = 'CTRL|SHIFT',  action = act.PasteFrom('Clipboard') },

  -- tabs --
  -- tabs: spawn+close
  { key = 't',          mods = mod.SUPER,     action = act.SpawnTab('DefaultDomain') },
  { key = 'w',          mods = mod.SUPER_REV, action = act.EmitEvent('confirm-close.close-tab') },

  -- tabs: navigation
  { key = '[',          mods = mod.SUPER,     action = act.ActivateTabRelative(-1) },
  { key = ']',          mods = mod.SUPER,     action = act.ActivateTabRelative(1) },
  { key = '[',          mods = mod.SUPER_REV, action = act.MoveTabRelative(-1) },
  { key = ']',          mods = mod.SUPER_REV, action = act.MoveTabRelative(1) },

  -- tab: title
  { key = '0',          mods = mod.SUPER,     action = act.EmitEvent('tabs.manual-update-tab-title') },
  { key = '0',          mods = mod.SUPER_REV, action = act.EmitEvent('tabs.reset-tab-title') },

  -- tab: hide tab-bar
  { key = '9',          mods = mod.SUPER,     action = act.EmitEvent('tabs.toggle-tab-bar'), },

  -- window --
  -- window: spawn windows
  { key = 'n',          mods = mod.SUPER,     action = act.SpawnWindow },

  -- window: zoom window
  {
    key = '-',
    mods = mod.SUPER,
    action = wezterm.action_callback(function(window, _pane)
      local dimensions = window:get_dimensions()
      if dimensions.is_full_screen then
        return
      end
      local new_width = dimensions.pixel_width - 50
      local new_height = dimensions.pixel_height - 50
      window:set_inner_size(new_width, new_height)
    end)
  },
  {
    key = '=',
    mods = mod.SUPER,
    action = wezterm.action_callback(function(window, _pane)
      local dimensions = window:get_dimensions()
      if dimensions.is_full_screen then
        return
      end
      local new_width = dimensions.pixel_width + 50
      local new_height = dimensions.pixel_height + 50
      window:set_inner_size(new_width, new_height)
    end)
  },


  -- panes --
  -- panes: split panes
  {
    key = [[\]],
    mods = mod.SUPER,
    action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
  },
  {
    key = [[\]],
    mods = mod.SUPER_REV,
    action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
  },

  -- panes: zoom+close pane
  { key = 'Enter', mods = mod.SUPER,     action = act.TogglePaneZoomState },
  { key = 'w',     mods = mod.SUPER,     action = act.EmitEvent('confirm-close.close-pane') },

  -- panes: navigation
  { key = 'k',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Up') },
  { key = 'j',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Down') },
  { key = 'h',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Left') },
  { key = 'l',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Right') },
  {
    key = 'p',
    mods = mod.SUPER_REV,
    action = act.PaneSelect({ alphabet = '1234567890', mode = 'SwapWithActiveKeepFocus' }),
  },

  -- panes: scroll pane
  { key = 'u',        mods = mod.SUPER, action = act.ScrollByLine(-5) },
  { key = 'd',        mods = mod.SUPER, action = act.ScrollByLine(5) },
  { key = 'PageUp',   mods = 'NONE',    action = act.ScrollByPage(-0.75) },
  { key = 'PageDown', mods = 'NONE',    action = act.ScrollByPage(0.75) },

  -- key-tables --
  -- resizes fonts
  {
    key = 'f',
    mods = 'LEADER',
    action = act.ActivateKeyTable({
      name = 'resize_font',
      one_shot = false,
      timeout_milliseconds = 1000,
    }),
  },
  -- resize panes
  {
    key = 'p',
    mods = 'LEADER',
    action = act.ActivateKeyTable({
      name = 'resize_pane',
      one_shot = false,
      timeout_milliseconds = 1000,
    }),
  },

  -- workspaces --
  {
    key = 's',
    mods = 'LEADER',
    action = act.PromptInputLine({
      description = wezterm.format({
        { Attribute = { Intensity = "Bold" } },
        { Text = "Enter name for new workspace" },
      }),
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(
            act.SwitchToWorkspace({ name = line }),
            pane
          )
        end
      end),
    }),
  },
  { key = 'n', mods = 'LEADER', action = act.SwitchWorkspaceRelative(1) },
  { key = 'b', mods = 'LEADER', action = act.SwitchWorkspaceRelative(-1) },
}

-- stylua: ignore
local key_tables = {
  resize_font = {
    { key = 'k',      action = act.IncreaseFontSize },
    { key = 'j',      action = act.DecreaseFontSize },
    { key = 'r',      action = act.ResetFontSize },
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'q',      action = 'PopKeyTable' },
  },
  resize_pane = {
    { key = 'k',      action = act.AdjustPaneSize({ 'Up', 1 }) },
    { key = 'j',      action = act.AdjustPaneSize({ 'Down', 1 }) },
    { key = 'h',      action = act.AdjustPaneSize({ 'Left', 1 }) },
    { key = 'l',      action = act.AdjustPaneSize({ 'Right', 1 }) },
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'q',      action = 'PopKeyTable' },
  },
}

local mouse_bindings = {
  -- Ctrl-click will open the link under the mouse cursor
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = act.OpenLinkAtMouseCursor,
  },
}

for i = 1, 8 do
  -- ALT + number to activate that tab
  table.insert(keys, {
    key = tostring(i),
    mods = mod.SUPER,
    action = act.ActivateTab(i - 1),
  })
end

return {
  disable_default_key_bindings = true,
  -- disable_default_mouse_bindings = true,
  leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 },
  keys = keys,
  key_tables = key_tables,
  mouse_bindings = mouse_bindings,
}
