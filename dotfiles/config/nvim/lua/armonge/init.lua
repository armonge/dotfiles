-- sql {
vim.g.sql_type_default = "sql.vim"
-- }

--  Open files with gx {
local wk = require("which-key")
wk.add({
	{ "gx", "!xdg-open " .. vim.fn.shellescape("<WORD>") .. "<CR>", desc = "Opens a <WORD> with the default browser" },
})
--  }

-- vim-licenses {
vim.g.licenses_authors_name = "Andrés Reyes Monge <armonge@gmail.com>"
vim.g.licenses_copyright_holders_name = "Andrés Reyes Monge <armonge@gmail.com>"
-- }
