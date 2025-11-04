return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/nvim-treesitter-context",
			"nvim-treesitter/nvim-treesitter-refactor",
		},
		event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
		cmd = { "TSInstall", "TSUpdate", "TSUpdateSync", "TSUninstall" },
		keys = {
			{
				"[c",
				function()
					require("treesitter-context").go_to_context(vim.v.count1)
				end,
				desc = "Go to context start",
			},
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				refactor = {
					enable = true,
					clear_on_cursor_move = true,
					highlight_current_scope = true,
					highlight_definitions = {
						enable = true,
						clear_on_cursor_move = true,
					},
					smart_rename = {
						enable = true,
						keymaps = {
							smart_rename = "<leader>rn",
						},
					},
					navigation = {
						enable = true,
						-- Assign keymaps to false to disable them, e.g. `goto_definition = false`
						keymaps = {
							goto_definition = "gnd",
							list_definitions = "gnD",
							list_definitions_toc = "gO",
							goto_next_usage = "<a-*>",
							goto_previous_usage = "<a-#>",
						},
					},
				},
				sync_install = false,
				auto_install = true,
				ignore_install = {},
				-- Add languages to be installed here that you want installed for treesitter
				ensure_installed = {
					"c",
					"cpp",
					"go",
					"lua",
					"python",
					"rust",
					"typescript",
					"cmake",
					"vim",
					"regex",
					"bash",
					"markdown",
					"markdown_inline",
					"yaml",
					"javascript",
					"terraform",
					"jsonc",
					"vimdoc",
					"beancount",
					"clojure",
					"diff",
					"html",
					"htmldjango",
					"latex",
					"css",
					"norg",
					"scss",
					"svelte",
					"tsx",
					"typst",
					"vue",
				},
				highlight = {
					enable = true,

					-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
					-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
					-- the name of the parser)
					-- list of language that will be disabled
					disable = {},
					-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
					-- disable = function(lang, buf)
					--     local max_filesize = 100 * 1024 -- 100 KB
					--     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					--     if ok and stats and stats.size > max_filesize then
					--         return true
					--     end
					-- end,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
				autotag = { enable = true },
				textobjects = {
					select = {
						enable = true,
						keymaps = {
							-- Your custom capture.
							-- ["aF"] = "@custom_capture",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",

							-- Built-in captures.
							["af"] = "@function.outer",
							["if"] = "@function.inner",
						},
					},
				},
			})
		end,
	},
}
