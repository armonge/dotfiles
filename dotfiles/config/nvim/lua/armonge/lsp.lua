return {
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
		},
		opts = {

			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				-- "lemminx",
				"yamlls",
				"emmet_language_server",
				"bashls",
				"jsonls",
				"basedpyright",
				-- "jedi_language_server",
				"taplo",
				-- "htmx",
				"efm",
				-- "ast_grep",
				-- "pylyzer",
			},
			automatic_installation = true,
		},
		config = function()
			local lspconfig = require("lspconfig")
			-- Add additional capabilities supported by nvim-cmp
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			require("mason-lspconfig").setup_handlers({
				-- The first entry (without a key) will be the default handler
				-- and will be called for each installed server that doesn't have
				-- a dedicated handler.
				function(server_name) -- default handler (optional)
					lspconfig[server_name].setup({
						-- on_attach = my_custom_on_attach,
						capabilities = capabilities,
					})
				end,
				-- -- Next, you can provide a dedicated handler for specific servers.
				-- -- For example, a handler override for the `rust_analyzer`:
				-- ["rust_analyzer"] = function()
				--   require("rust-tools").setup {}
				-- end
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "folke/neoconf.nvim" },
		config = function()
			local wk = require("which-key")
			local lspconfig = require("lspconfig")

			lspconfig.basedpyright.setup({
				settings = {
					basedpyright = {
						analysis = {
							disableOrganizeImports = false,
							diagnosticMode = "workspace",
						},
					},
				},
			})
			-- lspconfig.htmx.setup({
			-- 	filetypes = { "html", "htmldjango" },
			-- })
			-- lspconfig.jedi_language_server.setup({})
			-- lspconfig.basedpyright.setup({
			-- 	cmd = { "env", "PYENV_VERSION=nvim3", "basedpyright-langserver", "--stdio" },
			-- })
			lspconfig.emmet_language_server.setup({
				filetypes = {
					"css",
					"eruby",
					"html",
					"javascript",
					"javascriptreact",
					"less",
					"sass",
					"scss",
					"pug",
					"typescriptreact",
					"htmldjango",
				},
				-- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-lotconfiguration).
				-- **Note:** only the options listed in the table are supported.
				init_options = {
					---@type table<string, string>
					includeLanguages = { "htmldjango" },
					--- @type string[]
					excludeLanguages = {},
					--- @type string[]
					extensionsPath = {},
					--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
					preferences = {},
					--- @type boolean Defaults to `true`
					showAbbreviationSuggestions = true,
					--- @type "always" | "never" Defaults to `"always"`
					showExpandedAbbreviation = "always",
					--- @type boolean Defaults to `false`
					showSuggestionsAsSnippets = false,
					--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
					syntaxProfiles = {},
					--- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
					variables = {},
				},
			})

			-- Global mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.diagnostic.config({ virtual_text = true })
			wk.register({
				["<space>e"] = { vim.diagnostic.open_float, "Open diagnostics" },
				["[d"] = { vim.diagnostic.goto_prev, "Go to previous diagnostic" },
				["]d"] = { vim.diagnostic.goto_next, "Go to next diagnostic" },
			})
			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					wk.register({
						name = "LSP",
						["g"] = {
							name = "Go to",
							["D"] = { vim.lsp.buf.declaration, "Go to declaration" },
							["d"] = { vim.lsp.buf.definition, "Go to definition" },
							["i"] = { vim.lsp.buf.implementation, "Go to implementation" },
							-- ['t'] = { vim.lsp.buf.type_definition, "Go to type definition" },
						},

						["<leader>w"] = {
							name = "Workspaces",
							["a"] = { vim.lsp.buf.add_workspace_folder, "Add folder to workspace " },
							["r"] = { vim.lsp.buf.remove_workspace_folder, "Remove folder from workspace" },
							["l"] = {
								function()
									print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
								end,
								"List workspace folders",
							},
						},

						["K"] = { vim.lsp.buf.hover, "More information on a popup" },
						["<C-k>"] = { vim.lsp.buf.signature_help, "Signature help" },
						["<leader>r"] = {
							name = "Refactor",
							["n"] = { vim.lsp.buf.rename, "Rename" },
						},
					}, opts)

					wk.register({
						name = "LSP",
						["<leader>ca"] = { vim.lsp.buf.code_action, "Apply code action" },
					}, { mode = { "n", "v" } })
				end,
			})
		end,
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
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		config = true,
		ft = { "typescript", "typescriptreact", "javascript", "javascriptreact", "javascript.jsx", "typescript.tsx" },
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
}
