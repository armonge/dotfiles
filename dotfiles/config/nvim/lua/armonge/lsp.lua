return {

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
				"lemminx",
				"yamlls",
				"emmet_language_server",
				"bashls",
				"jsonls",
				"basedpyright",
				"ruff_lsp",
				"jedi_language_server",
				"taplo",
				"htmx",
				"html",
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
		config = function()
			local wk = require("which-key")
			local lspconfig = require("lspconfig")

			local on_attach = function(client, bufnr)
				if client.name == "ruff_lsp" then
					-- Disable hover in favor of Pyright
					client.server_capabilities.hoverProvider = false
				end
			end

			lspconfig.ruff_lsp.setup({
				on_attach = on_attach,
			})
			lspconfig.basedpyright.setup({
				settings = {
					pyright = {
						-- Using Ruff's import organizer
						disableOrganizeImports = true,
					},
					python = {
						analysis = {
							-- Ignore all files for analysis to exclusively use Ruff for linting
							ignore = { "*" },
						},
					},
				},
			})
			lspconfig.htmx.setup({
				filetypes = { "html", "htmldjango" },
			})
			lspconfig.jedi_language_server.setup({})
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
}
