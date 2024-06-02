return {
	{
		"tpope/vim-repeat",
	},
	{
		"tpope/vim-speeddating",
		lazy = true,
		keys = {
			{ "<C-a>", mode = { "v", "n" } },
			{ "<C-x>", mode = { "v", "n" } },
		},
	},
	{
		"tpope/vim-abolish",

		cmd = {
			"Abolish",
			"Subvert",
		},
		keys = {

			{ "crs", mode = { "n" , 'v'} },
			{ "crm", mode = { "n" , 'v'} },
			{ "crc", mode = { "n" , 'v'} },
			{ "cru", mode = { "n" , 'v'} },
			{ "cr-", mode = { "n" , 'v'} },
			{ "cr.", mode = { "n" , 'v'} },
		},
	},
	{
		"folke/flash.nvim",
		-- event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},

	{
		"numToStr/Comment.nvim",
		opts = {},
		keys = {
			{ "gcc", mode = { "v", "n" } },
		},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			disable_in_macro = false,
		},
	},
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {},
	},
}
