local platform = require("utils.platform")

local options = {
  default_prog = {},
  launch_menu = {},
}

if platform.is_mac then
  options.default_prog = { "/opt/homebrew/bin/bash", "-l" }
  options.launch_menu = {
    { label = "Bash", args = { "/opt/homebrew/bin/bash", "-l" } },
    { label = "Zsh",  args = { "zsh", "-l" } },
  }
elseif platform.is_linux then
  options.default_prog = { "bash", "-l" }
  options.launch_menu = {
    { label = "Bash", args = { "bash", "-l" } },
    { label = "Zsh",  args = { "zsh", "-l" } },
  }
end

return options
