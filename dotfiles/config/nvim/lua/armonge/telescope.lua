local wk = require("which-key")
-- nvim-telescope/telescope.nvim {
local ts_builtin = require("telescope.builtin")
local ts_actions = require("telescope.actions")

local telescope = require("telescope")
telescope.setup({
    defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        mappings = {
            i = {
                -- map actions.which_key to <C-h> (default: <C-/>)
                -- actions.which_key shows the mappings for your picker,
                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                ["<C-h>"] = "which_key"
            },
            n = {

                ["<C-h>"] = "which_key"
            }
        }
    },
    pickers = {
        buffers = {
            mappings = {
                i = {
                    ["<C-d>"] = ts_actions.delete_buffer
                }
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
    },
})

telescope.load_extension("notify")
telescope.load_extension("fzf")
telescope.load_extension("noice")
telescope.load_extension("workspaces")
local find_files = function ()
    return ts_builtin.find_files({ follow = true, hidden = true })
end
local trouble = require("trouble.providers.telescope")

wk.register({
    ["<leader>t"] = {
        name = "Telescope",
        ["t"] = { ts_builtin.builtin, "Searches filenames with telescope" },
        ["p"] = { find_files, "Searches filenames with telescope" },
        ["n"] = { ts_builtin.help_tags, "Searches on help_tags with Telescope" },
        ["a"] = { ts_builtin.diagnostics, "Searches diagnostics with Telescope" },
        ["q"] = { ts_builtin.quickfix, "Searches quickfix list Telescope" },
        ["A"] = { ts_builtin.lsp_workspace_symbols, "Searches workspace_diagnostics with Telescope", },
        ["C"] = { ts_builtin.commands, "Searches vim commands with Telescope" },
        ["s"] = { ts_builtin.lsp_workspace_symbols, "Searches workspace symbols with Telescope" },
        ["b"] = { ts_builtin.buffers, "Searches open buffers with Telescope" },
        ["r"] = { ts_builtin.registers, "Searches registers with Telescope" },
        ["o"] = { ts_builtin.oldfiles, "Searches previously opened files" },
        ["l"] = { "<cmd>Telescope<CR>", "Shows all telescope lists" },
        ["f"] = { "<Cmd>Telescope frecency workspace=CWD<CR>", "frecency" },
        ["h"] = { "<Cmd>Telescope noice<CR>", "Noice History" },
        ["w"] = { "<Cmd>Telescope workspaces<CR>", "Searches workspaces with telescope" },

    },
    ["gr"] = { ts_builtin.lsp_references, "Show references" },
    ["<C-s>"] = { ts_builtin.live_grep, "Searches file with grep and Telescope" },
    ["<C-f>"] = { ts_builtin.resume, "Continues last Telescope search" },
}, { mode = "n" })

-- Fixes a bug where files opened by Telescope don't work with folds
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function ()
        if vim.opt.foldmethod:get() == "expr" then
            vim.schedule(function ()
                vim.opt.foldmethod = "expr"
            end)
        end
    end,
})
