return {
	{
		"mhartington/formatter.nvim",
		event = "BufWritePost",
		config = function()
			local augroup = vim.api.nvim_create_augroup
			local autocmd = vim.api.nvim_create_autocmd
			augroup("__formatter__", { clear = true })
			autocmd("BufWritePost", {
				group = "__formatter__",
				command = ":FormatWrite",
			})
			-- Utilities for creating configurations
			local util = require("formatter.util")

			-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
			require("formatter").setup({
				-- Enable or disable logging
				logging = true,
				-- Set the log level
				log_level = vim.log.levels.WARN,
				-- All formatter configurations are opt-in
				filetype = {
					-- Formatter configurations for filetype "lua" go here
					-- and will be executed in order
					lua = {
						-- "formatter.filetypes.lua" defines default configurations for the
						-- "lua" filetype
						require("formatter.filetypes.lua").stylua,
					},
					sh = {
						require("formatter.filetypes.sh").shfmt,
					},
					htmldjango = {
						{
							exe = "djlint",
							args = {
								"--profile=django",
								"--quiet",
								"--reformat",
								"--custom-html",
								"json-schema-form",
								"--custom-html",
								"monaco-editor",
								"-",
							},
							stdin = true,
						},
					},
					python = {
						require("formatter.filetypes.python").ruff,
					},
					typescript = {
						require("formatter.filetypes.typescript").prettier,
					},
					typescriptreact = {
						require("formatter.filetypes.typescript").prettier,
					},
					json = {
						require("formatter.filetypes.json").prettier,
					},
					jsonc = {
						require("formatter.filetypes.json").prettier,
					},
					javascriptreact = {
						require("formatter.filetypes.javascript").prettier,
					},
					javascript = {
						require("formatter.filetypes.javascript").prettier,
					},
					yaml = {
						require("formatter.filetypes.yaml").prettier,
					},
					html = {
						require("formatter.filetypes.html").prettier,
					},
					sql = {
						require("formatter.filetypes.sql").pgformat,
					},
					toml = {
						require("formatter.filetypes.toml").taplo,
					},
					beancount = {
						{
							exe = "bean-format",
							stdin = true,
						},
					},

					-- Use the special "*" filetype for defining formatter configurations on
					-- any filetype
					["*"] = {
						-- "formatter.filetypes.any" defines default configurations for any
						-- filetype
						require("formatter.filetypes.any").remove_trailing_whitespace,
					},
				},
			})
		end,
	},
}
