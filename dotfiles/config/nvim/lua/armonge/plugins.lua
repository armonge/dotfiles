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
	"folke/which-key.nvim",
	"folke/neodev.nvim",
	"tpope/vim-sensible",
	{ "nvim-treesitter/nvim-treesitter", ["build"] = "TSUpdate" },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},
	"wakatime/vim-wakatime",

	"andersevenrud/nordic.nvim",
	"jamessan/vim-gnupg",
	"kevinhwang91/rnvimr",
	"antoyo/vim-licenses",
	"numToStr/Comment.nvim",
	{ "neoclide/coc.nvim", branch = "release" },
	-- "honza/vim-snippets",
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets", "molleweide/LuaSnip-snippets.nvim" },
	},
	"molleweide/LuaSnip-snippets.nvim",
	"vim-scripts/sessionman.vim",
	"jiangmiao/auto-pairs",
	"tpope/vim-surround",
	"vim-scripts/LargeFile",
	"junegunn/goyo.vim",
	"junegunn/limelight.vim",
	"lukas-reineke/indent-blankline.nvim",
	{
		"gregorias/nvim-mapper",
		dependencies = "nvim-telescope/telescope.nvim",
		config = function()
			require("nvim-mapper").setup({
				no_map = false,
			})
		end,
	},

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
