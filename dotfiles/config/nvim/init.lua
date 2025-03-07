-- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.mapleader = ","
vim.opt.completeopt = "menuone,preview,noinsert,popup"

require("armonge/environment")
require("armonge/defaults")
require("armonge/plugins")
require("armonge/filetypes")
require("armonge")
require("armonge/mappings")
