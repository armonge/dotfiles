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
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local lualine = require("lualine")
			local colors, _ = require("tokyonight.colors").setup({
				style = "moon",
			})
			lualine.setup({
				theme = "tokyonight-moon",
				inactive_sections = {
					lualine_c = {
						{
							"filename",
							path = 1,
							color = {
								fg = colors.fg_sidebar,
							},
						},
					},
				},
				sections = {
					lualine_b = { "branch", "diagnostics" },
					lualine_c = {
						{

							"filename",
							path = 1,
						},
					},
					lualine_x = { "filetype" },
					lualine_y = {},
					lualine_z = { "location" },
				},
			})
		end,
	},

	{
		"mechatroner/rainbow_csv",
		ft = { "csv" },
	},
}
