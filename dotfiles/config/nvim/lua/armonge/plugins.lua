-- junegunn/vim-plug {
local Plug = vim.fn["plug#"]
vim.call("plug#begin", "~/.config/nvim/plugged")

Plug("tpope/vim-sensible")

Plug("nvim-treesitter/nvim-treesitter", { ["do"] = "TSUpdate" })
Plug("editorconfig/editorconfig-vim")
Plug("liuchengxu/eleline.vim")
Plug("lambdalisue/suda.vim")
Plug("wakatime/vim-wakatime")

Plug("andersevenrud/nordic.nvim")
Plug("jamessan/vim-gnupg")
Plug("kevinhwang91/rnvimr")
Plug("antoyo/vim-licenses")
Plug("numToStr/Comment.nvim")
Plug("neoclide/coc.nvim", { branch = "release" })
Plug("honza/vim-snippets")
Plug("mattn/emmet-vim")
Plug("vim-scripts/sessionman.vim")
Plug("jiangmiao/auto-pairs")
Plug("tpope/vim-repeat")
Plug("tpope/vim-surround")
Plug("vim-scripts/LargeFile")
Plug("lukas-reineke/indent-blankline.nvim")

Plug("junegunn/fzf", { ["do"] = vim.fn["fzf#install"] })
Plug("junegunn/fzf.vim")

vim.call("plug#end")
-- }
