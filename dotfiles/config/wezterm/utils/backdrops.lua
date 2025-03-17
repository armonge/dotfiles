local wezterm = require("wezterm")
local colors = wezterm.color.get_builtin_schemes()["Tokyo Night Storm (Gogh)"]

---@class BackDrops
---@field current_idx number index of current image
---@field focus_color string background color when in focus mode. Default is `colors.custom.background`
---@field focus_on boolean focus mode on or off
local BackDrops = {}
BackDrops.__index = BackDrops

--- Initialise backdrop controller
---@private
function BackDrops:init()
  local inital = {
    current_idx = 1,
    focus_color = colors.background,
    focus_on = false,
  }
  local backdrops = setmetatable(inital, self)
  return backdrops
end

---Override the default `focus_color`
---Default `focus_color` is `colors.custom.background`
---@param focus_color string background color when in focus mode
function BackDrops:set_focus(focus_color)
  self.focus_color = focus_color
  return self
end

---Create the `background` options with the current image
---@private
---@return table
function BackDrops:_create_opts()
  return {
    {
      source = { Color = colors.background },
      height = "120%",
      width = "120%",
      vertical_offset = "-10%",
      horizontal_offset = "-10%",
      opacity = 0.96,
    },
  }
end

---Create the `background` options for focus mode
---@private
---@return table
function BackDrops:_create_focus_opts()
  return {
    {
      source = { Color = self.focus_color },
      height = "120%",
      width = "120%",
      vertical_offset = "-10%",
      horizontal_offset = "-10%",
      opacity = 1,
    },
  }
end

---Set the initial options for `background`
---@param focus_on boolean? focus mode on or off
function BackDrops:initial_options(focus_on)
  focus_on = focus_on or false
  assert(type(focus_on) == "boolean", "BackDrops:initial_options - Expected a boolean")

  self.focus_on = focus_on
  if focus_on then
    return self:_create_focus_opts()
  end

  return self:_create_opts()
end

---Override the current window options for background
---@private
---@param window any WezTerm Window see: https://wezfurlong.org/wezterm/config/lua/window/index.html
---@param background_opts table background option
function BackDrops:_set_opt(window, background_opts)
  window:set_config_overrides({
    background = background_opts,
    enable_tab_bar = window:effective_config().enable_tab_bar,
  })
end

---Override the current window options for background with focus color
---@private
---@param window any WezTerm Window see: https://wezfurlong.org/wezterm/config/lua/window/index.html
function BackDrops:_set_focus_opt(window)
  local opts = {
    background = {
      {
        source = { Color = self.focus_color },
        height = "120%",
        width = "120%",
        vertical_offset = "-10%",
        horizontal_offset = "-10%",
        opacity = 1,
      },
    },
    enable_tab_bar = window:effective_config().enable_tab_bar,
  }
  window:set_config_overrides(opts)
end

---Toggle the focus mode
---@param window any WezTerm `Window` see: https://wezfurlong.org/wezterm/config/lua/window/index.html
function BackDrops:toggle_focus(window)
  local background_opts

  if self.focus_on then
    background_opts = self:_create_opts()
    self.focus_on = false
  else
    background_opts = self:_create_focus_opts()
    self.focus_on = true
  end

  self:_set_opt(window, background_opts)
end

return BackDrops:init()
