local wezterm = require("wezterm")
local umath = require("utils.math")
local Cells = require("utils.cells")
local OptsValidator = require("utils.opts-validator")

---@alias Event.RightStatusOptions { date_format?: string }

---Setup options for the right status bar
local EVENT_OPTS = {}

---@type OptsSchema
EVENT_OPTS.schema = {
  {
    name = "date_format",
    type = "string",
    default = "%a %H:%M:%S",
  },
}
EVENT_OPTS.validator = OptsValidator:new(EVENT_OPTS.schema)

local nf = wezterm.nerdfonts
local attr = Cells.attr

local M = {}

local ICON_SEPARATOR = nf.oct_dash
local ICON_DATE = nf.fa_calendar
local ICON_KEY_TABLE = nf.md_keyboard
local ICON_WORKSPACE = nf.cod_window
local ICON_CWD = nf.md_folder

---@type string[]
local discharging_icons = {
  nf.md_battery_10,
  nf.md_battery_20,
  nf.md_battery_30,
  nf.md_battery_40,
  nf.md_battery_50,
  nf.md_battery_60,
  nf.md_battery_70,
  nf.md_battery_80,
  nf.md_battery_90,
  nf.md_battery,
}
---@type string[]
local charging_icons = {
  nf.md_battery_charging_10,
  nf.md_battery_charging_20,
  nf.md_battery_charging_30,
  nf.md_battery_charging_40,
  nf.md_battery_charging_50,
  nf.md_battery_charging_60,
  nf.md_battery_charging_70,
  nf.md_battery_charging_80,
  nf.md_battery_charging_90,
  nf.md_battery_charging,
}

---@type table<string, Cells.SegmentColors>
-- stylua: ignore
local colors = {
  date      = { fg = '#fab387', bg = 'rgba(0, 0, 0, 0.4)' },
  battery   = { fg = '#f9e2af', bg = 'rgba(0, 0, 0, 0.4)' },
  separator = { fg = '#74c7ec', bg = 'rgba(0, 0, 0, 0.4)' },
  key_table = { fg = '#a6e3a1', bg = 'rgba(0, 0, 0, 0.6)' },
  workspace = { fg = '#cba6f7', bg = 'rgba(0, 0, 0, 0.4)' },
  cwd       = { fg = '#89b4fa', bg = 'rgba(0, 0, 0, 0.4)' },
}

local cells = Cells:new()

cells
    :add_segment("key_table_icon", ICON_KEY_TABLE .. "  ", colors.key_table, attr(attr.intensity("Bold")))
    :add_segment("key_table_text", "", colors.key_table, attr(attr.intensity("Bold")))
    :add_segment("key_table_separator", " " .. ICON_SEPARATOR .. "  ", colors.separator)
    :add_segment("workspace_icon", ICON_WORKSPACE .. "  ", colors.workspace, attr(attr.intensity("Bold")))
    :add_segment("workspace_text", "", colors.workspace, attr(attr.intensity("Bold")))
    :add_segment("workspace_separator", " " .. ICON_SEPARATOR .. "  ", colors.separator)
    :add_segment("cwd_icon", ICON_CWD .. "  ", colors.cwd, attr(attr.intensity("Bold")))
    :add_segment("cwd_text", "", colors.cwd, attr(attr.intensity("Bold")))
    :add_segment("cwd_separator", " " .. ICON_SEPARATOR .. "  ", colors.separator)
    :add_segment("date_icon", ICON_DATE .. "  ", colors.date, attr(attr.intensity("Bold")))
    :add_segment("date_text", "", colors.date, attr(attr.intensity("Bold")))
    :add_segment("separator", " " .. ICON_SEPARATOR .. "  ", colors.separator)
    :add_segment("battery_icon", "", colors.battery)
    :add_segment("battery_text", "", colors.battery, attr(attr.intensity("Bold")))

---@return string, string
local function battery_info()
  -- ref: https://wezfurlong.org/wezterm/config/lua/wezterm/battery_info.html

  local charge = ""
  local icon = ""

  for _, b in ipairs(wezterm.battery_info()) do
    local idx = umath.clamp(umath.round(b.state_of_charge * 10), 1, 10)
    charge = string.format("%.0f%%", b.state_of_charge * 100)

    if b.state == "Charging" then
      icon = charging_icons[idx]
    else
      icon = discharging_icons[idx]
    end
  end

  return charge, icon .. " "
end

---@param opts? Event.RightStatusOptions Default: {date_format = '%a %H:%M:%S'}
M.setup = function(opts)
  local valid_opts, err = EVENT_OPTS.validator:validate(opts or {})

  if err then
    wezterm.log_error(err)
  end

  wezterm.on("update-right-status", function(window, pane)
    local battery_text, battery_icon = battery_info()
    local key_table = window:active_key_table()
    local workspace = window:active_workspace()

    -- Shorten cwd: ~/projects/dotfiles -> ~/p/dotfiles (keep last component full)
    local cwd_uri = pane:get_current_working_dir()
    local cwd = ""
    if cwd_uri then
      local path = cwd_uri.file_path or ""
      local home = os.getenv("HOME") or ""
      if home ~= "" and path:sub(1, #home) == home then
        path = "~" .. path:sub(#home + 1)
      end
      -- Shorten intermediate components to first char
      local parts = {}
      for part in path:gmatch("[^/]+") do
        table.insert(parts, part)
      end
      if #parts > 2 then
        for i = 1, #parts - 1 do
          parts[i] = parts[i]:sub(1, 1)
        end
      end
      cwd = table.concat(parts, "/")
    end

    cells
        :update_segment_text("date_text", wezterm.strftime(valid_opts.date_format))
        :update_segment_text("battery_icon", battery_icon)
        :update_segment_text("battery_text", battery_text)

    -- Build segments list conditionally
    local segments = {}
    if key_table then
      cells:update_segment_text("key_table_text", key_table)
      table.insert(segments, "key_table_icon")
      table.insert(segments, "key_table_text")
      table.insert(segments, "key_table_separator")
    end

    -- Workspace (skip if it's just "default")
    if workspace and workspace ~= "default" then
      cells:update_segment_text("workspace_text", workspace)
      table.insert(segments, "workspace_icon")
      table.insert(segments, "workspace_text")
      table.insert(segments, "workspace_separator")
    end

    -- Current working directory
    if cwd ~= "" then
      cells:update_segment_text("cwd_text", cwd)
      table.insert(segments, "cwd_icon")
      table.insert(segments, "cwd_text")
      table.insert(segments, "cwd_separator")
    end

    table.insert(segments, "date_icon")
    table.insert(segments, "date_text")
    table.insert(segments, "separator")
    table.insert(segments, "battery_icon")
    table.insert(segments, "battery_text")

    window:set_right_status(wezterm.format(cells:render(segments)))
  end)
end

return M
