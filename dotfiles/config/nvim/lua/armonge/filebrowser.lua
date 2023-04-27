Mapper = require("nvim-mapper")
local keyset = Mapper.map
local opts = { silent = true, noremap = true }

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
vim.g.rnvimr_enable_ex = 1
vim.g.rnvimr_enable_picker = 1
vim.g.rnvimr_enable_bw = 1
vim.g.rnvimr_hide_gitignore = 1
vim.g.rnvimr_enable_bw = 1

-- Resize floating window by all preset layouts
keyset(
	"t",
	"<M-i>",
	"<C-\\><C-n>:RnvimrResize<CR>",
	opts,
	"Ranger",
	"resize_default",
	"Resizes ranger to the default layout"
)
-- Resize floating window by single preset layout
keyset(
	"t",
	"<M-y>",
	"<C-\\><C-n>:RnvimrResize 2<CR>",
	opts,
	"Ranger",
	"resize_layout_2",
	"Resizes ranger to second layout"
)

-- Toggle
keyset("n", "<C-e>", ":RnvimrToggle<CR>", opts, "Ranger", "toggle_n", "Toggles Ranger")
keyset("t", "<C-e>", "<C-\\><C-n>:RnvimrToggle<CR>", opts, "Ranger", "toggle_t", "Toggles Ranger")
-- }
