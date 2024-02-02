local wk = require("which-key")

-- kevinhwang91/rnvimr {
vim.g.rnvimr_ranger_cmd = {
	"env",
	"PYENV_VERSION=nvim3",
	"PYTHONDEVMODE=0",
	"PYTHONWARNINGS=ignore",
	"pyenv",
	"exec",
	"ranger",
}
vim.g.rnvimr_enable_ex = 1 -- replace netrw
vim.g.rnvimr_enable_picker = 1 -- use Ranger as a picker
vim.g.rnvimr_enable_bw = true
vim.g.rnvimr_hide_gitignore = true

wk.register({
	name = "Ranger",
	["<M-i>"] = { "<C-\\><C-n>:RnvimrResize<CR>", "Reiszes ranger to default layout" },
	["<M-y>"] = { "<C-\\><C-n>:RnvimrResize 2<CR>", "Reiszes ranger to second layout" },
	["<C-e>"] = { "<C-\\><C-n>:RnvimrToggle<CR>", "Toggles Ranger" },
}, { mode = "t" })

wk.register({
	name = "Ranger",
	["<C-e>"] = { "<C-\\><C-n>:RnvimrToggle<CR>", "Toggles Ranger" },
}, { mode = "n" })
