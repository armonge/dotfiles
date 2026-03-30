local masonPackages = {
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
	"joker",
	"actionlint",
	"kulala-fmt",
	"hadolint",
	-- "typescript-language-server",
}

local servers = {
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
	lua_ls = {},
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
	harper_ls = {
		settings = {
			["harper-ls"] = {
				userDictPath = os.getenv("HOME") .. "/.config/nvim/spell/en.utf-8.add",
			},
		},
	},
}

return {
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local nullls = require("null-ls")
			local helpers = require("null-ls.helpers")
			local methods = require("null-ls.methods")
			local FORMATTING = methods.internal.FORMATTING
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			nullls.setup({
				debug = true,
				sources = {
					nullls.builtins.formatting.stylua,
					nullls.builtins.formatting.djhtml,
					require("none-ls.formatting.ruff"),
					require("none-ls.formatting.mbake"),
					-- require("none-ls.formatting.eslint"),
					nullls.builtins.formatting.sqruff,
					nullls.builtins.formatting.joker,
					nullls.builtins.formatting.terraform_fmt,
					nullls.builtins.formatting.markdownlint,
					require("none-ls.formatting.taplo").with({
						extra_args = {
							"--no-auto-config",
						},
					}),
					{
						name = "bean_format",
						meta = {
							url =
							"https://beancount.github.io/docs/running_beancount_and_generating_reports.html#bean-format",
							description =
							"This pure text processing tool will reformat `beancount` input to right-align all the numbers at the same, minimal column.",
							notes = {
								"It left-aligns all the currencies.",
								"It only modifies whitespace.",
							},
						},
						method = FORMATTING,
						filetypes = { "beancount" },
						generator = helpers.formatter_factory({
							from_temp_file = true,
							from_stdin = false,
							to_temp_file = true,
							command = "uvx",
							args = {
								"--from",
								"beancount",
								"bean-format",
								"$FILENAME",
								"-o",
								"$FILENAME",
							},
						}),
					},
					nullls.builtins.formatting.shfmt,
					nullls.builtins.formatting.shellharden,

					nullls.builtins.diagnostics.sqruff,
					nullls.builtins.diagnostics.terraform_validate,
					nullls.builtins.diagnostics.hadolint,
					-- require("none-ls.diagnostics.eslint"),

					nullls.builtins.hover.dictionary,
					nullls.builtins.hover.printenv,

					nullls.builtins.code_actions.gitrebase,
					nullls.builtins.code_actions.gitsigns,
					nullls.builtins.code_actions.refactoring,
					-- require("none-ls.code_actions.eslint"),
				},
				on_attach = function(client, bufnr)
					if client:supports_method("textDocument/formatting", bufnr) then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({
									filter = function(lspClient)
										-- Skip formatting with `beancount` LSP since it's broken and
										-- we can use `bean-format` directly
										return lspClient.name ~= "beancount"
									end,
								})
							end,
						})
					end
				end,
			})
		end,
		dependencies = { "nvim-lua/plenary.nvim", "nvimtools/none-ls-extras.nvim" },
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
			automatic_enable = true,
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
		dependencies = { "folke/neoconf.nvim", "folke/snacks.nvim" },
		config = function()
			vim.lsp.enable("djls")

			-- Neovim 0.12 built-in LSP features
			vim.lsp.codelens.enable(true)

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
	{
		"folke/neoconf.nvim",
		dependencies = { "folke/lazydev.nvim", "neovim/nvim-lspconfig" },
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
