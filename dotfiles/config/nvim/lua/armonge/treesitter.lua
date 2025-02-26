return {
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		build = ":TSUpdate",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter.configs").setup({
				modules = {},
				sync_install = false,
				auto_install = false,
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
					"html",
					"javascript",
					"terraform",
					"jsonc",
					"vimdoc",
					"beancount",
					"clojure",
					"diff",
					"html",
					"htmldjango",
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
				autotag = { enable = true },
			})
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		ft = {

			"astro",
			"glimmer",
			"handlebars",
			"html",
			"javascript",
			"jsx",
			"markdown",
			"php",
			"rescript",
			"svelte",
			"tsx",
			"typescript",
			"latex",
			"vue",
			"xml",
		},
	},
	{
		"Wansmer/treesj",
		keys = {
			{
				"<space>m",
				desc = "Split or join code block with autodetect",
			},
			{ "<space>j", desc = "Join code block" },
			{
				"<space>s",
				desc = "Split code block",
			},
		},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		cmd = {
			"TSJToggle",
			"TSJSplit",
			"TSJJoin",
		},
		config = function()
			require("treesj").setup({ --[[ your config ]]
			})
		end,
	},
}
