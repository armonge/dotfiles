require("nvim-treesitter.configs").setup({
	-- Add languages to be installed here that you want installed for treesitter
	ensure_installed = {
		"c",
		"cpp",
		"go",
		"lua",
		"python",
		"rust",
		"typescript",
		"help",
		"cmake",
		"vim",
		"regex",
		"bash",
		"markdown",
		"markdown_inline",
	},
})
