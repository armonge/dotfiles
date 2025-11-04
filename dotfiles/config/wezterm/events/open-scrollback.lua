local wezterm = require('wezterm')

local M = {}

function M.setup(opts)
  opts = opts or {}
  local event_name = opts.event_name or 'scrollback.open-in-editor'
  local editor = opts.editor or os.getenv('EDITOR') or 'nvim'
  local shell = os.getenv('SHELL') or '/bin/zsh'
  local function shq(s)
    return "'" .. tostring(s):gsub("'", "'\\''") .. "'"
  end

  wezterm.on(event_name, function(window, pane)
    -- Try to capture the full scrollback + viewport
    local lines_to_fetch = 1000000
    local ok_scrollback, sb_lines = pcall(function()
      return pane.get_scrollback_lines and pane:get_scrollback_lines()
    end)
    if ok_scrollback and type(sb_lines) == 'number' and sb_lines > 0 then
      -- Add some headroom to include the viewport
      lines_to_fetch = sb_lines + 10000
    end

    local text
    local ok_full, res = pcall(function()
      return pane:get_lines_as_text(lines_to_fetch)
    end)
    if ok_full and type(res) == 'string' and #res > 0 then
      text = res
    else
      -- Fallback for wezterm versions where the arg isn't supported
      text = pane:get_lines_as_text()
    end
    if not text or text == '' then
      wezterm.log_info('No scrollback text available to open in editor')
      return
    end

    local tmpname = os.tmpname()
    local ok, err
    do
      local f
      f, err = io.open(tmpname, 'w')
      if not f then
        wezterm.log_error('Failed to create temp file: ' .. tostring(err))
        return
      end
      f:write(text)
      f:close()
      ok = true
    end

    if ok then
      local cmd = editor .. ' ' .. shq(tmpname)
      window:perform_action(
        wezterm.action.SpawnCommandInNewTab({
          args = { shell, '-lc', cmd },
        }),
        pane
      )
    end
  end)
end

return M
