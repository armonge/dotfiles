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
      neogit.setup()

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
  "folke/neodev.nvim",
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
  {
    "neoclide/coc.nvim",
    branch = "release",
    -- event = 'VeryLazy',
  },
  {
    "vim-scripts/sessionman.vim",
    event = 'VeryLazy'
  },
  {
    "jiangmiao/auto-pairs",
    event = 'VeryLazy'
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
    opts = {}
  },

  {
    "nvim-telescope/telescope.nvim",
    event = 'VeryLazy',
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "fannheyward/telescope-coc.nvim",
    event = 'VeryLazy',
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
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
  }
})
-- }
