local beancount = {}
beancount.setup = function()
	beancount.namespace = vim.api.nvim_create_namespace("beancount")
	vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
		group = vim.api.nvim_create_augroup("beancount", { clear = true }),
		-- apigen currently only parses annotations within *.api.go
		-- files so those are the only files we want to check within
		-- neovim as well.
		pattern = "*.beancount",
		callback = beancount.check_current_buffer,
	})
end
beancount.check_current_buffer = function()
	-- Reset all diagnostics for our custom namespace. The second
	-- argument is the buffer number and passing in 0 will select
	-- the currently active buffer.
	vim.diagnostic.reset(beancount.namespace, 0)

	-- Get the path for the current buffer so we can pass that into
	-- the command below.
	local buf_path = vim.api.nvim_buf_get_name(0)

	-- Running `apigen -check FILE_PATH` will print error messages
	-- to stderr but won't generate any code.
	local cmd = { "bean-check", os.getenv("HOME") .. "/beancount/personal.beancount" }
	local buf_path = vim.api.nvim_buf_get_name(0)

	function on_exit(obj)
		local diagnostics = {}
		for line in obj.stderr:gmatch("([^\n]*)\n?") do
			local filepath, linenumber, error = string.match(line, "(.+):(%d+):%s+(.+)")
			if linenumber then
				if filepath == buf_path then
					table.insert(diagnostics, {

						lnum = tonumber(linenumber) - 1,
						col = 0,
						message = error,
					})
				end
			end
		end
		vim.schedule(function()
			vim.diagnostic.reset(beancount.namespace, 0)
			vim.diagnostic.set(beancount.namespace, 0, diagnostics)
		end)
	end

	vim.system(cmd, { text = true }, on_exit)
end

beancount.setup()
