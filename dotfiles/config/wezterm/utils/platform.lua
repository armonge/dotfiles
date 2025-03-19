local wezterm = require("wezterm")

local function is_found(str, pattern)
  return string.find(str, pattern) ~= nil
end

---@alias PlatformType  'linux' | 'mac'

---@return {os: PlatformType, is_linux: boolean, is_mac: boolean}
local function platform()
  local is_linux = is_found(wezterm.target_triple, "linux")
  local is_mac = is_found(wezterm.target_triple, "apple")
  local os

  if is_linux then
    os = "linux"
  elseif is_mac then
    os = "mac"
  else
    error("Unknown platform")
  end

  return {
    os = os,
    is_linux = is_linux,
    is_mac = is_mac,
  }
end

local _platform = platform()

return _platform
