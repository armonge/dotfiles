return {
	{
		"olimorris/codecompanion.nvim",
		opts = {
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
		},
		config = function(_, opts)
			require("codecompanion").setup(opts)
		end,
	},
}
