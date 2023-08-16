-- nvim-telescope/telescope.nvim {
local ts_builtin = require("telescope.builtin")

Mapper = require("nvim-mapper")
local keyset = Mapper.map
local opts = { noremap = true, nowait = true, silent = true }

local telescope = require("telescope")
telescope.setup({
	extensions = {
		coc = {
			theme = "ivy",
			prefer_locations = true, -- always use Telescope locations to preview definitions/declarations/implementations etc
		},
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
	},
})

telescope.load_extension("coc")
telescope.load_extension("mapper")
telescope.load_extension("fzf")
local find_files = function()
	return ts_builtin.find_files({ follow = true })
end
keyset("n", "<C-p>", find_files, opts, "Telescope", "find_files", "Searches filenames with Telescope")
keyset("n", "<leader>fn", ts_builtin.help_tags, opts, "Telescope", "help_tags", "Searches on help_tags with Telescope")
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
	{ "n", "v" },
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
keyset(
	"n",
	"<space>r",
	"<cmd>Telescope registers<CR>",
	opts,
	"Telescope",
	"registers",
	"Searches registers with Telescope"
)

keyset("n", "<C-s>", ts_builtin.live_grep, opts, "Telescope", "live_grep", "Searches file with grep and Telescope")
keyset("n", "<space>l", "<cmd>Telescope<CR>", opts, "Telescope", "list", "Shows all telescope lists")
-- }
