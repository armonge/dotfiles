return {
	{
		lazy = false,
		keys = {
			{
				"<LocalLeader>gc",
				function()
					require("codecompanion").prompt("commit")
				end,
				desc = "Generate a commit message",
				ft = "gitcommit",
			},

			{
				"<leader>cc",
				"<cmd>CodeCompanionActions<cr>",
				desc = "CodeCompanionActions",
			},
			{
				"<leader>cC",
				"<cmd>CodeCompanionChat<cr>",
				desc = "Code Companion Chat",
			},
		},
		"olimorris/codecompanion.nvim",
		opts = {
			display = {
				action_palette = {
					provider = "snacks",
				},
			},
			strategies = {
				chat = {
					adapter = "anthropic",
				},
				inline = {
					adapter = "anthropic",
				},
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"j-hui/fidget.nvim",
		},
		init = function()
			require("plugins.codecompanion.fidget-spinner"):init()
		end,
		config = function(_, opts)
			require("codecompanion").setup(opts)
		end,
	},
}
