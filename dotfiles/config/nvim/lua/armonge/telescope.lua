-- nvim-telescope/telescope.nvim {
local builtin = require("telescope.builtin")

Mapper = require("nvim-mapper")
local keyset = Mapper.map
local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }

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
telescope.load_extension("mapper")

keyset("n", "<C-p>", builtin.find_files, {}, "Telescope", "find_files", "Searches filenames with Telescope")
keyset("n", "<leader>fg", builtin.live_grep, {}, "Telescope", "live_grep", "Searches file with grep and Telescope")
keyset("n", "<leader>fn", builtin.help_tags, {}, "Telescope", "help_tags", "Searches on help_tags with Telescope")

keyset(
	"n",
	"<space>a",
	"<cmd>Telescope coc diagnostics<cr>",
	opts,
	"Telescope",
	"diagnostics",
	"Searches coc diagnostics with Telescope"
)
keyset(
	"n",
	"<space>c",
	"<cmd>Telescope coc commands<cr>",
	opts,
	"Telescope",
	"commands",
	"Searches coc commands with Telescope"
)
keyset(
	"n",
	"<space>s",
	"<cmd>Telescope coc workspace_symbols<cr>",
	opts,
	"Telescope",
	"workspace_symbols",
	"Searches coc workspace symbols with Telescope "
)

keyset(
	"n",
	"<space>b",
	"<cmd>Telescope buffers<CR>",
	{ silent = true, nowait = true },
	"Telescope",
	"buffers",
	"Searches open buffers with Telescope"
)
-- }
