return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"fang2hou/blink-copilot",
			"rafamadriz/friendly-snippets",
			"kristijanhusak/vim-dadbod-completion",
		},
		version = "*",
		opts = {
			keymap = { preset = "default" },
			appearance = {
				nerd_font_variant = "mono",
				kind_icons = {
					Copilot = "",
				},
			},
			completion = {
				documentation = {
					auto_show = true,
				},
				menu = {
					draw = {
						components = {
							kind_icon = {
								text = function(ctx)
									if ctx.kind == "Copilot" then
										return ctx.kind_icon .. ctx.icon_gap
									end
									local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
									return kind_icon .. ctx.icon_gap
								end,
								highlight = function(ctx)
									if ctx.kind == "Copilot" then
										return "BlinkCmpKind"
									end
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
						},
					},
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "copilot" },
				per_filetype = {
					sql = { "dadbod", "lsp", "path", "snippets", "buffer", "copilot" },
					mysql = { "dadbod", "lsp", "path", "snippets", "buffer", "copilot" },
					plsql = { "dadbod", "lsp", "path", "snippets", "buffer", "copilot" },
				},
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 100,
						async = true,
					},
					dadbod = {
						name = "Dadbod",
						module = "vim_dadbod_completion.blink",
					},
				},
			},
		},
		opts_extend = { "sources.default" },
	},
}
