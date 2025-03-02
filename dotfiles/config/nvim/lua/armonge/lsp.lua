local formatters = {
	"biome",
	"prettier",
	"djlint",
	"jq",
	"shfmt",
	"stylua",
	"joker",
	"taplo",
}

local servers = {
	basedpyright = {
		settings = {
			basedpyright = {
				reportMissingTypeStubs = false,
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
	ruff = {
		init_options = {
			settings = {
				configurationPreference = "filesystemFirst",
			},
		},
	},
	htmx = {},
	biome = {},
	yamlls = {},
	dockerls = {},
	docker_compose_language_service = {},
	bashls = {},
	jsonls = {},
	lua_ls = {},
	vtsls = {},
	stylelint_lsp = {},
	clojure_lsp = {},
	sqls = {},
	tailwindcss = {},
	-- pylsp = {
	-- 	settings = {
	-- 		pylsp = {
	-- 			plugins = {
	-- 				pycodestyle = {
	-- 					enabled = false,
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- },
	beancount = {
		init_options = {
			journal_file = os.getenv("HOME") .. "/beancount/personal.beancount",
		},
	},
	powershell_es = {},
	ast_grep = {},
	harper_ls = {},
	taplo = {},
}

return {

	{
		"williamboman/mason.nvim",
		cmd = { "Mason" },
		config = function(_, opts)
			local mason = require("mason")
			mason.setup(opts)

			local registry = require("mason-registry")
			registry.refresh(function()
				for _, package_name in ipairs(formatters) do
					local pkg = registry.get_package(package_name)
					if not pkg:is_installed() then
						pkg:install()
					end
				end
			end)
		end,
		opts = {
			pip = {
				---@since 1.0.0
				-- Whether to upgrade pip to the latest version in the virtual environment before installing packages.
				upgrade_pip = true,

				---@since 1.0.0
				-- These args will be added to `pip install` calls. Note that setting extra args might impact intended behavior
				-- and is not recommended.
				--
				-- Example: { "--proxy", "https://proxyserver" }
				install_args = {},
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
			"creativenull/efmls-configs-nvim",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")
			local blink_cmp = require("blink.cmp")
			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(servers),
				automatic_installation = true,
			})
			mason_lspconfig.setup_handlers({
				function(server_name)
					local config = servers[server_name]
					if not config then
						return
					end
					config.capabilities = blink_cmp.get_lsp_capabilities(config.capabilities)
					lspconfig[server_name].setup(config)
				end,
				efm = function()
					local languages = {
						-- Custom languages, or override existing ones
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
							require("efmls-configs.formatters.biome"),
						},
						javascript = {
							require("efmls-configs.formatters.biome"),
						},
						html = {
							require("efmls-configs.formatters.biome"),
						},
						htmldjango = {
							require("efmls-configs.linters.djlint"),
							require("efmls-configs.formatters.djlint"),
						},
						javascriptreact = {
							require("efmls-configs.formatters.biome"),
						},
						typescript = {
							require("efmls-configs.formatters.biome"),
						},
						typescriptreact = {
							require("efmls-configs.formatters.biome"),
						},
						toml = {
							require("efmls-configs.formatters.taplo"),
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

							vim.lsp.buf.format()
						end,
					})
				end,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "folke/neoconf.nvim" },
		config = function()
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
							{ "gD", vim.lsp.buf.declaration,    desc = "Go to declaration" },
							{ "gd", vim.lsp.buf.definition,     desc = "Go to definition" },
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
						{ "K",     vim.lsp.buf.hover,          desc = "More information on a popup" },
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
		opts = {
			symbol_map = {
				Copilot = "",
			},
		},
		config = function(_, opts)
			local lspkind = require("lspkind")
			lspkind.setup(opts)

			vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
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
		dependencies = { "folke/lazydev.nvim" },
	},
}
