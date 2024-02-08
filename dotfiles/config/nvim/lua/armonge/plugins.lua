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
	{
		"folke/which-key.nvim",
		lazy = true,
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"nvim-telescope/telescope.nvim", -- optional
			"sindrets/diffview.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
		},
		config = function()
			local neogit = require("neogit")
			local wk = require("which-key")
			neogit.setup({
				ignored_settings = {
					"NeogitPushPopup--force-with-lease",
					"NeogitPushPopup--force",
					-- "NeogitPullPopup--rebase",
					"NeogitCommitPopup--allow-empty",
					"NeogitRevertPopup--no-edit",
				},
			})

			wk.register({
				g = {
					name = "Neogit",
					["o"] = {
						function()
							neogit.open()
						end,
						"Neogit Open",
					},
				},
			}, { prefix = "<leader>" })
		end,
	},
	{
		"folke/neodev.nvim",
		config = true,
	},
	-- "folke/zen-mode.nvim",
	-- "folke/twilight.nvim",
	{ "rafamadriz/friendly-snippets" },
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		build = "make install_jsregexp",
		config = function()
			local ls = require("luasnip")
			ls.filetype_extend("all", { "_" })
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{
		"benfowler/telescope-luasnip.nvim",
		dependencies = { "L3MON4D3/LuaSnip" },
	},
	"tpope/vim-sensible",
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		build = ":TSUpdate",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},
	"wakatime/vim-wakatime",

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "storm",
			on_highlights = function(hl, colors)
				hl.LineNr = {
					fg = colors.green,
				}
				hl.CursorLineNr = {
					fg = colors.orange,
				}
			end,
		},
	},
	{

		"jamessan/vim-gnupg",
		event = "VeryLazy",
	},
	-- {
	--   "kevinhwang91/rnvimr",
	--   event = 'VeryLazy'
	-- },
	{

		"antoyo/vim-licenses",
		event = "VeryLazy",
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				-- add any options here
				mappings = {
					basic = true,
					extra = true,
				},
			})
		end,
		event = "VeryLazy",
	},
	-- {
	--   "neoclide/coc.nvim",
	--   branch = "release",
	--   -- event = 'VeryLazy',
	-- },
	{
		"vim-scripts/sessionman.vim",
		event = "VeryLazy",
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	{
		"LunarVim/bigfile.nvim",
		event = "VeryLazy",
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}

			local hooks = require("ibl.hooks")
			-- create the highlight groups in the highlight setup hook, so they are reset
			-- every time the colorscheme changes
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
			end)

			require("ibl").setup({ indent = { highlight = highlight } })
		end,
		config = true,
	},

	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		event = "VeryLazy",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
		dependencies = { "nvim-telescope/telescope.nvim" },
	},
	{ "nvim-telescope/telescope-media-files.nvim", dependencies = { "nvim-telescope/telescope.nvim" } },
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		config = function()
			local noice = require("noice")
			local wk = require("which-key")

			wk.register({
				n = {
					name = "Noice",
					["d"] = {
						function()
							noice.cmd("dismiss")
						end,
						"Noice dismiss",
					},
				},
			}, { prefix = "<leader>" })

			noice.setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
			})
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
			"folke/which-key.nvim",
		},
	},
	{
		"lambdalisue/suda.vim",
		event = "VeryLazy",
		config = function()
			vim.g.suda_smart_edit = 1
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")

			-- flash
			wk.register({
				-- flash search
				l = {
					name = "flash",
					["s"] = {
						function()
							require("flash").jump()
						end,
						"Flash Jump",
					},
					["t"] = {
						function()
							require("flash").treesitter()
						end,
						"Flash Treesitter",
					},
					["r"] = {
						function()
							require("flash").treesitter_search()
						end,
						"Flash Treesitter Search",
					},
				},
			}, { prefix = "<leader>", mode = { "n", "v" } })
		end,
	},
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "VeryLazy",
		config = function()
			local treesj = require("treesj")
			local wk = require("which-key")

			treesj.setup({ use_default_keymaps = false })
			wk.register({
				t = {
					name = "Treesj",
					["m"] = {
						function()
							require("treesj").toggle()
						end,
						"Toggle node under cursor",
					},
					["j"] = {
						function()
							require("treesj").join()
						end,
						"Join node under cursor",
					},
					["s"] = {
						function()
							require("treesj").split()
						end,
						"Split node under cursor",
					},
				},
			}, { prefix = "<space>" })
		end,
	},
	{
		"mechatroner/rainbow_csv",
	},
	{
		"natecraddock/workspaces.nvim",
		opts = {
			hooks = {
				open = { "Telescope find_files" },
			},
		},
	},

	{
		"williamboman/mason.nvim",
		config = true,
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
		event = { "InsertEnter", "CmdlineEnter" },
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
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true,
	},
	{ "onsails/lspkind.nvim" },
	{
		"Dynge/gitmoji.nvim",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		config = true,
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
		config = true,
	},
	{
		"kawre/neotab.nvim",
		event = "InsertEnter",
		config = true,
	},
	{
		"mhartington/formatter.nvim",
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
								"--format-css",
								"--format-js",
								"--reformat",
								"-",
							},
							stdin = true,
						},
					},
					python = {
						require("formatter.filetypes.python").ruff,
						require("formatter.filetypes.python").black,
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
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>TT", "<cmd>TroubleToggle<cr>", desc = "Toggles trouble window" },
		},
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		config = true,
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
		"tpope/vim-fugitive",
		lazy = true,
		cmd = { "Git", "GBrowse" },
		dependencies = { "tpope/vim-rhubarb" },
	},
	{
		"tpope/vim-abolish",
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
			vim.diagnostic.set(beancount.namespace, 0, diagnostics)
		end)
	end

	vim.system(cmd, { text = true }, on_exit)
end

beancount.setup()
