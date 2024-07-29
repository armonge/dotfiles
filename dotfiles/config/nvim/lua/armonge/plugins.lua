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

		"stevearc/profile.nvim",
		lazy = true,
		config = function()
			local should_profile = os.getenv("NVIM_PROFILE")
			if should_profile then
				require("profile").instrument_autocmds()
				if should_profile:lower():match("^start") then
					vim.notify("Profiling started")
					require("profile").start("*")
				else
					vim.notify("Profiling instrumented")
					require("profile").instrument("*")
				end
			end

			local function toggle_profile()
				local prof = require("profile")
				if prof.is_recording() then
					prof.stop()
					vim.notify("Profiling stopped")
					vim.ui.input(
						{ prompt = "Save profile to:", completion = "file", default = "profile.json" },
						function(filename)
							if filename then
								prof.export(filename)
								vim.notify(string.format("Wrote %s", filename))
							end
						end
					)
				else
					vim.notify("Profiling started")
					prof.start("*")
				end
			end
			vim.keymap.set("", "<f1>", toggle_profile)
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	-- Enable profiling of lazy.nvim. This will add some overhead,
	-- so only enable this when you are debugging lazy.nvim
	{
		"dstein64/vim-startuptime",
		-- lazy-load on a command
		cmd = "StartupTime",
		-- init is called during startup. Configuration for vim plugins typically should be set in an init function
		init = function()
			vim.g.startuptime_tries = 10
		end,
	},
	{ import = "armonge.telescope" },
	{ import = "armonge.theme" },
	{ import = "armonge.treesitter" },
	{ import = "armonge.lsp" },
	{ import = "armonge.completion" },
	{ import = "armonge.motions" },
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- Library items can be absolute paths
				-- "~/projects/my-awesome-lib",
				-- Or relative, which means they will be resolved as a plugin
				-- "LazyVim",
				-- When relative, you can also provide a path to the library in the plugin dir
				"luvit-meta/library", -- see below
			},
		},
	},
	{
		"folke/neoconf.nvim",
		config = function()
			require("neoconf").setup()
		end,
		dependencies = { "folke/neodev.nvim" },
	},
	{
		"tpope/vim-sensible",
	},
	{
		"tpope/vim-fugitive",
		lazy = true,
		cmd = { "Git", "GBrowse" },
		dependencies = { "tpope/vim-rhubarb" },
	},
	{
		"wakatime/vim-wakatime",
	},
	{
		"jamessan/vim-gnupg",
		-- event = "VeryLazy",
		ft = { "gpg", "pgp" },
	},
	{
		"antoyo/vim-licenses",
		cmd = {
			"Apache",
			"Gpl",
			"Gplv2",
			"Mit",
			"Bsd2",
			"Bsd3",
		},
	},
	{
		"LunarVim/bigfile.nvim",
		opts = {},
	},

	{
		"lambdalisue/suda.vim",
		cmd = { "SudaRead", "SudaWrite" },
	},
	{
		"mechatroner/rainbow_csv",
		ft = { "csv" },
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
		"kawre/neotab.nvim",
		event = "InsertEnter",
		opts = {},
	},
	{
		"stevearc/oil.nvim",
		config = true,
		lazy = true,
		cmd = { "Oil" },
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<C-e>", "<CMD>Oil<CR>", desc = "Open parent directory" },
		},
		opts = {
			default_file_explorer = true,
			use_default_keymaps = false,
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				-- ["<C-s>"] = "actions.select_vsplit",
				-- ["<C-h>"] = "actions.select_split",
				["<C-t>"] = "actions.select_tab",
				["<C-p>"] = "actions.preview",
				["<C-c>"] = "actions.close",
				["<C-l>"] = "actions.refresh",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = "actions.tcd",
				["gs"] = "actions.change_sort",
				["gx"] = "actions.open_external",
				["g."] = "actions.toggle_hidden",
				["g\\"] = "actions.toggle_trash",
			},
		},
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		config = function()
			-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
			vim.keymap.set("n", "zR", require("ufo").openAllFolds)
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
			vim.keymap.set("n", "K", function()
				local winid = require("ufo").peekFoldedLinesUnderCursor()
				if not winid then
					-- choose one of coc.nvim and nvim lsp
					vim.lsp.buf.hover()
				end
			end)
			require("ufo").setup({
				provider_selector = function(bufnr, filetype, buftype)
					return { "treesitter", "indent" }
				end,
			})
		end,
	},
	{
		"direnv/direnv.vim",
	},
	{
		"nvim-neotest/neotest",
		lazy = true,
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-python",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python"),
				},
			})
		end,
		keys = {
			{ "<leader>mw", '<cmd>lua require("neotest").watch()<CR>', desc = "Watches current test" },
			{ "<leader>mr", '<cmd>lua require("neotest").run.run()<CR>', desc = "Runs current test" },
			{ "<leader>ms", '<cmd>lua require("neotest").run.stop()<CR>', desc = "Stops neotest" },
			{ "<leader>mo", '<cmd>lua require("neotest").output.open()<CR>', desc = "Shows neotest" },
			{
				"<leader>mO",
				'<cmd>lua require("neotest").output.open({ enter = true})<CR>',
				desc = "Shows neotest and enter",
			},
			{
				"<leader>mi",
				'<cmd>lua require("neotest").summary.toggle()<CR>',
				desc = "Toggle neotest summary",
			},
			{ "<leader>mf", '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>', desc = "Runs current file" },
			{
				"[n",
				'<cmd>lua require("neotest").jump.prev({status = "failed"})<CR>',
				desc = "Go to previous failed test",
			},
			{
				"]n",
				'<cmd>lua require("neotest").jump.next({status = "failed"})<CR>',
				desc = "Go to next failed test",
			},
		},
	},
})
-- }
