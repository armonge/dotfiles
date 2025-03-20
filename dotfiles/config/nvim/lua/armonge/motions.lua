return {
	-- {
	-- 	"tpope/vim-speeddating",
	-- 	lazy = true,
	-- 	keys = {
	-- 		{ "<C-a>", mode = { "v", "n" } },
	-- 		{ "<C-x>", mode = { "v", "n" } },
	-- 	},
	-- },
	{
		"johmsalas/text-case.nvim",
		config = function()
			require("textcase").setup({})
		end,
		keys = {
			"ga", -- Default invocation prefix
		},
		cmd = {
			-- NOTE: The Subs command name can be customized via the option "substitude_command_name"
			"Subs",
			"TextCaseStartReplacingCommand",
		},
		-- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
		-- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
		-- available after the first executing of it or after a keymap of text-case.nvim has been used.
		lazy = false,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		-- stylua: ignore start
		keys = {
			{ "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
			{ "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
			{ "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
			{ "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
		},
		-- stylua: ignore end
		-- config = function()
		-- 	local flash = require("flash")
		-- 	flash.jump({
		-- 		action = function(match, state)
		-- 			vim.api.nvim_win_call(match.win, function()
		-- 				vim.api.nvim_win_set_cursor(match.win, match.pos)
		-- 				vim.diagnostic.open_float()
		-- 			end)
		-- 			state:restore()
		-- 		end,
		-- 	})
		-- end,
		opts = {
			picker = {
				win = {
					input = {
						keys = {
							["<a-s>"] = { "flash", mode = { "n", "i" } },
							["s"] = { "flash" },
						},
					},
				},
				actions = {
					flash = function(picker)
						require("flash").jump({
							pattern = "^",
							label = { after = { 0, 0 } },
							search = {
								mode = "search",
								exclude = {
									function(win)
										return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
									end,
								},
							},
							action = function(match)
								local idx = picker.list:row2idx(match.pos[1])
								picker.list:_move(idx, true, true)
							end,
						})
					end,
				},
			},
		},
	},
}
