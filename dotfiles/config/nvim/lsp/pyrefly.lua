local util = require("lspconfig.util")

return {
	cmd = { "pyrefly", "lsp" },
	filetypes = { "python" },
	settings = {},
	root_dir = util.root_pattern("pyproject.toml", ".git"),
	on_exit = function(code, _, _)
		vim.notify("Closing Pyrefly LSP exited with code: " .. code, vim.log.levels.INFO)
	end,
}
