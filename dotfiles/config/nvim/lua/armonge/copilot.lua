return {
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
				help = true,
				htmldjango = true,
			},
		},
	},
}
