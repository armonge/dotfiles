local wk = require("which-key")
-- neoclide/coc.nvim {

vim.g.coc_global_extensions = {
	"coc-pyright",
	"coc-git",
}
vim.g.coc_node_path = os.getenv("NVM_BIN") .. "/node"

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*.sql" },
	command = "call CocAction('format')",
})

-- Some servers have issues with backup files, see #649
vim.opt.backup = false
vim.opt.writebackup = false

-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- delays and poor user experience
vim.opt.updatetime = 300

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appeared/became resolved
vim.opt.signcolumn = "yes"

-- Add `:Format` command to format current buffer
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

-- Add `:OR` command for organize imports of the current buffer
vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

-- Add (Neo)Vim's native statusline support
-- NOTE: Please see `:h coc-status` for integrations with external plugins that
-- provide custom statusline: lightline.vim, vim-airline
vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

-- " Add `:Fold` command to fold current buffer
vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = "?" })

-- Autocomplete
function _G.check_back_space()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

wk.register({
	name = "coc",
	-- Use Tab for trigger completion with characters ahead and navigate
	-- NOTE: There's always a completion item selected by default, you may want to enable
	-- no select by setting `"suggest.noselect": true` in your configuration file
	-- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
	-- other plugins before putting this into your config
	["<TAB>"] = {
		'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
		"Next tab completion",
	},
	["<S-TAB>"] = { [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], "Previous tab completion" },
	-- Make <CR> to accept selected completion item or notify coc.nvim to format
	["<CR>"] = {
		[[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
		"Accept tab completion",
	},
}, { silent = true, noremap = true, expr = true, replace_keycodes = false, mode = "i" })

function _G.show_docs()
	local cw = vim.fn.expand("<cword>")
	if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
		vim.api.nvim_command("h " .. cw)
	elseif vim.api.nvim_eval("coc#rpc#ready()") then
		vim.fn.CocActionAsync("doHover")
	else
		vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
	end
end

vim.api.nvim_create_augroup("CocGroup", {})

-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_autocmd("CursorHold", {
	group = "CocGroup",
	command = "silent call CocActionAsync('highlight')",
	desc = "Highlight symbol under cursor on CursorHold",
})

-- Setup formatexpr specified filetype(s)
vim.api.nvim_create_autocmd("FileType", {
	group = "CocGroup",
	pattern = "typescript,json",
	command = "setl formatexpr=CocAction('formatSelected')",
	desc = "Setup formatexpr specified filetype(s).",
})

-- Update signature help on jump placeholder
vim.api.nvim_create_autocmd("User", {
	group = "CocGroup",
	pattern = "CocJumpPlaceholder",
	command = "call CocActionAsync('showSignatureHelp')",
	desc = "Update signature help on jump placeholder",
})

wk.register({
	name = "coc",
	["[g"] = { "<Plug>(coc-diagnostic-prev)", "Go to previous diagnostic" },
	["]g"] = { "<Plug>(coc-diagnostic-next)", "previous_diagnostic_location" },

	-- GoTo code navigation
	["gd"] = { "<Plug>(coc-definition)", "Go to definition" },
	["gy"] = { "<Plug>(coc-type-definition)", "Go to type definition" },
	["gi"] = { "<Plug>(coc-implementation)", "Go to implementation" },

	-- Docs
	["K"] = { "<CMD>lua _G.show_docs()<CR>", "Use K to show documentation in preview window" },
	-- Symbol renaming
	["<leader>rn"] = { "<Plug>(coc-rename)", "Rename the current symbol" },
	-- Remap keys for apply code actions at the cursor position.
	["<leader>ac"] = { "<Plug>(coc-codeaction-cursor)", "Apply codeaction at cursor" },
	-- Remap keys for apply code actions affect whole buffer.
	["<leader>as"] = { "<Plug>(coc-codeaction-source)", "Apply codeaction to all buffers" },
	-- Apply the most preferred quickfix action on the current line.
	["<leader>qf"] = { "<Plug>(coc-fix-current)", "Apply quickfix" },
	-- Run the Code Lens actions on the current line
	["<leader>cl"] = { "<Plug>(coc-codelens-action)", "Run Code Lens on current line" },
}, {
	mode = "n",
	silent = true,
})

wk.register({
	name = "coc",
	["<leader>f"] = { "<Plug>(coc-format-selected)", "Formatting selected code" },
	["<leader>F"] = { "<Plug>(coc-format)", "Format the buffer" },

	-- -- Apply codeAction to the selected region
	-- -- Example: `<leader>aap` for current paragraph
	["<leader>a"] = { "<Plug>(coc-codeaction-selected)", "Apply the codeaction" },

	-- Remap keys for apply refactor code actions.
	["<leader>re"] = { "<Plug>(coc-codeaction-refactor)", "Refactor" },
	["<leader>r"] = { "<Plug>(coc-codeaction-refactor-selected)", "Refactor selected" },
}, { mode = { "x", "n" } })

wk.register({
	name = "coc",
	-- Map function and class text objects
	-- NOTE: Requires 'textDocument.documentSymbol' support from the language server
	["if"] = { "<Plug>(coc-funcobj-i)", "Select in function" },
	["af"] = { "<Plug>(coc-funcobj-a)", "Select around function" },
	["ic"] = { "<Plug>(coc-classobj-i)", "Select in class" },
	["ac"] = { "<Plug>(coc-classobj-a)", "Select around class" },
}, {
	mode = { "x", "o" },
})


-- -- Remap <C-f> and <C-b> to scroll float windows/popups
-- ---@diagnostic disable-next-line: redefined-local
-- local opts = { silent = true, nowait = true, expr = true }
-- keyset(
-- 	"n",
-- 	"<C-f>",
-- 	'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"',
-- 	opts,
-- 	"Coc",
-- 	"[n]scroll_forward",
-- 	"Scroll forward"
-- )
-- keyset(
-- 	"i",
-- 	"<C-f>",
-- 	'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"',
-- 	opts,
-- 	"Coc",
-- 	"[i]scroll_forward",
-- 	"Scroll forward"
-- )
-- keyset(
-- 	"v",
-- 	"<C-f>",
-- 	'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"',
-- 	opts,
-- 	"Coc",
-- 	"[v]scroll_forward",
-- 	"Scroll forward"
-- )
--
-- keyset(
-- 	"n",
-- 	"<C-b>",
-- 	'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"',
-- 	opts,
-- 	"Coc",
-- 	"[n]scroll_back",
-- 	"Scroll back"
-- )
-- keyset(
-- 	"i",
-- 	"<C-b>",
-- 	'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"',
-- 	opts,
-- 	"Coc",
-- 	"[i]scroll_back",
-- 	"Scroll back"
-- )
-- keyset(
-- 	"v",
-- 	"<C-b>",
-- 	'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"',
-- 	opts,
-- 	"Coc",
-- 	"[v]scroll_back",
-- 	"Scroll back"
-- )
--
-- -- Use CTRL-S for selections ranges
-- -- Requires 'textDocument/selectionRange' support of language server
-- keyset({"n", "s"}, "<C-s>", "<Plug>(coc-range-select)", { silent = true }, "Coc", "[n]select_range", "Select range")
--
--
--
--
--
-- -- code actions and coc stuff
-- ---@diagnostic disable-next-line: redefined-local
-- local opts = { silent = true, nowait = true }
-- -- Manage extensions
-- keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts, "Coc", "list_extensions", "List extension")
-- --
-- -- Find symbol of current document
-- keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts, "Coc", "list outline", "Show outline")
-- keyset("n", "<C-o>", ":CocOutline<CR>", { silent = true, nowait = true }, "Coc", "outline", "Show outline")
--
-- -- Do default action for next item
-- keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts, "Coc", "next", "Next item")
-- -- Do default action for previous item
-- keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts, "Coc", "prev", "Previous item")
-- --}
