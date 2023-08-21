local wk = require("which-key")
-- nvim-telescope/telescope.nvim {
local ts_builtin = require("telescope.builtin")

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
telescope.load_extension("notify")
telescope.load_extension("fzf")
local find_files = function()
	return ts_builtin.find_files({ follow = true })
end

wk.register({
	name = "Telescope",
	["<C-p>"] = { find_files, "Searches filenames with telescope" },
	["<leader>fn"] = { ts_builtin.help_tags, "Searches on help_tags with Telescope" },
	["<space>a"] = { "<cmd>Telescope coc diagnostics<CR>", "Searches coc diagnostics with Telescope" },
	["<space>c"] = { "<cmd>Telescope coc commands<CR>", "Searches coc commands with Telescope" },
	["<space>s"] = { "<cmd>Telescope coc workspace_symbols<CR>", "Searches coc workspace symbols with Telescope" },
	["<space>b"] = { "<cmd>Telescope buffers<CR>", "Searches open buffers with Telescope" },
	["<space>r"] = { "<cmd>Telescope registers<CR>", "Searches registers with Telescope" },
	["gr"] = { "<cmd>Telescope coc references<CR>", "Show references" },
	["<C-s>"] = { ts_builtin.live_grep, "Searches file with grep and Telescope" },
	["<space>l"] = { "<cmd>Telescope<CR>", "Shows all telescope lists" },
}, { mode = "n" })
