-- andersevenrud/nordic.nvim {
vim.opt.termguicolors = true
vim.opt.background = "dark"
-- vim.cmd.colorscheme("nordic")
-- }

-- nvim-lualine/lualine.nvim {

local lualine = require("lualine")
lualine.setup({
  theme = "nord",
  sections = {

    lualine_c = {
      {

        "filename",
        path = 1,
      },
    },
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "GoyoEnter",
  callback = function()
    lualine.hide()
  end,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "GoyoLeave",
  callback = function()
    lualine.hide({ unhide = true })
  end,
})

-- The table used in this example contains the default settings.
-- Modify or remove these to your liking (this also applies to alternatives below):
require("nordic").colorscheme({
  -- Underline style used for spelling
  -- Options: 'none', 'underline', 'undercurl'
  underline_option = "none",

  -- Italics for certain keywords such as constructors, functions,
  -- labels and namespaces
  italic = true,

  -- Italic styled comments
  italic_comments = false,

  -- Minimal mode: different choice of colors for Tabs and StatusLine
  minimal_mode = false,

  -- Darker backgrounds for certain sidebars, popups, etc.
  -- Options: true, false, or a table of explicit names
  -- Supported: terminal, qf, vista_kind, packer, nvim-tree, telescope, whichkey
  alternate_backgrounds = false,

  -- Callback function to define custom color groups
  -- See 'lua/nordic/colors/example.lua' for example defitions
  custom_colors = function(c, s, cs)
    return {}
  end,
})

-- Markkdown {
vim.api.nvim_create_autocmd("User", {
  pattern = "GoyoEnter",
  command = "Limelight",
})
vim.api.nvim_create_autocmd("User", {
  pattern = "GoyoLeave",
  command = "Limelight!",
})
-- }
