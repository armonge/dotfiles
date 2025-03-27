-- folke/lazy.nvim {
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

require("lazy").setup({
	{ import = "armonge.mini" },
	{ import = "armonge.snacks" },
	{ import = "armonge.oil" },
	{ import = "armonge.theme" },
	{ import = "armonge.treesitter" },
	{ import = "armonge.lsp" },
	{ import = "armonge.blink" },
	{ import = "armonge.motions" },
	{ import = "armonge.copilot" },
	-- { import = "armonge.avante" },
	-- { import = "armonge.codecompanion" },
	{
		"OXY2DEV/markview.nvim",
		lazy = false, -- Recommended
		dependencies = {
			-- You will not need this if you installed the
			-- parsers manually
			-- Or if the parsers are in your $RUNTIMEPATH
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
			"saghen/blink.cmp",
		},
	},
	{
		"wakatime/vim-wakatime",
	},

	{
		"lambdalisue/suda.vim",
		cmd = { "SudaRead", "SudaWrite" },
	},

	{
		"direnv/direnv.vim",
	},
	{
		"willothy/wezterm.nvim",
		config = true,
	},
	-- { "glacambre/firenvim", build = ":call firenvim#install(0)" },
	-- { "m4xshen/hardtime.nvim", dependencies = { "MunifTanjim/nui.nvim" }, opts = {} },
	{
		"gw31415/deepl-commands.nvim",
		dependencies = { "gw31415/deepl.vim" },
		opts = {},
	},
	{
		"MagicDuck/grug-far.nvim",
		config = function()
			-- optional setup call to override plugin options
			-- alternatively you can set options with vim.g.grug_far = { ... }
			require("grug-far").setup({
				-- options, see Configuration section below
				-- there are no required options atm
				-- engine = 'ripgrep' is default, but 'astgrep' or 'astgrep-rules' can
				-- be specified
			})
		end,
	},
	{ "vladdoster/remember.nvim", config = true, main = "remember" },
	{

		"stevearc/conform.nvim",
		opts = {
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				yaml = {
					"prettier",
				},
				clojure = {
					"joker",
				},
				lua = {
					"stylua",
				},
				sh = {
					"shfmt",
					"shellcheck",
				},
				json = {
					"biome",
				},
				javascript = {
					"biome",
				},
				html = {
					"biome",
				},
				htmldjango = {
					"djlint",
				},
				javascriptreact = {
					"biome",
					"biome-check",
				},
				typescript = {
					"biome",
					"biome-check",
				},
				typescriptreact = {
					"biome",
					"biome-check",
				},
				toml = {
					"taplo",
				},
				python = {
					"ruff_fix",
					"ruff_format",
					"ruff_organize_imports",
				},
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		config = true,
		opts = {},
	},
})
-- }
