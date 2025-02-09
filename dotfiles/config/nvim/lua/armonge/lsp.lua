return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "folke/neoconf.nvim" },
		opts = {
			servers = {
				jsonls = {},
				lua_ls = {},
				vtsls = {},
				beancount = {
					init_options = {
						journal_file = os.getenv("HOME") .. "/beancount/personal.beancount",
					},
				},
				basedpyright = {
					settings = {
						basedpyright = {
							importStrategy = "fromEnvironment",
							disableLanguageServices = false,
							disableOrganizeImports = false,
							disableTaggedHints = false,
							analysis = {
								diagnosticMode = "workspace",
								autoImportCompletions = true,
								autoSearchPaths = true,
							},
						},
					},
				},
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			local lspconfig = require("lspconfig")
			for server, config in pairs(opts.servers) do
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				lspconfig[server].setup(config)
			end

			-- Global mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.diagnostic.config({ virtual_text = true })
		end,
		keys = {
			{ "<space>e", vim.diagnostic.open_float, desc = "Open diagnostics" },
			{ "[d", vim.diagnostic.goto_prev, desc = "Go to previous diagnostic" },
			{ "]d", vim.diagnostic.goto_next, desc = "Go to next diagnostic" },
			{ "K", vim.lsp.buf.hover, desc = "More information on a popup" },
			{ "<C-k>", vim.lsp.buf.signature_help, desc = "Signature help" },
			{

				"<leader>rn",
				vim.lsp.buf.rename,
				desc = "Rename",
			},
			{

				"<leader>a",
				vim.lsp.buf.code_action,
				desc = "Apply code action",
				mode = { "n", "v" },
			},
		},
	},
	{
		"onsails/lspkind.nvim",

		config = function()
			local lspkind = require("lspkind")
			lspkind.init({
				symbol_map = {
					Copilot = "",
				},
			})

			vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
		end,
	},
	{
		"creativenull/efmls-configs-nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			local languages = {
				-- Custom languages, or override existing ones
				python = {
					require("efmls-configs.formatters.ruff"),
					require("efmls-configs.formatters.ruff_sort"),
				},
				yaml = {
					require("efmls-configs.formatters.prettier"),
				},
				clojure = {
					require("efmls-configs.formatters.joker"),
				},
				lua = {
					require("efmls-configs.formatters.stylua"),
				},
				sh = {
					require("efmls-configs.formatters.shfmt"),
				},
				json = {
					require("efmls-configs.formatters.jq"),
				},
				javascript = {
					require("efmls-configs.formatters.prettier"),
				},
				html = {
					require("efmls-configs.formatters.prettier"),
				},
				htmldjango = {
					require("efmls-configs.linters.djlint"),
					require("efmls-configs.formatters.djlint"),
				},
				javascriptreact = {
					require("efmls-configs.formatters.prettier"),
				},
				typescript = {
					require("efmls-configs.formatters.prettier"),
				},
				typescriptreact = {
					require("efmls-configs.formatters.prettier"),
				},
			}

			-- Or use the defaults provided by this plugin
			-- check doc/SUPPORTED_LIST.md for the supported languages
			--
			-- local languages = require('efmls-configs.defaults').languages()

			local efmls_config = {
				filetypes = vim.tbl_keys(languages),
				settings = {
					rootMarkers = { ".git/" },
					languages = languages,
				},
				init_options = {
					documentFormatting = true,
					documentRangeFormatting = true,
					hover = true,
					documentSymbol = true,
					codeAction = true,
					completion = true,
				},
			}
			require("lspconfig").efm.setup(vim.tbl_extend("force", efmls_config, {
				-- Pass your custom lsp config below like on_attach and capabilities
				--
				-- on_attach = on_attach,
				-- capabilities = capabilities,
			}))
			local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
			vim.api.nvim_create_autocmd({ "BufWritePre" }, {
				group = lsp_fmt_group,
				callback = function()
					if not vim.bo.modifiable or vim.b.skip_autoformat == true then
						return
					end

					vim.lsp.buf.format({ name = "efm" })
				end,
			})
			vim.api.nvim_create_autocmd("BufWritePost", {
				group = lsp_fmt_group,
				callback = function(ev)
					local efm = vim.lsp.get_clients({ name = "efm", bufnr = ev.buf })

					if vim.tbl_isempty(efm) then
						return
					end

					vim.lsp.buf.format()
				end,
			})
		end,
	},

	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- Library items can be absolute paths
				-- "~/projects/my-awesome-lib",
				-- Or relative, which means they will be resolved as a plugin
				-- "LazyVim",
				-- When relative, you can also provide a path to the library in the plugin dir
				"luvit-meta/library", -- see below
			},
		},
	},
	{
		"folke/neoconf.nvim",
		config = function()
			require("neoconf").setup()
		end,
		dependencies = { "folke/lazydev.nvim" },
	},
}
