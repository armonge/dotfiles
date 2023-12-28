-- colorscheme {
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.cmd [[colorscheme tokyonight]]
-- }

-- nvim-lualine/lualine.nvim {

local lualine = require("lualine")
lualine.setup({
  theme = "tokyonight",
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
