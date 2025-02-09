local wk = require("which-key")
wk.add({
	{ "g", group = "Goto" },
	{ "<leader>r", group = "Refactor", mode = { "x", "n" } },
	{ "<leader>g", group = "Neogit", icon = "" },
	{ "<leader>l", group = "Conjure Log" },
	{ "<leader>f", group = "Find" },
	{ "<leader>s", group = "Search" },
	{ "<leader>b", group = "Buffers" },
})
