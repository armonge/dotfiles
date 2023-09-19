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

vim.g.mapleader = "," -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	"folke/neodev.nvim",
	"folke/zen-mode.nvim",
	"folke/twilight.nvim",
	"honza/vim-snippets",
	-- "SirVer/ultisnips",
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

	"winston0410/range-highlight.nvim",
	-- {
	-- 	"m4xshen/hardtime.nvim",
	-- 	dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	-- 	opts = { restrictionmode = "hint" },
	-- },
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	{
		"m4xshen/smartcolumn.nvim",
		opts = {},
	},
	"andersevenrud/nordic.nvim",
	"jamessan/vim-gnupg",
	"kevinhwang91/rnvimr",
	"antoyo/vim-licenses",
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
		lazy = false,
	},
	{ "neoclide/coc.nvim", branch = "release" },
	"vim-scripts/sessionman.vim",
	"jiangmiao/auto-pairs",
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
	"LunarVim/bigfile.nvim",
	"lukas-reineke/indent-blankline.nvim",

	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"fannheyward/telescope-coc.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
		dependencies = { "nvim-telescope/telescope.nvim" },
	},
	{
		"rcarriga/nvim-notify",
	},
	{
		"folke/noice.nvim",
		config = function()
			require("noice").setup({
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
		},
	},
})
-- }
