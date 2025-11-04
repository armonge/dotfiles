local wezterm = require('wezterm')

local M = {}

-- List of processes that are considered "safe" to close without confirmation
-- These are typically shells or very short-lived commands
local safe_processes = {
  'bash',
  'zsh',
  'fish',
  'sh',
  'ksh',
  'tcsh',
  'csh',
  'nu',
  'elvish',
}

-- Check if a process name is in the safe list
local function is_safe_process(process_name)
  if not process_name then
    return true
  end

  -- Extract just the command name without path or arguments
  local cmd = process_name:match("([^/]+)$") or process_name
  cmd = cmd:match("^(%S+)") or cmd

  for _, safe in ipairs(safe_processes) do
    if cmd:lower():match(safe) then
      return true
    end
  end

  return false
end

function M.setup(opts)
  opts = opts or {}

  -- Handle close pane with confirmation
  wezterm.on('confirm-close.close-pane', function(window, pane)
    local process_info = pane:get_foreground_process_info()
    local process_name = process_info and process_info.name or nil

    -- If it's a safe process, close without confirmation
    if is_safe_process(process_name) then
      window:perform_action(
        wezterm.action.CloseCurrentPane({ confirm = false }),
        pane
      )
      return
    end

    -- Show confirmation dialog for running commands
    window:perform_action(
      wezterm.action.CloseCurrentPane({ confirm = true }),
      pane
    )
  end)

  -- Handle close tab with confirmation
  wezterm.on('confirm-close.close-tab', function(window, pane)
    local tab = window:active_tab()
    if not tab then
      return
    end

    -- Check all panes in the tab for running processes
    local has_running_process = false
    for _, pane_obj in ipairs(tab:panes()) do
      local process_info = pane_obj:get_foreground_process_info()
      local process_name = process_info and process_info.name or nil

      if not is_safe_process(process_name) then
        has_running_process = true
        break
      end
    end

    -- If any pane has a running process, confirm before closing
    if has_running_process then
      window:perform_action(
        wezterm.action.CloseCurrentTab({ confirm = true }),
        pane
      )
    else
      window:perform_action(
        wezterm.action.CloseCurrentTab({ confirm = false }),
        pane
      )
    end
  end)
end

return M
