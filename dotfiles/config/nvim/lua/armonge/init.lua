Mapper = require("nvim-mapper")
local keyset = Mapper.map

-- sql {
vim.g.sql_type_default = "sql.vim"
-- }

--  Open files with gx {
keyset(
	"n",
	"gx",
	"!xdg-open " .. vim.fn.shellescape("<WORD>") .. "<CR>",
	{},
	"General",
	"open_with",
	"Opens a <WORD> with the default browser"
)
--  }

-- vim-licenses {
vim.g.licenses_authors_name = "Andrés Reyes Monge <armonge@gmail.com>"
vim.g.licenses_copyright_holders_name = "Andrés Reyes Monge <armonge@gmail.com>"
-- }

-- numToStr/Comment.nvim {
-- Add spaces after comment delimiters by default
require("Comment").setup()
-- }
