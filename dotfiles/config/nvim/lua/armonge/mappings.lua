local wk = require("which-key")
wk.add({
	{ "<leader>x", group = "Trouble" },
	{ "g", group = "Goto" },
	{ "<leader>w", group = "Workspaces", icon = "" },
	{ "<leader>r", group = "Refactor", mode = { "x", "n" } },
	{ "<leader>m", group = "Neotest", icon = "󱞊" },
	{ "<leader>g", group = "Neogit", icon = "" },
	{ "<leader>t", group = "Telescope" },
	{ "<leader>l", group = "Conjure Log" },
})
