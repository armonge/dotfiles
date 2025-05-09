return {
	{
		"yetone/avante.nvim",
		keys = function(_, keys)
			---@type avante.Config
			local opts = require("lazy.core.plugin").values(
				require("lazy.core.config").spec.plugins["avante.nvim"],
				"opts",
				false
			)

			local mappings = {
				{
					opts.mappings.ask,
					function()
						require("avante.api").ask()
					end,
					desc = "avante: ask",
					mode = { "n", "v" },
				},
				{
					opts.mappings.refresh,
					function()
						require("avante.api").refresh()
					end,
					desc = "avante: refresh",
					mode = "v",
				},
				{
					opts.mappings.edit,
					function()
						require("avante.api").edit()
					end,
					desc = "avante: edit",
					mode = { "n", "v" },
				},
			}
			mappings = vim.tbl_filter(function(m)
				return m[1] and #m[1] > 0
			end, mappings)
			return vim.list_extend(mappings, keys)
		end,
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		opts = {
			mappings = {
				ask = "<leader>aa", -- ask
				edit = "<leader>ae", -- edit
				refresh = "<leader>ar", -- refresh
			},
			-- The provider used in Aider mode or in the planning phase of Cursor Planning Mode
			---@alias avante.ProviderName "claude" | "openai" | "azure" | "gemini" | "vertex" | "cohere" | "copilot" | "bedrock" | "ollama" | string
			provider = "claude",
			-- WARNING: Since auto-suggestions are a high-frequency operation and therefore expensive,
			-- currently designating it as `copilot` provider is dangerous because: https://github.com/yetone/avante.nvim/issues/1048
			-- Of course, you can reduce the request frequency by increasing `suggestion.debounce`.
			auto_suggestions_provider = "claude",
			---@type AvanteSupportedProvider
			file_selector = {
				provider = "snacks",
			},
			selector = {
				provider = "snacks",
			},
		},
		-- If you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"folke/snacks.nvim",  -- for file_selector provider
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'

			"MeanderingProgrammer/render-markdown.nvim",
		},
	},

	{
		"stevearc/dressing.nvim",
		config = function(_, opts)
			require("dressing").setup(opts)
		end,
		opts = {
			input = {
				enabled = false,
			},
			select = {
				enabled = false,
			},
		},
	},
}
