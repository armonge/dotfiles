-- sql {
vim.g.sql_type_default = "sql.vim"
-- }

--  Open files with gx {
vim.keymap.set("n", "gx", "!xdg-open " .. vim.fn.shellescape("<WORD>") .. "<CR>")
--  }

-- lambdalisue/suda.vim {
vim.keymap.set("c", "w!!", "w suda://%")
-- }

-- vim-licenses {
vim.g.licenses_authors_name = "Andrés Reyes Monge <armonge@gmail.com>"
vim.g.licenses_copyright_holders_name = "Andrés Reyes Monge <armonge@gmail.com>"
-- }

-- junegunn/fzf {
-- vim.g.fzf_buffers_jump = 1
-- vim.keymap.set("n", "<C-p>", ":Files<CR>")
-- }

-- numToStr/Comment.nvim {
-- Add spaces after comment delimiters by default
require("Comment").setup()
-- }
--

-- AutoCloseTag {
-- Make it so AutoCloseTag works for xml and xhtml files as well
vim.api.nvim_create_autocmd("FileType", {
	pattern = "xhtml,xml",
	command = "runtime ftplugin/html/autoclosetag.vim",
})
vim.keymap.set("n", "<Leader>ac", "<Plug>ToggleAutoCloseMappings")
-- }
--editorconfig/editorconfig-vim {
vim.g.EditorConfig_preserve_formatoptions = 1
--}
