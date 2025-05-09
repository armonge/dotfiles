return {
	{
		"saghen/blink.cmp",

		dependencies = {
			-- "fang2hou/blink-copilot",
			"rafamadriz/friendly-snippets",
			"folke/lazydev.nvim",
			-- "Kaiser-Yang/blink-cmp-avante",
		},

		-- use a release tag to download pre-built binaries
		version = "*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- See the full "keymap" documentation for information on defining your own keymap.
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
				menu = {
					auto_show = function(ctx)
						return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
					end,
				},
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
				min_keyword_length = function(ctx)
					-- only applies when typing a command, doesn't apply to arguments
					if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
						return 2
					end
					return 0
				end,
				default = {
					-- "avante",
					"lsp",
					"path",
					"buffer",
					-- "copilot",
				},
				providers = {
					-- avante = {
					-- 	module = "blink-cmp-avante",
					-- 	name = "Avante",
					-- 	opts = {
					-- 		-- options for blink-cmp-avante
					-- 	},
					-- },
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority(see `:h blink.cmp`)
						score_offset = 100,
					},
					-- copilot = {
					-- 	name = "copilot",
					-- 	module = "blink-copilot",
					-- 	score_offset = 100,
					-- 	async = true,
					-- 	opts = {
					-- 		max_completions = 3,
					-- 		max_attempts = 4,
					-- 	},
					-- 	transform_items = function(_, items)
					-- 		local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
					-- 		local kind_idx = #CompletionItemKind + 1
					-- 		CompletionItemKind[kind_idx] = "Copilot"
					-- 		for _, item in ipairs(items) do
					-- 			item.kind = kind_idx
					-- 		end
					-- 		return items
					-- 	end,
					-- },
				},
			},
		},
		-- opts_extend = { "sources.default" },
	},
}
