return {
	{
		"saghen/blink.cmp",

		dependencies = {
			"fang2hou/blink-copilot",
			"rafamadriz/friendly-snippets",
			"folke/lazydev.nvim",
		},

		-- Use a release tag to download pre-built binaries
		version = "1.*",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- See the full "keymap" documentation for information on defining your own keymap.
			-- 'default' for mappings similar to built-in completion
			keymap = {
				preset = "default",
				["<C-y>"] = { "select_and_accept", "show" },
				["<C-Enter>"] = { "select_and_accept", "show" },
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
			},

			signature = {
				enabled = true,
				window = {
					show_documentation = true,
				},
			},
			completion = {
				ghost_text = {
					enabled = true,
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
				},
			},
			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = {
					"copilot",
					"lazydev",
					"buffer",
					"lsp",
					"path",
					"codecompanion",
				},
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
					},
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 100,
						async = true,
					},
				},
			},
		},
		opts_extend = { "sources.default" },
	},
}
