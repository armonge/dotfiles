-- nvim-telescope/telescope.nvim {
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fn", builtin.help_tags, {})

local telescope = require("telescope")
telescope.setup({
	extensions = {
		coc = {
			theme = "ivy",
			prefer_locations = true, -- always use Telescope locations to preview definitions/declarations/implementations etc
		},
	},
})

telescope.load_extension("coc")

local keyset = vim.keymap.set
local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }

-- Show all diagnostics
keyset("n", "<space>a", ":<C-u>Telescope coc diagnostics<cr>", opts)
-- Show commands
keyset("n", "<space>c", ":<C-u>Telescope coc commands<cr>", opts)
-- Search workspace symbols
keyset("n", "<space>s", ":<C-u>Telescope coc workspace_symbols<cr>", opts)
--  Show buffers.
keyset("n", "<space>b", ":<C-u>Telescope buffers<CR>", { silent = true, nowait = true })
-- }
