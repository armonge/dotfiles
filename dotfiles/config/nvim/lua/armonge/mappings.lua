local wk = require("which-key")
wk.add({
	{ "g", group = "Goto" },
	{ "<leader>c", group = "Copilot", icon="" },
	{ "<leader>w", group = "Workspaces", icon = "" },
	{ "<leader>r", group = "Refactor", mode = { "x", "n" } },
	{ "<leader>g", group = "Neogit", icon = "" },
	{ "<leader>t", group = "Telescope" },
	{ "<leader>l", group = "Conjure Log" },
	{
		"<leader>wt",
		function()
			local wez = require("wezterm")
			wez.switch_tab.index(vim.v.count)
		end,
		desc = "Switches WezTerm Tab",
	},
})
