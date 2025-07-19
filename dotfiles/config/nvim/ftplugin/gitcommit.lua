local wk = require("which-key")

wk.add({
	{
		"<leader>gc",
		function()
			vim.cmd("CopilotChatCommit")
		end,
		desc = "Generate commit message",
		buffer = true,
	},
}, { buffer = 0 })
