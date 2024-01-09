local wk = require("which-key")
-- neoclide/coc.nvim {

vim.g.coc_global_extensions = {
    "coc-pyright",
    "coc-git",
    "coc-snippets",
    "coc-diagnostic",
    "coc-html",
    "coc-json",
    "coc-yaml",
    "coc-sumneko-lua",
    "coc-xml",
    "coc-prettier",
    "coc-tsserver"
}
-- vim.g.coc_node_path = os.getenv("NVM_BIN") .. "/node"

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
    -- Use Tab for trigger completion with characters ahead and navigate
    -- NOTE: There's always a completion item selected by default, you may want to enable
    -- no select by setting `"suggest.noselect": true` in your configuration file
    -- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
    -- other plugins before putting this into your config
    ["<TAB>"] = {
        'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
        "Next",
    },
    ["<S-TAB>"] = { [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], "Previous" },

    -- Make <CR> to accept selected completion item or notify coc.nvim to format
    -- <C-g>u breaks current undo, please make your own choice
    ["<cr>"] = { 'coc#pum#visible() ? coc#_select_confirm() : "<C-g>u<CR>"', "Confirm selection" },
}, { silent = true, noremap = true, expr = true, replace_keycodes = true, mode = "i" })

vim.g.coc_snippet_next = "<tab>"

wk.register({
    ["<leader>c"] = {

        name = "coc",
        ["p"] = { "<Plug>(coc-diagnostic-prev)", "Go to previous diagnostic" },
        ["n"] = { "<Plug>(coc-diagnostic-next)", "previous_diagnostic_location" },

        -- GoTo code navigation
        ["d"] = { "<Plug>(coc-definition)", "Go to definition" },
        ["t"] = { "<Plug>(coc-type-definition)", "Go to type definition" },
        ["i"] = { "<Plug>(coc-implementation)", "Go to implementation" },

        -- Docs
        ["D"] = { "<CMD>lua _G.show_docs()<CR>", "Use K to show documentation in preview window" },
        -- Symbol renaming
        ["r"] = { "<Plug>(coc-rename)", "Rename the current symbol" },
        -- Remap keys for apply code actions at the cursor position.
        ["a"] = { "<Plug>(coc-codeaction-cursor)", "Apply codeaction at cursor" },
        -- Remap keys for apply code actions affect whole buffer.
        ["A"] = { "<Plug>(coc-codeaction-source)", "Apply codeaction to all buffers" },
        -- Apply the most preferred quickfix action on the current line.
        ["f"] = { "<Plug>(coc-fix-current)", "Apply quickfix" },
        -- Run the Code Lens actions on the current line
        ["l"] = { "<Plug>(coc-codelens-action)", "Run Code Lens on current line" },

    },

    -- Find symbol of current document
    ["<C-o>"] = { ":CocOutline<CR>", "Show outline" },

    -- Do default action for next item
    ["<space>j"] = { ":<C-u>CocNext<cr>", "Next item" },

    -- Do default action for previous item
    ["<space>k"] = { ":<C-u>CocPrev<cr>", "Previous item" },
}, {
    mode = "n",
    silent = true,
})

wk.register({
    name = "coc",
    ["f"] = { "<Plug>(coc-format-selected)", "Formatting selected code" },
    ["F"] = { "<Plug>(coc-format)", "Format the buffer" },

    -- -- Apply codeAction to the selected region
    -- -- Example: `<leader>aap` for current paragraph
    ["a"] = { "<Plug>(coc-codeaction-selected)", "Apply the codeaction" },

    -- Remap keys for apply refactor code actions.
    ["re"] = { "<Plug>(coc-codeaction-refactor)", "Refactor" },
    ["r"] = { "<Plug>(coc-codeaction-refactor-selected)", "Refactor selected" },
}, { mode = { "x", "n" }, silent = true, prefix = "<leader>" })

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

wk.register({
    name = "coc",

    -- -- Use <c-j> to trigger snippets
    ["<c-j>"] = { "<Plug>(coc-snippets-expand-jump)", "Use <c-j> to trigger snippets" },

    -- Use <c-space> to trigger completion
    ["<c-space>"] = { "coc#refresh()", "Use <c-space> to trigger completion" },
}, { mode = "i", expr = true, silent = true, remap = true })

-- Use CTRL-S for selections ranges
-- Requires 'textDocument/selectionRange' support of language server
wk.register({
    name = "coc",
    ["<C-m>"] = { "<Plug>(coc-range-select)", "Select range" },
}, { mode = { "n", "s" } })




function DiagnosticNotify()
    local info = vim.b["coc_diagnostic_info"]
    if info == nil then
        return ""
    end
    local msgs = {}
    local level = "info"

    if info["warning"] then
        level = "warning"
    end

    if info["error"] then
        level = "error"
    end

    if info["error"] then
        msgs.insert(" Errors: " .. info["error"])
    end

    if info["warning"] then
        msgs.insert(" Warnings: " .. info["warning"])
    end

    if info["information"] then
        msgs.insert(" Infos: " .. info["info"])
    end

    if info["hint"] then
        msgs.insert(" Hints: " .. info["hint"])
    end

    local msg = table.concat(msgs, "\n")
    if msg == "" then
        msg = " All OK"
    end

    vim.v.coc_diag_notify(msg, level)
end

function StatusNotify()
    local status = vim.g["coc_status"]
    local level = "info"
    if status == nil then
        return
    end

    vim.v.coc_status_notify(status, level)
end

function InitCoc()
    vim.notify("Initialized coc.nvim for LSP support", "info", { title = "LSP Status" })
end

vim.api.nvim_create_autocmd("User", {
    pattern = "CocNvimInit",
    callback = InitCoc,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "CocDiagnosticChange",
    callback = DiagnosticNotify,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "CocStatusChange",
    callback = StatusNotify,
})
