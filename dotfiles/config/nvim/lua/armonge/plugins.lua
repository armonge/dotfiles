-- folke/lazy.nvim {
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
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
	{ import = "armonge.db" },
	{ import = "armonge.blink" },
	{ import = "armonge.motions" },
	{ import = "armonge.copilot" },
	{ import = "armonge.clojure" },
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
		opts = {},
	},
	{
		"abidibo/nvim-httpyac",
		config = function()
			require("nvim-httpyac").setup({
				output_view = "vertical", -- "vertical" | "horizontal"
			})
			-- if you want to set up the keymaps
			vim.keymap.set("n", "<Leader>rp", "<cmd>:NvimHttpYacPicker<CR>", { desc = "Run named request" })
		end,
	},

	{
		"propilideno/buffer-preview.nvim",
		dependencies = { { "3rd/image.nvim", opts = {} } },
	},
	{ "akinsho/git-conflict.nvim", version = "*", config = true },
	{
		"NeogitOrg/neogit",
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim", -- required

			-- Only one of these is needed.
			"sindrets/diffview.nvim", -- optional
			"esmuellert/codediff.nvim", -- optional

			-- For a custom log pager
			"m00qek/baleia.nvim", -- optional

			-- Only one of these is needed.
			-- "nvim-telescope/telescope.nvim", -- optional
			-- "ibhagwan/fzf-lua", -- optional
			-- "nvim-mini/mini.pick", -- optional
			"folke/snacks.nvim", -- optional
		},
		cmd = "Neogit",
		keys = {
			{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
		},
	},
	-- { "tpope/vim-fugitive", dependencies = {
	-- 	"tpope/vim-rhubarb",
	-- } },
})
-- }
--
