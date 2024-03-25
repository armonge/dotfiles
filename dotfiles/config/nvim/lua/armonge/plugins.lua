-- folke/lazy.nvim {
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.mapleader = ","

require("lazy").setup({
	{ import = "armonge.telescope" },
	{ import = "armonge.theme" },
	{ import = "armonge.treesitter" },
	{
		"folke/neodev.nvim",
		opts = {
			library = { types = true },
		},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
	{
		"tpope/vim-sensible",
	},
	{
		"tpope/vim-fugitive",
		lazy = true,
		cmd = { "Git", "GBrowse" },
		dependencies = { "tpope/vim-rhubarb" },
	},
	{
		"tpope/vim-abolish",
	},
	{
		"tpope/vim-repeat",
	},
	{
		"tpope/vim-speeddating",
		lazy = true,
		keys = {
			{ "<C-a>", mode = { "v", "n" } },
			{ "<C-x>", mode = { "v", "n" } },
		},
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
	{
		"wakatime/vim-wakatime",
	},
	{
		"jamessan/vim-gnupg",
		-- event = "VeryLazy",
		ft = { "gpg", "pgp" },
	},
	{
		"antoyo/vim-licenses",
		cmd = {
			"Apache",
			"Gpl",
			"Gplv2",
			"Mit",
			"Bsd2",
			"Bsd3",
		},
	},
	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			disable_in_macro = false,
		},
	},
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {},
	},
	{
		"LunarVim/bigfile.nvim",
		event = "VeryLazy",
		opts = {},
	},

	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		opts = {},
	},
	{
		"lambdalisue/suda.vim",
		cmd = { "SudaRead", "SudaWrite" },
	},
	{
		"mechatroner/rainbow_csv",
		ft = { "csv" },
	},

	{
		"williamboman/mason.nvim",
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
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
		},
	},
	{ "neovim/nvim-lspconfig" },
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
	{ "onsails/lspkind.nvim" },
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
	{
		"kawre/neotab.nvim",
		event = "InsertEnter",
		opts = {},
	},
	{
		"mhartington/formatter.nvim",
		event = "BufWritePost",
		config = function()
			local augroup = vim.api.nvim_create_augroup
			local autocmd = vim.api.nvim_create_autocmd
			augroup("__formatter__", { clear = true })
			autocmd("BufWritePost", {
				group = "__formatter__",
				command = ":FormatWrite",
			})
			-- Utilities for creating configurations
			local util = require("formatter.util")

			-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
			require("formatter").setup({
				-- Enable or disable logging
				logging = true,
				-- Set the log level
				log_level = vim.log.levels.WARN,
				-- All formatter configurations are opt-in
				filetype = {
					-- Formatter configurations for filetype "lua" go here
					-- and will be executed in order
					lua = {
						-- "formatter.filetypes.lua" defines default configurations for the
						-- "lua" filetype
						require("formatter.filetypes.lua").stylua,
					},
					sh = {
						require("formatter.filetypes.sh").shfmt,
					},
					htmldjango = {
						{
							exe = "djlint",
							args = {
								"--profile=django",
								"--quiet",
								"--reformat",
								"--custom-html",
								"json-schema-form",
								"--custom-html",
								"monaco-editor",
								"-",
							},
							stdin = true,
						},
					},
					python = {
						require("formatter.filetypes.python").isort,

						function()
							return {
								exe = "ruff",
								cwd = vim.fn.getcwd(),
								args = { "format", "-q", "-" },
								stdin = true,
							}
						end,
					},
					typescript = {
						require("formatter.filetypes.typescript").prettierd,
					},
					json = {
						require("formatter.filetypes.json").prettierd,
					},
					jsonc = {
						require("formatter.filetypes.json").prettierd,
					},
					javascriptreact = {
						require("formatter.filetypes.javascript").prettierd,
					},
					javascript = {
						require("formatter.filetypes.javascript").prettierd,
					},
					yaml = {
						require("formatter.filetypes.yaml").prettierd,
					},
					html = {
						require("formatter.filetypes.html").prettierd,
					},
					sql = {
						require("formatter.filetypes.sql").pgformat,
					},
					beancount = {
						{
							exe = "bean-format",
							stdin = true,
						},
					},

					-- Use the special "*" filetype for defining formatter configurations on
					-- any filetype
					["*"] = {
						-- "formatter.filetypes.any" defines default configurations for any
						-- filetype
						require("formatter.filetypes.any").remove_trailing_whitespace,
					},
				},
			})
		end,
	},
	{
		"mfussenegger/nvim-lint",
		ft = { "htmldjango", "sql" },
		config = function()
			require("lint").linters_by_ft = {
				htmldjango = { "djlint", "curlylint" },
				sql = { "sqlfluff" },
			}
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		config = true,
		ft = { "typescript", "typescriptreact", "javascript", "javascriptreact", "javascript.jsx", "typescript.tsx" },
	},
	{
		"hedyhli/outline.nvim",
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		config = true,
		keys = {
			{ "<leader>o", "<cmd>Outline<cr>", desc = "Toggle Outline" },
		},
	},
	{
		"stevearc/oil.nvim",
		config = true,
		lazy = true,
		cmd = { "Oil" },
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<C-e>", "<CMD>Oil<CR>", desc = "Open parent directory" },
		},
		opts = {
			default_file_explorer = true,
			use_default_keymaps = false,
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				-- ["<C-s>"] = "actions.select_vsplit",
				-- ["<C-h>"] = "actions.select_split",
				["<C-t>"] = "actions.select_tab",
				["<C-p>"] = "actions.preview",
				["<C-c>"] = "actions.close",
				["<C-l>"] = "actions.refresh",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = "actions.tcd",
				["gs"] = "actions.change_sort",
				["gx"] = "actions.open_external",
				["g."] = "actions.toggle_hidden",
				["g\\"] = "actions.toggle_trash",
			},
		},
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		config = function()
			-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
			vim.keymap.set("n", "zR", require("ufo").openAllFolds)
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
			vim.keymap.set("n", "K", function()
				local winid = require("ufo").peekFoldedLinesUnderCursor()
				if not winid then
					-- choose one of coc.nvim and nvim lsp
					vim.lsp.buf.hover()
				end
			end)
			require("ufo").setup({
				provider_selector = function(bufnr, filetype, buftype)
					return { "treesitter", "indent" }
				end,
			})
		end,
	},
	{ "windwp/nvim-ts-autotag" },
	{
		"direnv/direnv.vim",
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	{
		"brenoprata10/nvim-highlight-colors",
		opts = {
			render = "background",
		},
	},
})
-- }

local beancount = {}
beancount.setup = function()
	beancount.namespace = vim.api.nvim_create_namespace("beancount")
	vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
		group = vim.api.nvim_create_augroup("beancount", { clear = true }),
		-- apigen currently only parses annotations within *.api.go
		-- files so those are the only files we want to check within
		-- neovim as well.
		pattern = "*.beancount",
		callback = beancount.check_current_buffer,
	})
end
beancount.check_current_buffer = function()
	-- Reset all diagnostics for our custom namespace. The second
	-- argument is the buffer number and passing in 0 will select
	-- the currently active buffer.
	vim.diagnostic.reset(beancount.namespace, 0)

	-- Get the path for the current buffer so we can pass that into
	-- the command below.
	local buf_path = vim.api.nvim_buf_get_name(0)

	-- Running `apigen -check FILE_PATH` will print error messages
	-- to stderr but won't generate any code.
	local cmd = { "bean-check", os.getenv("HOME") .. "/beancount/personal.beancount" }
	local buf_path = vim.api.nvim_buf_get_name(0)

	function on_exit(obj)
		local diagnostics = {}
		for line in obj.stderr:gmatch("([^\n]*)\n?") do
			local filepath, linenumber, error = string.match(line, "(.+):(%d+):%s+(.+)")
			if linenumber then
				if filepath == buf_path then
					table.insert(diagnostics, {

						lnum = tonumber(linenumber) - 1,
						col = 0,
						message = error,
					})
				end
			end
		end
		vim.schedule(function()
			vim.diagnostic.reset(beancount.namespace, 0)
			vim.diagnostic.set(beancount.namespace, 0, diagnostics)
		end)
	end

	vim.system(cmd, { text = true }, on_exit)
end

beancount.setup()
