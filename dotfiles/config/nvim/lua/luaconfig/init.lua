-- Python {
if vim.fn.has("pythonx") then
	vim.opt.pyx = 3
end

-- Python2 for neovim {
if vim.fn.filereadable(os.getenv("HOME") .. "/.pyenv/versions/nvim2/bin/python") then
	vim.g.python2_host_prog = os.getenv("HOME") .. "/.pyenv/versions/nvim2/bin/python"
end
-- }

-- Python3 for neovim {
if vim.fn.filereadable(os.getenv("HOME") .. "/.pyenv/versions/nvim3/bin/python") then
	vim.g.python3_host_prog = os.getenv("HOME") .. "/.pyenv/versions/nvim3/bin/python"
	vim.g.python_host_prog = os.getenv("HOME") .. "/.pyenv/versions/nvim3/bin/python"
end
-- }
-- }

-- Node {
vim.g.coc_node_path = os.getenv("HOME") .. "/.config/nvm/versions/node/v16.16.0/bin/node"
vim.g.node_host_prog = os.getenv("HOME") .. "/.config/nvm/versions/node/v16.16.0/bin/neovim-node-host"
-- }

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

-- My Editing Defaults {
vim.opt.formatoptions:remove({ "t" })
vim.opt.hidden = true -- if hidden is not set, TextEdit might fail.
vim.opt.cmdheight = 2 -- Better display for messages
-- vim.opt.shortmess:append({ "c" }) -- don't give |ins-completion-menu| messages.
vim.opt.linespace = 0 -- No extra spaces between rows
vim.opt.number = true -- Line numbers on
vim.opt.showmatch = true -- Show matching brackets/parenthesis
vim.opt.hlsearch = true -- Highlight search terms
vim.opt.winminheight = 0 -- Windows can be 0 line high
vim.opt.ignorecase = true -- Case insensitive search
vim.opt.smartcase = true -- Case sensitive when uc present
vim.opt.wildmenu = true -- Show list instead of just completing
vim.opt.whichwrap = "b,s,h,l,<,>,[,]" -- Backspace and cursor keys wrap too
vim.opt.scrolljump = 5 -- Lines to scroll when cursor leaves screen
vim.opt.scrolloff = 3 -- Minimum lines to keep above and below cursor
vim.opt.wrap = false -- Do not wrap long lines
vim.opt.shiftwidth = 2 -- Use indents of 4 spaces
vim.opt.expandtab = true -- Tabs are spaces, not tabs
vim.opt.joinspaces = false -- Prevents inserting two spaces after punctuation on a join (J)
vim.opt.splitright = true -- Puts new vsplit windows to the right of the current
vim.opt.splitbelow = true -- Puts new split windows to the bottom of the current
vim.opt.pastetoggle = "<F12>" -- pastetoggle (sane indentation on pastes)
-- }

-- <Leader> {
-- The default leader is '\', but many people prefer ',' as it's in a standard
-- keyboard position
vim.g.mapleader = ","
vim.g.maplocalleader = ","
-- }

-- Cursor Position {
-- http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
-- Restore cursor to file position in previous editing session
function ResCur()
	if vim.fn.line("''") <= vim.fn.line("$") then
		vim.cmd('silent! normal! g`"')
		return 1
	end
end

local cur_group = vim.api.nvim_create_augroup("resCur", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	group = cur_group,
	callback = ResCur,
})

-- TODO: Instead of reverting the cursor to the last position in the buffer, we
-- set it to the first line when editing a git commit message
-- au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
-- }

-- Backup and Undo {
vim.opt.backup = true -- Backups are nice ...
vim.opt.backupdir = os.getenv("HOME") .. "/.vimbackup"
vim.cmd("silent !mkdir $HOME/.vimbackup > /dev/null 2>&1")

if vim.fn.has("persistent_undo") then
	vim.opt.undofile = true -- So is persistent undo ...
	vim.opt.undolevels = 1000 -- Maximum number of changes that can be undone
	vim.opt.undoreload = 10000 -- Maximum number lines to save for undo on a buffer reload
end

-- }

-- Encoding {
vim.g.scriptencoding = "utf-8"
vim.opt.bomb = false
vim.opt.fileencoding = "utf-8"
-- }

-- Folding {
vim.opt.foldenable = true -- Auto fold code
vim.opt.foldlevel = 9
vim.opt.foldmethod = "syntax"
-- vim.opt.foldcolumn=1
vim.opt.foldnestmax = 4
-- }

-- Number {
vim.opt.relativenumber = true
-- }

-- Clipboard {
vim.opt.clipboard:append({ "unnamedplus" })
-- }

-- sql {
vim.g.sql_type_default = "sql.vim"

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*.sql" },
	command = "call CocAction('format')",
})
-- }

--  Open files with gx {
vim.keymap.set("n", "gx", "!xdg-open " .. vim.fn.shellescape("<WORD>") .. "<CR>")
--  }

-- lambdalisue/suda.vim {
vim.keymap.set("c", "w!!", "w suda://%")
-- }

-- andersevenrud/nordic.nvim {
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.cmd.colorscheme("nordic")
-- }

-- liuchengxu/eleline.vim {
vim.g.eleline_powerline_fonts = 1
-- }

-- vim-licenses {
vim.g.licenses_authors_name = "Andrés Reyes Monge <armonge@gmail.com>"
vim.g.licenses_copyright_holders_name = "Andrés Reyes Monge <armonge@gmail.com>"
-- }

-- junegunn/fzf {
vim.g.fzf_buffers_jump = 1
-- " nnoremap <C-p> <cmd>Telescope find_files<cr>
-- " nnoremap <C-p> <cmd>Telescope live_grep<cr>
vim.keymap.set("n", "<C-p>", ":Files<CR>")
-- }
-- kevinhwang91/rnvimr {
vim.g.rnvimr_ranger_cmd =
	{ "env", "PYENV_VERSION=nvim3", "PYTHONDEVMODE=0", "PYTHONWARNINGS=ignore", "pyenv", "exec", "ranger" }
vim.g.rnvimr_enable_ex = 1
vim.g.rnvimr_enable_picker = 1
vim.g.rnvimr_enable_bw = 1
vim.g.rnvimr_hide_gitignore = 1
vim.g.rnvimr_enable_bw = 1

-- Resize floating window by all preset layouts
vim.keymap.set("t", "<M-i>", "<C-\\><C-n>:RnvimrResize<CR>", { silent = true })
-- Resize floating window by single preset layout
vim.keymap.set("t", "<M-y>", "<C-\\><C-n>:RnvimrResize 2<CR>", { silent = true })

-- Toggle
vim.keymap.set("n", "<C-e>", ":RnvimrToggle<CR>", { silent = true })
vim.keymap.set("t", "<C-e>", "<C-\\><C-n>:RnvimrToggle<CR>", { silent = true })
-- }

-- neoclide/coc.nvim {
vim.g.coc_global_extensions = {
	"coc-snippets",
	"coc-json",
	"coc-tsserver",
	"coc-html",
	"coc-css",
	"coc-yaml",
	"coc-lists",
	"coc-rust-analyzer",
	"coc-pyright",
	"coc-sql",
	"coc-stylua",
}

-- https://github.com/neoclide/coc.nvim#example-vim-configuration
-- Some servers have issues with backup files, see #649.
vim.opt.backup = false
vim.opt.writebackup = false

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 300

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appear/become resolved.
vim.opt.signcolumn = "yes"

--  Mappings for coc-vim {
-- Show all diagnostics.
vim.keymap.set("n", "<space>a", ":<C-u>CocList diagnostics<cr>", { silent = true, nowait = true })
--  Manage extensions.
vim.keymap.set("n", "<space>e", ":<C-u>CocList extensions<cr>", { silent = true, nowait = true })
--  Show commands.
vim.keymap.set("n", "<space>c", ":<C-u>CocList commands<cr>", { silent = true, nowait = true })
--  Find symbol of current document.
vim.keymap.set("n", "<space>o", ":<C-u>CocList outline<cr>", { silent = true, nowait = true })
-- Search workspace symbols.
vim.keymap.set("n", "<space>s", ":<C-u>CocList -I symbols<cr>", { silent = true, nowait = true })
-- Do default action for next item.
vim.keymap.set("n", "<C-j>", ":<C-u>CocNext<CR>", { silent = true, nowait = true })
-- Do default action for previous item.
vim.keymap.set("n", "<C-k>", ":<C-u>CocPrev<CR>", { silent = true, nowait = true })
--  Resume latest coc list.
vim.keymap.set("n", "<space>p", ":<C-u>CocListResume<CR>", { silent = true, nowait = true })
--  Show all coc lists.
vim.keymap.set("n", "<space>l", ":<C-u>CocList<CR>", { silent = true, nowait = true })
--  Show buffers.
vim.keymap.set("n", "<space>b", ":<C-u>CocList buffers<CR>", { silent = true, nowait = true })
-- Search
vim.keymap.set("n", "<C-f>", ":CocSearch<space>", { silent = true, nowait = true })
-- Open outline
vim.keymap.set("n", "<C-o>", ":CocOutline<CR>", { silent = true, nowait = true })

-- GoTo code navigation.
vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true })
vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", { silent = true })
vim.keymap.set("n", "gr", "<Plug>(coc-references)", { silent = true })

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

-- Symbol renaming.
vim.keymap.set("n", "<Leader>rn", "<Plug>(coc-rename)")

-- Formatting
vim.keymap.set({ "x", "n" }, "<Leader>f", "<Plug>(coc-format-selected)")
vim.keymap.set({ "x", "n" }, "<Leader>F", "<Plug>(coc-format)")

-- Applying codeAction to the selected region.
-- Example: `<leader>aap` for current paragraph
vim.keymap.set({ "x", "n" }, "<Leader>a", "<Plug>(coc-codeaction-selected)")

-- Remap keys for applying codeAction to the current buffer.
vim.keymap.set("n", "<Leader>ac", "<Plug>(coc-codeaction)")

-- Apply AutoFix to problem on the current line.
vim.keymap.set("n", "<Leader>qf", "<Plug>(coc-fix-current)")

-- Run the Code Lens action on the current line.
vim.keymap.set("n", "<Leader>cl", "<Plug>(coc-codelens-action)")

-- Use CTRL-S for selections ranges.
-- Requires 'textDocument/selectionRange' support of language server.
vim.keymap.set({ "x", "n" }, "<C-s>", "<Plug>(coc-range-select)")

--  }
-- }

-- numToStr/Comment.nvim {
-- Add spaces after comment delimiters by default
require("Comment").setup()
-- }
--

-- AutoCloseTag {
-- Make it so AutoCloseTag works for xml and xhtml files as well
vim.api.nvim_create_autocmd("FileType", {
	pattern = "xhtml,xml",
	command = "runtime ftplugin/html/autoclosetag.vim",
})
vim.keymap.set("n", "<Leader>ac", "<Plug>ToggleAutoCloseMappings")
-- }
--editorconfig/editorconfig-vim {
 vim.g.EditorConfig_preserve_formatoptions = 1
--}
