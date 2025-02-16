-- sql {
vim.g.sql_type_default = "sql.vim"
-- }

-- vim-licenses {
vim.g.licenses_authors_name = "Andrés Reyes Monge <armonge@gmail.com>"
vim.g.licenses_copyright_holders_name = "Andrés Reyes Monge <armonge@gmail.com>"
-- }
--
-- Function to check if a floating dialog exists and if not
-- then check for diagnostics under the cursor
vim.opt.updatetime = 300
function OpenDiagnosticIfNoFloat()
	for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_get_config(winid).zindex then
			return
		end
	end
	-- THIS IS FOR BUILTIN LSP
	vim.diagnostic.open_float(0, {
		scope = "cursor",
		focusable = false,
		close_events = {
			"CursorMoved",
			"CursorMovedI",
			"BufHidden",
			"InsertCharPre",
			"WinLeave",
		},
	})
end
-- Show diagnostics under the cursor when holding position
vim.api.nvim_create_augroup("lsp_diagnostics_hold", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold" }, {
	pattern = "*",
	command = "lua OpenDiagnosticIfNoFloat()",
	group = "lsp_diagnostics_hold",
})
