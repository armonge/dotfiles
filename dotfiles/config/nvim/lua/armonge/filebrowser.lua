-- kevinhwang91/rnvimr {
vim.g.rnvimr_ranger_cmd =
	{ "env", "PYENV_VERSION=nvim3", "PYTHONDEVMODE=0", "PYTHONWARNINGS=ignore", "pyenv", "exec", "ranger" }
vim.g.rnvimr_enable_ex = 1
vim.g.rnvimr_enable_picker = 1
vim.g.rnvimr_enable_bw = 1
vim.g.rnvimr_hide_gitignore = 1
vim.g.rnvimr_enable_bw = 1

-- Resize floating window by all preset layouts
vim.keymap.set("t", "<M-i>", "<C-\\><C-n>:RnvimrResize<CR>", { silent = true })
-- Resize floating window by single preset layout
vim.keymap.set("t", "<M-y>", "<C-\\><C-n>:RnvimrResize 2<CR>", { silent = true })

-- Toggle
vim.keymap.set("n", "<C-e>", ":RnvimrToggle<CR>", { silent = true })
vim.keymap.set("t", "<C-e>", "<C-\\><C-n>:RnvimrToggle<CR>", { silent = true })
-- }
-- utilyre/barbecue.nvim{
require("barbecue").setup()
-- }
