return {
	{ "stevearc/dressing.nvim", event = "VeryLazy" },
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
		opts = {
			style = "storm",
			on_highlights = function(hl, colors)
				hl.LineNr = {
					fg = colors.green,
				}
				hl.CursorLineNr = {
					fg = colors.orange,
				}
			end,
		},
		config = function()
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
			lualine.setup({
				theme = "tokyonight",
				sections = {

					lualine_c = {
						{

							"filename",
							path = 1,
						},
					},
				},
			})
		end,
	},

	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"nvim-telescope/telescope.nvim", -- optional
			"sindrets/diffview.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
		},
		opts = {
			ignored_settings = {
				"NeogitPushPopup--force-with-lease",
				"NeogitPushPopup--force",
				-- "NeogitPullPopup--rebase",
				"NeogitCommitPopup--allow-empty",
				"NeogitRevertPopup--no-edit",
			},
		},
		keys = {
				{ "<leader>g", group = "Neogit" },
			{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
		},

	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}

			local hooks = require("ibl.hooks")
			-- create the highlight groups in the highlight setup hook, so they are reset
			-- every time the colorscheme changes
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
			end)

			require("ibl").setup({ indent = { highlight = highlight } })
		end,
	},
	{
		"hedyhli/outline.nvim",
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		config = true,
		keys = {
			{ "<leader>o", "<cmd>Outline<cr>", desc = "Toggle Outline" },
		},
	},
}
