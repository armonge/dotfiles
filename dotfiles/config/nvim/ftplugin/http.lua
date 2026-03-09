local wk = require("which-key")

wk.add({
	{
		"<leader>rr",
		"<CMD>:NvimHttpYac<CR>",
		desc = "Run request under the cursor",
	},
	{
		"<leader>rq",
		"<CMD>:NvimHttpYacAll<CR>",
		desc = "Run all requests",
	},
	{
		"<leader>rp",
		"<CMD>:NvimHttpYacPicker<CR>",
		desc = "Run named request",
	},
}, { buffer = 0 })
