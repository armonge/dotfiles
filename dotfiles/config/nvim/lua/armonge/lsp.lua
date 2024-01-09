local wk = require("which-key")
local lspconfig = require('lspconfig')

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls",
        "rust_analyzer", "pyright", "beancount",
        "lemminx", "yamlls", "emmet_language_server", 'bashls', 'jsonls' },
    automatic_installation = true,
}

require("mason-lspconfig").setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function (server_name) -- default handler (optional)
        lspconfig[server_name].setup {
            -- on_attach = my_custom_on_attach,
            capabilities = capabilities,
        }
    end,
    -- -- Next, you can provide a dedicated handler for specific servers.
    -- -- For example, a handler override for the `rust_analyzer`:
    -- ["rust_analyzer"] = function()
    --   require("rust-tools").setup {}
    -- end
}


-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
wk.register({
    ['<space>e'] = { vim.diagnostic.open_float, "Open diagnostics" },
    ['[d'] = { vim.diagnostic.goto_prev, "Go to previous diagnostic" },
    [']d'] = { vim.diagnostic.goto_next, "Go to next diagnostic" },
})

vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.py', '*.lua' },
    callback = function ()
        vim.lsp.buf.format({ async = false })
    end,
    desc = "Format on save"
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
                ['t'] = { vim.lsp.buf.type_definition, "Go to type definition" },
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

            ['<leader>rn'] = { vim.lsp.buf.rename, "Rename" },
        }, opts)

        wk.register({
            name = "LSP",
            ['<leader>ca'] = { vim.lsp.buf.code_action, 'Apply code action' }
        }, { mode = { 'n', 'v' } })
    end,
})


-- luasnip setup
local luasnip = require 'luasnip' -- nvim-cmp setup

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
    snippet = {
        expand = function (args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
        ['<C-d>'] = cmp.mapping.scroll_docs(4),  -- Down
        -- C-b (back) C-f (forward) for snippet placeholder navigation.
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function (fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function (fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}
