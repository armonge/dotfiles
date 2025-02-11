local wk = require("which-key")
wk.add({
	{ "g", group = "Goto" },
	{ "<leader>r", group = "Refactor", mode = { "x", "n" } },
	{ "<leader>t", group = "Pickers" },
	{ "<leader>s", group = "LSP" },
	{ "<leader>g", group = "Git", icon = "" },
	{ "<leader>l", group = "Conjure Log" },
	{ "<leader>b", group = "Buffers" },
})
