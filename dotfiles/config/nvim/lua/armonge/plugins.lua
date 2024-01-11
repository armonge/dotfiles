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

-- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.mapleader = ","

require("lazy").setup({
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
      "ibhagwan/fzf-lua",              -- optional
    },
    config = function()
      local neogit = require('neogit')
      local wk = require("which-key")
      neogit.setup({})

      wk.register({
        g = {
          name = "Neogit",
          ["o"] = { function()
            neogit.open()
          end, "Neogit Open" }
        }
      }, { prefix = "<leader>" })
    end,
  },
  { "folke/neodev.nvim",               opts = {} },
  -- "folke/zen-mode.nvim",
  -- "folke/twilight.nvim",
  "honza/vim-snippets",
  -- "SirVer/ultisnips",
  "tpope/vim-sensible",
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
  "wakatime/vim-wakatime",

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {

    "jamessan/vim-gnupg",
    event = 'VeryLazy'
  },
  {
    "kevinhwang91/rnvimr",
    event = 'VeryLazy'
  },
  {

    "antoyo/vim-licenses",
    event = 'VeryLazy'
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({
        -- add any options here
        mappings = {
          basic = true,
          extra = true,
        },
      })
    end,
    event = 'VeryLazy'
  },
  -- {
  --   "neoclide/coc.nvim",
  --   branch = "release",
  --   -- event = 'VeryLazy',
  -- },
  {
    "vim-scripts/sessionman.vim",
    event = 'VeryLazy'
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {} -- this is equalent to setup({}) function
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  {
    "LunarVim/bigfile.nvim",
    event = 'VeryLazy',
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }

      local hooks = require "ibl.hooks"
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      require("ibl").setup { indent = { highlight = highlight } }
    end,
    opts = {}
  },

  {
    "nvim-telescope/telescope.nvim",
    event = 'VeryLazy',
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- {
  --   "fannheyward/telescope-coc.nvim",
  --   event = 'VeryLazy',
  --   dependencies = { "nvim-telescope/telescope.nvim" },
  -- },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    event = 'VeryLazy',
    build =
    "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    event = 'VeryLazy',
    config = function()
      require("telescope").load_extension("frecency")
    end,
  },
  {
    "rcarriga/nvim-notify",
    event = 'VeryLazy',
  },
  {
    "folke/noice.nvim",
    event = 'VeryLazy',
    config = function()
      local noice = require('noice')
      local wk = require("which-key")

      wk.register({
        n = {
          name = "Noice",
          ["d"] = { function()
            noice.cmd('dismiss')
          end, "Noice dismiss" }
        }
      }, { prefix = "<leader>" })

      noice.setup({
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
          bottom_search = true,         -- use a classic bottom cmdline for search
          command_palette = true,       -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,           -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false,       -- add a border to hover docs and signature help
        },
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "folke/which-key.nvim",
    },
  },
  {
    "lambdalisue/suda.vim",
    event = 'VeryLazy',
    config = function()
      vim.g.suda_smart_edit = 1
    end
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")

      -- flash
      wk.register({
        -- flash search
        l = {
          name = "flash",
          ["s"] = { function() require("flash").jump() end, "Flash Jump" },
          ["t"] = { function() require("flash").treesitter() end, "Flash Treesitter" },
          ["r"] = { function() require("flash").treesitter_search() end, "Flash Treesitter Search" },
        },
      }, { prefix = "<leader>" })
    end
  },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'VeryLazy',
    config = function()
      local treesj = require('treesj')
      local wk = require("which-key")

      treesj.setup({ use_default_keymaps = false, })
      wk.register({
        t = {
          name = "Treesj",
          ["m"] = { function() require('treesj').toggle() end, "Toggle node under cursor" },
          ["j"] = { function() require('treesj').join() end, "Join node under cursor" },
          ["s"] = { function() require('treesj').split() end, "Split node under cursor" },
        }
      }, { prefix = '<space>' })
    end,
  },
  {
    "mechatroner/rainbow_csv"
  },
  {
    'natecraddock/workspaces.nvim',
    opts = {
      hooks = {
        open = { "Telescope find_files" },
      }
    }
  },

  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
    }
  },
  { 'neovim/nvim-lspconfig' },
  {
    'hrsh7th/nvim-cmp', -- Autocompletion plugin
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',     -- LSP source for nvim-cmp
      'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
      'L3MON4D3/LuaSnip',         -- Snippets plugin

      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'petertriho/cmp-git',
      "f3fora/cmp-spell"
    }
  },
  {
    'petertriho/cmp-git',
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },
  {
    "Dynge/gitmoji.nvim",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    opts = {},
    ft = "gitcommit",
  },
  {
    "f3fora/cmp-spell",
    config = function()
      require('cmp').setup({
        sources = {
          {
            name = 'spell',
            option = {
              keep_all_entries = false,
              enable_in_context = function()
                return true
              end,
            },
          },
        },
      })
    end
  },
  {
    "elentok/format-on-save.nvim",
    config = function()
      local format_on_save = require("format-on-save")
      local formatters = require("format-on-save.formatters")
      format_on_save.setup({
        exclude_path_patterns = {
          "/node_modules/",
          ".local/share/nvim/lazy",
        },
        formatter_by_ft = {
          css = formatters.lsp,
          html = formatters.lsp,
          java = formatters.lsp,
          javascript = formatters.lsp,
          json = formatters.lsp,
          lua = formatters.lsp,
          markdown = formatters.prettierd,
          openscad = formatters.lsp,
          rust = formatters.lsp,
          scad = formatters.lsp,
          scss = formatters.lsp,
          sh = formatters.shfmt,
          terraform = formatters.lsp,
          typescript = formatters.prettierd,
          typescriptreact = formatters.prettierd,
          yaml = formatters.lsp,
          python = formatters.ruff

          -- Concatenate formatters
          -- python = {
          --     formatters.remove_trailing_whitespace,
          --     formatters.shell({ cmd = {"tidy-imports"} }),
          --     formatters.black,
          --     formatters.ruff,
          -- },
        },
        -- Optional: fallback formatter to use when no formatters match the current filetype
        fallback_formatter = {
          formatters.remove_trailing_whitespace,
          formatters.remove_trailing_newlines,
          -- formatters.prettierd,
        },

        -- By default, all shell commands are prefixed with "sh -c" (see PR #3)
        -- To prevent that set `run_with_sh` to `false`.
        -- run_with_sh = false,
      })
    end
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local trouble = require('trouble')
      local wk = require("which-key")
      trouble.setup({})
      wk.register({
        ["<leader>T"] = {
          name = "Trouble",
          ['T'] = { trouble.toggle, "Toggles trouble window" }

        }
      })
    end
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
  {
    "simrat39/symbols-outline.nvim",
    opts = {
      symbols = {
        File = { icon = "", hl = "@text.uri" },
        Module = { icon = "", hl = "@namespace" },
        Namespace = { icon = "", hl = "@namespace" },
        Package = { icon = "", hl = "@namespace" },
        Class = { icon = "", hl = "@type" },
        Method = { icon = "ƒ", hl = "@method" },
        Property = { icon = "", hl = "@method" },
        Field = { icon = "", hl = "@field" },
        Constructor = { icon = "", hl = "@constructor" },
        Enum = { icon = "", hl = "@type" },
        Interface = { icon = "", hl = "@type" },
        Function = { icon = "", hl = "@function" },
        Variable = { icon = "", hl = "@constant" },
        Constant = { icon = "", hl = "@constant" },
        String = { icon = "", hl = "@string" },
        Number = { icon = "#", hl = "@number" },
        Boolean = { icon = "", hl = "@boolean" },
        Array = { icon = "", hl = "@constant" },
        Object = { icon = "", hl = "@type" },
        Key = { icon = "", hl = "@type" },
        Null = { icon = "", hl = "@type" },
        EnumMember = { icon = "", hl = "@field" },
        Struct = { icon = "", hl = "@type" },
        Event = { icon = "", hl = "@type" },
        Operator = { icon = "", hl = "@operator" },
        TypeParameter = { icon = "", hl = "@parameter" },
        Component = { icon = "", hl = "@function" },
        Fragment = { icon = "", hl = "@constant" },
      }
    },
    config = function()
      local wk = require("which-key")
      local so = require('symbols-outline')
      so.setup({
        symbols = {
          File = { icon = "", hl = "@text.uri" },
          Module = { icon = "", hl = "@namespace" },
          Namespace = { icon = "", hl = "@namespace" },
          Package = { icon = "", hl = "@namespace" },
          Class = { icon = "", hl = "@type" },
          Method = { icon = "ƒ", hl = "@method" },
          Property = { icon = "", hl = "@method" },
          Field = { icon = "", hl = "@field" },
          Constructor = { icon = "", hl = "@constructor" },
          Enum = { icon = "", hl = "@type" },
          Interface = { icon = "", hl = "@type" },
          Function = { icon = "", hl = "@function" },
          Variable = { icon = "", hl = "@constant" },
          Constant = { icon = "", hl = "@constant" },
          String = { icon = "", hl = "@string" },
          Number = { icon = "#", hl = "@number" },
          Boolean = { icon = "", hl = "@boolean" },
          Array = { icon = "", hl = "@constant" },
          Object = { icon = "", hl = "@type" },
          Key = { icon = "", hl = "@type" },
          Null = { icon = "", hl = "@type" },
          EnumMember = { icon = "", hl = "@field" },
          Struct = { icon = "", hl = "@type" },
          Event = { icon = "", hl = "@type" },
          Operator = { icon = "", hl = "@operator" },
          TypeParameter = { icon = "", hl = "@parameter" },
          Component = { icon = "", hl = "@function" },
          Fragment = { icon = "", hl = "@constant" },
        }

      })
      wk.register({
        ['<C-o>'] = { so.toggle_outline, "Toggle Symbols Outline" }
      })
    end
  },
  {
    "tpope/vim-fugitive",
    dependencies = { "tpope/vim-rhubarb" }
  },
  {
    "tpope/vim-abolish"
  },
})
-- }
