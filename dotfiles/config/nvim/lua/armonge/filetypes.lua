-- FileTypes {
local function set_filetype(extensions, filetype)
	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
		pattern = extensions,
		callback = function()
			vim.opt.filetype = filetype
		end,
	})
end

set_filetype("*.html.twig", "html.twig")
set_filetype("*.js", "javascript")
set_filetype(".bashenv", "sh")
set_filetype(".envrc", "sh")
set_filetype(".eslintrc", "json")
set_filetype("*.json", "jsonc")
set_filetype("~/.config/regolith/i3/config", "i3config")
set_filetype("~/.ask/cli_config", "json")
set_filetype("*.code-workspace", "jsonc")

-- }
