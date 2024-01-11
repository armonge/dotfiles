local wk = require("which-key")


require("mason-lspconfig").setup {
    ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "pyright",
        "beancount",
        "lemminx",
        "yamlls",
        "emmet_language_server",
        'bashls',
        'jsonls',
    },
    automatic_installation = true,
}



-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
wk.register({
    ['<space>e'] = { vim.diagnostic.open_float, "Open diagnostics" },
    ['[d'] = { vim.diagnostic.goto_prev, "Go to previous diagnostic" },
    [']d'] = { vim.diagnostic.goto_next, "Go to next diagnostic" },
})


-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function (ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        wk.register({
            name = "LSP",
            ['g'] = {
                name = 'Go to',
                ['D'] = { vim.lsp.buf.declaration, 'Go to declaration' },
                ['d'] = { vim.lsp.buf.definition, 'Go to definition' },
                ['i'] = { vim.lsp.buf.implementation, "Go to implementation" },
                -- ['t'] = { vim.lsp.buf.type_definition, "Go to type definition" },
            },

            ['<leader>w'] = {
                name = 'Workspaces',
                ['a'] = { vim.lsp.buf.add_workspace_folder, "Add folder to workspace " },
                ['r'] = { vim.lsp.buf.remove_workspace_folder, "Remove folder from workspace" },
                ['l'] = { function ()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, "List workspace folders" },
            },

            ['K'] = { vim.lsp.buf.hover, 'More information on a popup' },
            ['<C-k>'] = { vim.lsp.buf.signature_help, "Signature help" },
            ['<leader>r'] = {
                name = 'Refactor',
                ['n'] = { vim.lsp.buf.rename, "Rename" },
            }

        }, opts)

        wk.register({
            name = "LSP",
            ['<leader>ca'] = { vim.lsp.buf.code_action, 'Apply code action' }
        }, { mode = { 'n', 'v' } })
    end,
})
