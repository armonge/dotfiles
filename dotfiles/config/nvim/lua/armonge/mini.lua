return {
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.comment").setup()
			require("mini.pairs").setup()
			require("mini.surround").setup()
			require("mini.statusline").setup()
			require("mini.basics").setup()
		end,
	},
}
