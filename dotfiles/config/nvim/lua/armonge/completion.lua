return {

	{
		"hrsh7th/nvim-cmp", -- Autocompletion plugin
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
			"saadparwaiz1/cmp_luasnip", -- Snippets source for nvim-cmp
			"L3MON4D3/LuaSnip", -- Snippets plugin

			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"petertriho/cmp-git",
			"f3fora/cmp-spell",
		},
		config = function()
			-- luasnip setup
			local luasnip = require("luasnip") -- nvim-cmp setup

			local check_backspace = function()
				local col = vim.fn.col(".") - 1
				return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
			end

			local types = require("cmp.types")
			local cmp = require("cmp")

			local default_cmp_sources = cmp.config.sources({
				{ name = "buffer" },
				{ name = "path" },
				{ name = "luasnip" },
			})
			local full_cmp_sources = cmp.config.sources({
				{ name = "buffer" },
				{ name = "path" },
				{ name = "luasnip" },
				{ name = "nvim_lua" },
				{ name = "copilot" },
				{ name = "treesitter" },
				{ name = "conjure" },
				{
					name = "nvim_lsp",
					entry_filter = function(entry, ctx)
						local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]

						if kind == "Snippet" and ctx.prev_context.filetype == "java" then
							return false
						end

						if ctx.prev_context.filetype == "markdown" then
							return true
						end

						if kind == "Text" then
							return false
						end

						return true
					end,
				},
				{ name = "nvim_lsp_signature_help" },
			})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping(
						cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
						{ "i", "c" }
					),
					["<C-j>"] = cmp.mapping(
						cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
						{ "i", "c" }
					),
					["<C-h>"] = function()
						if cmp.visible_docs() then
							cmp.close_docs()
						else
							cmp.open_docs()
						end
					end,
					["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
					["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
					["<C-e>"] = cmp.mapping({
						i = cmp.mapping.abort(),
						c = cmp.mapping.close(),
					}),
					-- Accept currently selected item. If none selected, `select` first item.
					-- Set `select` to `false` to only confirm explicitly selected items.
					["<C-CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expandable() then
							luasnip.expand()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif check_backspace() then
							-- fallback()
							require("neotab").tabout()
						else
							require("neotab").tabout()
							-- fallback()
						end
					end, {
						"i",
						"s",
					}),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, {
						"i",
						"s",
					}),
				}),
				confirm_opts = {
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				},
				view = {
					entries = {
						name = "custom",
						selection_order = "top_down",
					},
					docs = {
						auto_open = true,
					},
				},
				window = {
					completion = {
						border = "rounded",
						winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,FloatBorder:FloatBorder,Search:None",
						col_offset = -3,
						side_padding = 1,
						scrollbar = false,
						scrolloff = 8,
					},
					documentation = {
						border = "rounded",
						winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,Search:None",
					},
				},
				experimental = {
					ghost_text = false,
				},
				sources = default_cmp_sources,
			})

			cmp.setup.filetype("python", {
				sources = full_cmp_sources,
			})
			cmp.setup.filetype("yaml", {
				sources = full_cmp_sources,
			})
			cmp.setup.filetype("beancount", {
				sources = full_cmp_sources,
			})
			cmp.setup.filetype("clojure", {
				sources = full_cmp_sources,
			})

			-- Set configuration for specific filetype.
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
					{ name = "buffer" },
					{ name = "gitmoji" },
				}),
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},
	{
		"saadparwaiz1/cmp_luasnip", -- Snippets source for nvim-cmp
		dependencies = { "L3MON4D3/LuaSnip" },
	},
	{
		"petertriho/cmp-git",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{
		"Dynge/gitmoji.nvim",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		opts = {},
		ft = "gitcommit",
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
			},
		},
	},
	{
		"zbirenbaum/copilot-cmp",
		opts = {},
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		opts = {
			debug = true, -- Enable debugging
			-- See Configuration section for rest
		},
		cmd = "CopilotChat",
		-- See Commands section for default commands if you want to lazy load on them
	},
	{ "rafamadriz/friendly-snippets", event = { "InsertEnter", "CmdlineEnter" } },
	{
		"L3MON4D3/LuaSnip",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = { "rafamadriz/friendly-snippets" },
		build = "make install_jsregexp",
		config = function()
			local ls = require("luasnip")
			ls.filetype_extend("all", { "_" })
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
}
