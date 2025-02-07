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

-- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.mapleader = ","

require("lazy").setup({
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
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = {
				enabled = true,
				notify = true, -- show notification when big file detected
			},
			dashboard = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true, icon = " " },
			notifier = {
				enabled = true,
				timeout = 3000,
			},
			quickfile = { enabled = true },
			words = { enabled = true },
			scroll = { enabled = true },
			scope = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			styles = {
				notification = {
					wo = { wrap = true }, -- Wrap notifications
				},
			},
		},

		keys = {
			{
				"<leader>n",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Notification History",
			},
			{
				"<leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete Buffer",
			},
			{
				"<leader>gB",
				function()
					Snacks.gitbrowse()
				end,
				desc = "Git Browse",
			},
			{
				"<leader>gb",
				function()
					Snacks.git.blame_line()
				end,
				desc = "Git Blame Line",
			},
			{
				"<leader>un",
				function()
					Snacks.notifier.hide()
				end,
				desc = "Dismiss All Notifications",
			},
    { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Setup some globals for debugging (lazy-loaded)
					_G.dd = function(...)
						Snacks.debug.inspect(...)
					end
					_G.bt = function()
						Snacks.debug.backtrace()
					end
					vim.print = _G.dd -- Override print to use snacks for `:=` command

					Snacks.input.enable()
					-- Create some toggle mappings
					Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
					Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
					Snacks.toggle.diagnostics():map("<leader>ud")
					Snacks.toggle.line_number():map("<leader>ul")
					Snacks.toggle
						.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
						:map("<leader>uc")
					Snacks.toggle.treesitter():map("<leader>uT")
					Snacks.toggle
						.option("background", { off = "light", on = "dark", name = "Dark Background" })
						:map("<leader>ub")
					Snacks.toggle.inlay_hints():map("<leader>uh")
					Snacks.toggle.indent():map("<leader>ug")
					Snacks.toggle.dim():map("<leader>uD")
				end,
			})
		end,
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
		dependencies = { "folke/lazydev.nvim" },
	},
	{
		"tpope/vim-sensible",
	},
	{
		"wakatime/vim-wakatime",
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
	-- {
	-- 	"kevinhwang91/nvim-ufo",
	-- 	dependencies = { "kevinhwang91/promise-async" },
	-- 	config = function()
	-- 		-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
	-- 		vim.keymap.set("n", "zR", require("ufo").openAllFolds)
	-- 		vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
	-- 		vim.keymap.set("n", "K", function()
	-- 			local winid = require("ufo").peekFoldedLinesUnderCursor()
	-- 			if not winid then
	-- 				-- choose one of coc.nvim and nvim lsp
	-- 				vim.lsp.buf.hover()
	-- 			end
	-- 		end)
	-- 		require("ufo").setup({
	-- 			provider_selector = function(bufnr, filetype, buftype)
	-- 				return { "treesitter", "indent" }
	-- 			end,
	-- 		})
	-- 	end,
	-- },
	{
		"direnv/direnv.vim",
	},
	{
		"willothy/wezterm.nvim",
		config = true,
	},
	-- { "glacambre/firenvim", build = ":call firenvim#install(0)" },
	{
		"m4xshen/hardtime.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {},
	},
})
-- }
