return {
	{
		"stevearc/oil.nvim",
		lazy = true,
		cmd = { "Oil" },
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons", "folke/snacks.nvim" },
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
				["yp"] = {
					desc = "Copy filepath to system clipboard",
					callback = function()
						require("oil.actions").copy_entry_path.callback()
						vim.fn.setreg("+", vim.fn.getreg(vim.v.register))
					end,
				},
			},
		},
		config = function(_, opts)
			require("oil").setup(opts)
			vim.api.nvim_create_autocmd("User", {
				pattern = "OilActionsPost",
				callback = function(event)
					if event.data.actions.type == "move" then
						Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
					end
				end,
			})
		end,
	},
}
