return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		cache = false,
		config = function()
			require("tokyonight").setup({
				style = "moon",
				on_highlights = function(hl, colors)
					hl.LineNr = {
						fg = colors.orange,
						bold = true,
					}
					hl.LineNrAbove = {
						fg = colors.green,
						bold = false,
					}
					hl.LineNrBelow = {
						fg = colors.green,
						bold = false,
					}
				end,
			})

			vim.opt.termguicolors = true
			vim.opt.background = "dark"
			vim.cmd([[colorscheme tokyonight-moon]])
		end,
	},

	{
		"mechatroner/rainbow_csv",
		ft = { "csv" },
	},
	{
		"stevearc/aerial.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		keys = { -- Example mapping to toggle outline
			{ "<leader>o", "<cmd>AerialToggle!<CR>", desc = "Toggle outline" },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							gitsigns.nav_hunk("next")
						end
					end, { desc = "Next hunk" })

					map("n", "[c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gitsigns.nav_hunk("prev")
						end
					end, { desc = "Previous hunk" })

					-- Actions
					map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "(Un)Stage hunk" })
					map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })

					map("v", "<leader>hs", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Stage hunk (visual)" })

					map("v", "<leader>hr", function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Reset hunk (visual)" })

					map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
					map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
					map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
					map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })

					map("n", "<leader>hb", function()
						gitsigns.blame_line({ full = true })
					end, { desc = "Blame line" })

					map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff this" })

					map("n", "<leader>hD", function()
						gitsigns.diffthis("~")
					end, { desc = "Diff this (HEAD)" })

					map("n", "<leader>hQ", function()
						gitsigns.setqflist("all")
					end, { desc = "Set qflist (all hunks)" })
					map("n", "<leader>hq", gitsigns.setqflist, { desc = "Set qflist (current hunk)" })

					-- Toggles
					-- map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
					-- map("n", "<leader>tw", gitsigns.toggle_word_diff)

					-- Text object
					map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select hunk" })
				end,
			})
		end,
		opts = {},
	},

	{
		-- Make sure to set this up properly if you have lazy=true
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			file_types = { "markdown" },
		},
		ft = { "markdown" },
	},
	{ "vladdoster/remember.nvim", config = true, main = "remember" },
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy", -- Or `LspAttach`
		priority = 1000, -- Needs to be loaded in first
		opts = {
			options = {
				show_source = {
					enabled = true,
				},
				-- Use icons defined in the diagnostic configuration
				use_icons_from_diagnostic = true,
				multilines = {
					-- Enable multiline diagnostic messages
					enabled = true,

					-- Always show messages on all lines for multiline diagnostics
					always_show = true,

					-- Trim whitespaces from the start/end of each line
					trim_whitespaces = false,

					-- Replace tabs with spaces in multiline diagnostics
					tabstop = 4,
				},
				-- Display all diagnostic messages on the cursor line
				show_all_diags_on_cursorline = true,
			},
		},
		config = function(_, opts)
			require("tiny-inline-diagnostic").setup(opts)
			vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
		end,
	},
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
}
