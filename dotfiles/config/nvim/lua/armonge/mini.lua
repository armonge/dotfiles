return {
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.comment").setup()
			require("mini.pairs").setup()
			require("mini.surround").setup()
			require("mini.statusline").setup()
			require("mini.basics").setup()
			-- require("mini.completion").setup()
			require("mini.icons").setup()
			require("mini.snippets").setup()
			require("mini.bracketed").setup()

			-- vim.api.nvim_create_autocmd("FileType", {
			-- 	pattern = "snacks_picker_input",
			-- 	desc = "Disable mini.completion for snacks picker",
			-- 	group = vim.api.nvim_create_augroup("user_mini", {}),
			-- 	command = "lua vim.b.minicompletion_disable=true",
			-- })
		end,
	},
}
