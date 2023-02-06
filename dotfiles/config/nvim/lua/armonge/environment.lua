-- Python {
if vim.fn.has("pythonx") then
	vim.opt.pyx = 3
end

-- Python2 for neovim {
if vim.fn.filereadable(os.getenv("HOME") .. "/.pyenv/versions/nvim2/bin/python") then
	vim.g.python2_host_prog = os.getenv("HOME") .. "/.pyenv/versions/nvim2/bin/python"
end
-- }

-- Python3 for neovim {
if vim.fn.filereadable(os.getenv("HOME") .. "/.pyenv/versions/nvim3/bin/python") then
	vim.g.python3_host_prog = os.getenv("HOME") .. "/.pyenv/versions/nvim3/bin/python"
	vim.g.python_host_prog = os.getenv("HOME") .. "/.pyenv/versions/nvim3/bin/python"
end
-- }
-- }

-- Node {
vim.g.node_host_prog = os.getenv("HOME") .. "/.config/nvm/versions/node/v16.16.0/bin/neovim-node-host"
-- }
