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
		config = true,
		opts = {},
	},
	{
		"sindrets/diffview.nvim",
		lazy = false,
		keys = {
			{ "<leader>gd",  "<cmd>DiffviewOpen<CR>",  desc = "Diffview" },
			{ "<leader>gdc", "<cmd>DiffviewClose<CR>", desc = "Diffview Close" },
		},
	},

	{
		-- Make sure to set this up properly if you have lazy=true
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			file_types = { "markdown", "Avante" },
		},
		ft = { "markdown", "Avante" },
	},
	{ "vladdoster/remember.nvim", config = true, main = "remember" },
}
