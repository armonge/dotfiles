return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		opts = {
			model = "claude-3.7-sonnet",
			window = {
				width = 0.3, -- fractional width of parent, or absolute width in columns when > 1
			},
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		-- See Commands section for default commands if you want to lazy load on them
		lazy = false,
		keys = {
			{
				"<leader>cc",
				"<cmd>CopilotChat<CR>",
				desc = "Open Copilot Chat",
				mode = { "v", "n" },
			},
			{
				"<leader>cc",
				"<cmd>CopilotChatPrompts<CR>",
				desc = "Copilot Chat Prompts",
			},
			{
				"<leader>gc",
				"<cmd>CopilotChatCommit<CR>",
				desc = "Generate commit messaage with copilot",
				ft = { "gitcommit" },
			},
		},
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
			filetypes = {
				python = true,
				lua = true,
				javascript = true,
				javascriptreact = true,
				typescript = true,
				gitcommit = true,
				markdown = true,
				beancount = true,
				html = true,
				htmldjango = true,
			},
		},
	},
}
