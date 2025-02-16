local wk = require("which-key")
wk.add({
	{ "g", group = "Goto" },
	{ "<leader>r", group = "Refactor", mode = { "x", "n" } },
	{ "<leader>t", group = "Pickers" },
	{ "<leader>s", group = "LSP" },
	{ "<leader>g", group = "Git", icon = "" },
	{ "<leader>l", group = "Conjure Log" },
	{ "<leader>b", group = "Buffers" },
	{
		"<leader>d",
		group = "Show Diagnostics",
		callback = function()
			for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
				if vim.api.nvim_win_get_config(winid).zindex then
					return
				end
			end
			vim.diagnostic.open_float({
				scope = "cursor",
				focusable = false,
				close_events = {
					"CursorMoved",
					"CursorMovedI",
					"BufHidden",
					"InsertCharPre",
					"WinLeave",
				},
			})
		end,
	},
})
