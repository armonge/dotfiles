return {

	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"princejoogie/dir-telescope.nvim",
			"benfowler/telescope-luasnip.nvim",
			-- "nvim-telescope/telescope-fzf-native.nvim",
		},
		cmd = {
			"Telescope",
			"Telescope luasnip",
		},
		keys = {

			{ "<leader>tt", "<cmd>Telescope<CR>", "Shows all telescopes" },
			{
				"<leader>tF",
				function()
					local builtin = require("telescope.builtin")
					local utils = require("telescope.utils")

					builtin.live_grep({ cwd = utils.buffer_dir() })
				end,
				desc = "Find files in buffer_dir",
			},
			{
				"<leader>tp",
				"<cmd>Telescope smart_open<CR>",
				desc = "Searches filenames with telescope",
			},
			{ "<leader>th", "<cmd>Telescope help_tags<CR>", desc = "Searches on help_tags with Telescope" },
			{ "<leader>td", "<cmd>Telescope diagnostics<CR>", desc = "Searches diagnostics with Telescope" },
			{ "<leader>tq", "<cmd>Telescope quickfix<CR>", desc = "Searches quickfix list Telescope" },
			{
				"<leader>ts",
				"<cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
				desc = "Dynamically Lists LSP for all workspace symbols",
			},
			{
				"<leader>tS",
				"<cmd>Telescope lsp_document_symbols<CR>",
				desc = "Searches document symbols with Telescope",
			},
			{ "<leader>tC", "<cmd>Telescope commands<CR>", desc = "Searches vim commands with Telescope" },
			{ "<leader>tb", "<cmd>Telescope buffers<CR>", desc = "Searches open buffers with Telescope" },
			{ "<leader>tr", "<cmd>Telescope registers<CR>", desc = "Searches registers with Telescope" },
			{ "<leader>to", "<cmd>Telescope oldfiles<CR>", desc = "Searches previously opened files" },
			{ "<leader>tl", "<cmd>Telescope<CR>", desc = "Shows all telescope lists" },
			-- { "<leader>tS", "<cmd>Telescope luasnip<CR>",        desc = "Shows all luasnip snippets" },
			{ "<leader>tw", "<cmd>Telescope workspaces<CR>", desc = "Searches workspaces with telescope" },
			{ "gr", "<cmd>Telescope lsp_references<CR>", desc = "Show references" },
			{ "<C-s>", "<cmd>Telescope live_grep<CR>", desc = "Searches file with grep and Telescope" },
			{
				"<leader>tf",
				"<cmd>Telescope dir live_grep<CR>",
				desc = "Searches file with grep and Telescope inside a directory",
			},
			{ "<C-f>", "<cmd>Telescope resume<CR>", desc = "Continues last Telescope search" },
		},
		config = function()
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
							["<C-h>"] = "which_key",
						},
						n = {

							["<C-h>"] = "which_key",
						},
					},
					preview = {
						treesitter = false,
						highlight_limit = 0.1,
						filesize_limit = 0.01, -- MB
						timeout = 50,
					},
				},
				pickers = {
					buffers = {
						mappings = {
							i = {
								["<C-d>"] = ts_actions.delete_buffer,
							},
						},
					},
				},
				extensions = {
					-- fzf = {
					-- 	fuzzy = true, -- false will only do exact matching
					-- 	override_generic_sorter = true, -- override the generic sorter
					-- 	override_file_sorter = true, -- override the file sorter
					-- 	case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					-- 	-- the default case_mode is "smart_case"
					-- },
					dir = {
						hidden = false,
					},
					ast_grep = {
						command = {
							"sg",
							"--json=stream",
						}, -- must have --json=stream
						grep_open_files = false, -- search in opened files
						lang = nil, -- string value, specify language for ast-grep `nil` for default
					},
				},
			})
			telescope.load_extension("fzy_native")
			telescope.load_extension("workspaces")
			telescope.load_extension("luasnip")
			telescope.load_extension("dir")

			-- Fixes a bug where files opened by Telescope don't work with folds
			vim.api.nvim_create_autocmd("BufEnter", {
				callback = function()
					if vim.opt.foldmethod:get() == "expr" then
						vim.schedule(function()
							vim.opt.foldmethod = "expr"
						end)
					end
				end,
			})
		end,
	},
	{
		"danielfalk/smart-open.nvim",
		branch = "0.2.x",
		config = function()
			require("telescope").load_extension("smart_open")
		end,
		dependencies = {
			"kkharji/sqlite.lua",
			-- Only required if using match_algorithm fzf
			-- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			-- Optional.  If installed, native fzy will be used when match_algorithm is fzy
			{ "nvim-telescope/telescope-fzy-native.nvim" },
		},
	},
	{
		"nvim-telescope/telescope-fzy-native.nvim",
		lazy = true,
		build = "make",
	},
	{
		"benfowler/telescope-luasnip.nvim",
		lazy = true,
		dependencies = { "L3MON4D3/LuaSnip" },
	},

	{
		"natecraddock/workspaces.nvim",
		cmd = { "WorkspacesOpen", "WorkspacesDelete", "WorkspacesRename", "WorkspacesAdd" },
		opts = {
			hooks = {
				open = { "Telescope find_files" },
			},
		},
	},
}
