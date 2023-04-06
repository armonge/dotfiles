-- andersevenrud/nordic.nvim {
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.cmd.colorscheme("nordic")
-- }

-- nvim-lualine/lualine.nvim {

require("lualine").setup({
	theme = "nord",
	sections = {

		lualine_c = {
			{

				"filename",
				path = 1,
			},
		},
	},
})
