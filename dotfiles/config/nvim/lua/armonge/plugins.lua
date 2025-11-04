-- folke/lazy.nvim {
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
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
	-- {
	-- 	"willothy/wezterm.nvim",
	-- 	config = true,
	-- },
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
	{
		"rest-nvim/rest.nvim",
		ft = { "http" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			opts = function(_, opts)
				opts.ensure_installed = opts.ensure_installed or {}
				table.insert(opts.ensure_installed, "http")
			end,
		},
	},

	{ "akinsho/git-conflict.nvim", version = "*", config = true },
})
-- }
--
