-- nvim-telescope/telescope.nvim {
local builtin = require("telescope.builtin")

Mapper = require("nvim-mapper")
local keyset = Mapper.map
local opts = { noremap = true }

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

keyset("n", "<C-p>", builtin.find_files, opts, "Telescope", "find_files", "Searches filenames with Telescope")
keyset("n", "<leader>fg", builtin.live_grep, opts, "Telescope", "live_grep", "Searches file with grep and Telescope")
keyset("n", "<leader>fn", builtin.help_tags, opts, "Telescope", "help_tags", "Searches on help_tags with Telescope")
keyset(
	"n",
	"<space>m",
	"<cmd>Telescope mapper<CR>",
	opts,
	"Telescope",
	"mapper",
	"Searches on help_tags with Telescope"
)

keyset(
	"n",
	"<space>a",
	"<cmd>Telescope coc diagnostics<CR>",
	opts,
	"Telescope",
	"diagnostics",
	"Searches coc diagnostics with Telescope"
)
keyset(
	"n",
	"<space>c",
	"<cmd>Telescope coc commands<CR>",
	opts,
	"Telescope",
	"commands",
	"Searches coc commands with Telescope"
)
keyset(
	"n",
	"<space>s",
	"<cmd>Telescope coc workspace_symbols<CR>",
	opts,
	"Telescope",
	"workspace_symbols",
	"Searches coc workspace symbols with Telescope "
)

keyset(
	"n",
	"<space>b",
	"<cmd>Telescope buffers<CR>",
	opts,
	"Telescope",
	"buffers",
	"Searches open buffers with Telescope"
)
-- }
