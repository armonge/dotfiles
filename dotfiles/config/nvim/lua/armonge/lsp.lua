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
							disableLanguageServices = false,
							disableOrganizeImports = false,
							disableTaggedHints = false,
							analysis = {
								diagnosticMode = "openFilesOnly",
								autoImportCompletions = true,
								autoSearchPaths = true,
							},
						},
					},
				},
			},
		},
		config = function(_, opts)
			local blink_cmp = require("blink.cmp")
			local lspconfig = require("lspconfig")
			for server, config in pairs(opts.servers) do
				config.capabilities = blink_cmp.get_lsp_capabilities(config.capabilities)
				lspconfig[server].setup(config)
			end
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local wk = require("which-key")
					local opts = { buffer = ev.buf }
					wk.add({
						{
							"<leader>a",
							vim.lsp.buf.code_action,
							desc = "Apply code action",
						},
					}, { mode = { "n", "v" } })
					wk.add({
						{
							desc = "goto",
							{ "gD", vim.lsp.buf.declaration, desc = "Go to declaration" },
							{ "gd", vim.lsp.buf.definition, desc = "Go to definition" },
							{ "gi", vim.lsp.buf.implementation, desc = "Go to implementation" },
						},
						{
							group = "workspaces",
							desc = "workspaces",
							{
								"<leader>wa",
								vim.lsp.buf.add_workspace_folder,
								desc = "Add folder to workspace ",
							},
							{
								"<leader>wr",
								vim.lsp.buf.remove_workspace_folder,
								desc = "Remove folder from workspace",
							},
							{
								"<leader>wl",
								function()
									print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
								end,
								desc = "List workspace folders",
							},
						},
						{ "K", vim.lsp.buf.hover, desc = "More information on a popup" },
						{ "<C-k>", vim.lsp.buf.signature_help, desc = "Signature help" },
						{
							group = "Refactor",
							{

								"<leader>rn",
								vim.lsp.buf.rename,
								desc = "Rename",
							},
						},
					}, opts)
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "BlinkCmpMenuOpen",
				callback = function()
					require("copilot.suggestion").dismiss()
					vim.b.copilot_suggestion_hidden = true
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "BlinkCmpMenuClose",
				callback = function()
					vim.b.copilot_suggestion_hidden = false
				end,
			})
			--
			-- Global mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.diagnostic.config({ virtual_text = true })
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
