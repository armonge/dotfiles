local formatters = {
	"shellcheck",
	"yamlfmt",
	"erg",
	"biome",
	"prettier",
	"djlint",
	"jq",
	"shfmt",
	"stylua",
	"joker",
	"taplo",
	"actionlint",
}

local servers = {
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
	pylsp = {
		settings = {
			pylsp = {
				plugins = {
					rope_autoimport = { enabled = true },
					autopep8 = {
						enabled = false,
					},
					flake8 = {
						maxLineLength = 88,
					},
					pycodestyle = {
						maxLineLength = 88,
						enabled = false,
					},
					mccabe = {
						enabled = false,
					},
					pyflakes = {
						enabled = false,
					},
					yapf = {
						enabled = false,
					},
				},
			},
		},
	},
	beancount = {
		init_options = {
			journal_file = os.getenv("HOME") .. "/beancount/personal.beancount",
		},
	},
	powershell_es = {},
	ast_grep = {},
	harper_ls = {
		settings = {
			["harper-ls"] = {
				userDictPath = os.getenv("HOME") .. "/.config/nvim/spell/en.utf-8.add",
			},
		},
	},
	taplo = {},
	efm = {},
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
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
			"saghen/blink.cmp",
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
	{
		"zeioth/garbage-day.nvim",
		dependencies = "neovim/nvim-lspconfig",
		event = "VeryLazy",
		opts = {
			-- your options here
		},
	},
}
