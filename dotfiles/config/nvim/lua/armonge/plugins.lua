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
	{
		"OXY2DEV/markview.nvim",
		lazy = false, -- Recommended
		-- ft = "markdown", -- If you decide to lazy-load anyway

		dependencies = {
			-- You will not need this if you installed the
			-- parsers manually
			-- Or if the parsers are in your $RUNTIMEPATH
			"nvim-treesitter/nvim-treesitter",

			"nvim-tree/nvim-web-devicons",
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
		"williamboman/mason.nvim",
		cmd = { "Mason" },
		opts = {
			pip = {
				---@since 1.0.0
				-- Whether to upgrade pip to the latest version in the virtual environment before installing packages.
				upgrade_pip = true,

				---@since 1.0.0
				-- These args will be added to `pip install` calls. Note that setting extra args might impact intended behavior
				-- and is not recommended.
				--
				-- Example: { "--proxy", "https://proxyserver" }
				install_args = {},
			},
		},
	},
	{
		"direnv/direnv.vim",
	},
	{
		"willothy/wezterm.nvim",
		config = true,
	},
	-- { "glacambre/firenvim", build = ":call firenvim#install(0)" },
	{ "m4xshen/hardtime.nvim", dependencies = { "MunifTanjim/nui.nvim" }, opts = {} },
})
-- }
