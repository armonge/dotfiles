return {
	{
		"folke/which-key.nvim",
		lazy = true,
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			defaults = {
				["<leader>m"] = { name = "+group name" },
			},
		},
		dependencies = {
			{ "echasnovski/mini.icons", version = false },
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
					hl.CursorLineNr = {
						fg = colors.green,
						bold = true,
					}
					hl.LineNr = {
						fg = colors.orange,
						bold = true,
					}
					hl.LineNrAbove = {
						fg = colors.orange,
						bold = false,
					}
					hl.LineNrBelow = {
						fg = colors.orange,
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
}
