local masonPackages = {
	"clj-kondo",
	"markdownlint",
	"terraform",
	"shellharden",
	"sqruff",
	"ruff",
	"shellcheck",
	"yamlfmt",
	"erg",
	"prettier",
	"jq",
	"shfmt",
	"stylua",
	"actionlint",
	"kulala-fmt",
	"hadolint",
	-- "typescript-language-server",
}

local servers = {
	djls = {},
	ty = {},
	jinja_lsp = {},
	biome = {},
	yamlls = {},
	dockerls = {},
	docker_compose_language_service = {},
	bashls = {},
	vtsls = {
		settings = {
			typescript = {
				implementationsCodeLens = { enabled = true },
				referencesCodeLens = { enabled = true, showOnAllFunctions = true },
			},
			javascript = {
				implementationsCodeLens = { enabled = true },
				referencesCodeLens = { enabled = true, showOnAllFunctions = true },
			},
		},
	},
	jsonls = {},
	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				workspace = {
					library = { vim.env.VIMRUNTIME },
					checkThirdParty = false,
				},
				diagnostics = { globals = { "vim", "Snacks" } },
			},
		},
	},
	-- stylelint_lsp = {},
	clojure_lsp = {},
	ruff = {
		init_options = {
			settings = {
				configurationPreference = "filesystemFirst",
			},
		},
	},
	beancount = {},
	powershell_es = {},
	ast_grep = {},
	-- harper_ls = {
	-- 	settings = {
	-- 		["harper-ls"] = {
	-- 			userDictPath = os.getenv("HOME") .. "/.config/nvim/spell/en.utf-8.add",
	-- 		},
	-- 	},
	-- },
}

return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				javascript = { "biome" },
				javascriptreact = { "biome" },
				typescript = { "biome" },
				typescriptreact = { "biome" },
				lua = { "stylua" },
				htmldjango = { "djlint" },
				python = { "ruff_format" },
				sql = { "sqruff" },
				terraform = { "terraform_fmt" },
				markdown = { "markdownlint" },
				toml = { "taplo" },
				sh = { "shfmt", "shellharden" },
				bash = { "shfmt", "shellharden" },
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
			format_on_save = function(bufnr)
				-- Skip formatting with beancount LSP since it's broken
				return {
					timeout_ms = 500,
					lsp_format = "fallback",
					-- filter = function(client)
					-- 	return client.name ~= "beancount"
					-- end,
				}
			end,
			formatters = {
				taplo = {
					append_args = { "--no-auto-config" },
				},
			},
		},
	},
	{
		"williamboman/mason.nvim",
		cmd = { "Mason" },
		config = function(_, opts)
			local mason = require("mason")
			mason.setup(opts)

			local registry = require("mason-registry")
			registry.refresh(function()
				local missing = {}
				for _, package_name in ipairs(masonPackages) do
					local ok, pkg = pcall(registry.get_package, package_name)
					if ok and not pkg:is_installed() then
						table.insert(missing, package_name)
						pkg:install()
					end
				end
				if #missing > 0 then
					vim.notify("Mason: installing " .. table.concat(missing, ", "), vim.log.levels.INFO)
				end
			end)
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
			"saghen/blink.cmp",
		},
		opts = {
			ensure_installed = vim.tbl_keys(servers),
			automatic_installation = true,
			automatic_enable = {
				exclude = { "ts_ls" },
			},
		},
		config = function(_, opts)
			local mason_lspconfig = require("mason-lspconfig")
			mason_lspconfig.setup(opts)

			for name, config in pairs(servers) do
				vim.lsp.config(name, config)
				vim.lsp.enable(name)
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "folke/snacks.nvim" },
		config = function()
			vim.lsp.config("pytest_lsp", {
				cmd = { "pytest-language-server" },
				filetypes = { "python" },
				root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "pytest.ini", ".git" },
			})

			vim.lsp.enable("pytest_lsp")

			-- Neovim 0.12 built-in LSP features
			vim.lsp.codelens.enable(true)
			-- Disabled: Neovim 0.12.1 bug causes "Invalid 'col': out of range" in inlay_hint.lua:362
			-- vim.lsp.inlay_hint.enable(true)
			vim.lsp.document_color.enable(true)

			-- Handle vtsls "editor.action.showReferences" codelens command
			vim.lsp.commands["editor.action.showReferences"] = function(command, ctx)
				local locations = command.arguments[3]
				local client = vim.lsp.get_client_by_id(ctx.client_id)
				if locations and #locations > 0 then
					local items = vim.lsp.util.locations_to_items(locations, client.offset_encoding)
					vim.fn.setloclist(0, {}, " ", { title = "References", items = items, context = ctx })
					vim.cmd.lopen()
				end
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(args)
					-- Only register keymaps once per buffer
					if vim.b[args.buf].lsp_keymaps_set then
						return
					end
					vim.b[args.buf].lsp_keymaps_set = true

					local wk = require("which-key")
					local opts = { buffer = args.buf }

					-- K (hover), grn (rename), gra (code action), <C-S> (signature help)
					-- are all built-in defaults since Neovim 0.11+
					wk.add({
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
								vim.print(vim.lsp.buf.list_workspace_folders())
							end,
							desc = "List workspace folders",
						},
					}, opts)
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
}
