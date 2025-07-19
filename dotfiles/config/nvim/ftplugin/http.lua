local wk = require("which-key")

wk.add({
	{
		"<leader>rr",
		"<CMD>Rest run<CR>",
		desc = "Run request under the cursor",
	},
	{
		"<leader>rl",
		"<CMD>Rest  last<CR>",
		desc = "Run last rest command",
	},
}, { buffer = 0 })
