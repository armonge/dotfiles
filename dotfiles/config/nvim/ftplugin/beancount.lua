vim.bo.commentstring = "; %s"

-- Filter out bean-check diagnostics to avoid duplicates with beancount-lsp.
-- The beancount-language-server reports both its own diagnostics (beancount-lsp)
-- and raw bean-check output, resulting in duplicate warnings.
local orig = vim.lsp.handlers["textDocument/publishDiagnostics"]
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
	if result and result.diagnostics then
		local client = vim.lsp.get_client_by_id(ctx.client_id)
		if client and client.name == "beancount" then
			result.diagnostics = vim.tbl_filter(function(d)
				return d.source ~= "bean-check"
			end, result.diagnostics)
		end
	end
	return orig(err, result, ctx, config)
end
