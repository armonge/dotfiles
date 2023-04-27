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
	"editorconfig/editorconfig-vim",
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
	"honza/vim-snippets",
	"vim-scripts/sessionman.vim",
	"jiangmiao/auto-pairs",
	"tpope/vim-surround",
	"tpope/vim-eunuch",
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",
	"vim-scripts/LargeFile",
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
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
})
-- }
