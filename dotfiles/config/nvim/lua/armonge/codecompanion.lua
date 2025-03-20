return {
	{
		"olimorris/codecompanion.nvim",
		config = true,
		keys = {
			{
				"<leader>cc",
				"<cmd>CodeCompanionChat Toggle<CR>",
				desc = "Open Code Companion Chat",
				mode = { "v", "n" },
			},
			{
				"<leader>gc",
				function()
					require("codecompanion").prompt("docs")
				end,
				mode = { "v", "n" },
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"saghen/blink.cmp",
		},
		opts = {
			prompt_library = {
				["docs"] = {
					strategy = "chat",
					description = "Write documentation for me",
					opts = {
						index = 11,
						is_slash_cmd = false,
						auto_submit = false,
						short_name = "docs",
					},
					references = {
						{
							type = "file",
							path = {
								"README.md",
							},
						},
					},
					prompts = {
						{
							role = "user",
							content = [[I'm rewriting the documentation for my plugin CodeCompanion.nvim, as I'm moving to a vitepress website. Can you help me rewrite it?

I'm sharing my vitepress config file so you have the context of how the documentation website is structured in the `sidebar` section of that file.

I'm also sharing my `config.lua` file which I'm mapping to the `configuration` section of the sidebar.]],
						},
					},
				},
			},
			strategies = {
				inline = {
					adapter = "copilot",
				},
				chat = {
					adapter = "copilot",
				},
			},
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {})
				end,
				opts = {
					show_defaults = false,
				},
			},
			display = {
				action_palette = {
					opts = {
						-- provider = "snacks",
					},
				},
			},
		},
	},
}
