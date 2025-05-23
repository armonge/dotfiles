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
vim.opt.cursorline = true -- Highlights current line
vim.opt.splitbelow = true -- Puts new split windows to the bottom of the current
-- vim.opt.pastetoggle = "<F12>" -- pastetoggle (sane indentation on pastes)
vim.opt.colorcolumn = "+1"
-- }
--
-- <Leader> {
-- The default leader is '\', but many people prefer ',' as it's in a standard
-- keyboard position
vim.g.mapleader = ","
vim.g.maplocalleader = ","
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

-- Spell {
vim.opt.spell = false
-- vim.opt.spelllang = { "en_us" }
-- }

-- Encoding {
vim.g.scriptencoding = "utf-8"
vim.opt.bomb = false
vim.opt.fileencoding = "utf-8"
-- }

-- Number {
vim.opt.relativenumber = true
-- }

-- Clipboard {
vim.opt.clipboard:append({ "unnamedplus" })
-- }
--
-- Ruby  {
vim.g.loaded_ruby_provider = 0
-- }
-- Perl {
vim.g.loaded_perl_provider = 0
-- }
vim.api.nvim_create_user_command("Browse", function(opts)
	vim.fn.system({ "open", opts.fargs[1] })
end, { nargs = 1 })

--
--
-- Folding {
vim.opt.foldenable = true -- Auto fold code
vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldcolumn = "1"
vim.opt.foldnestmax = 10
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldlevelstart = 99
-- Prefer LSP folding if client supports it
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client:supports_method("textDocument/foldingRange") then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end
	end,
})
-- }
