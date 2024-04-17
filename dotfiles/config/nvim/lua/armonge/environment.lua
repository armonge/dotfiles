-- Python {
vim.opt.pyx = 3

-- Python2 for neovim {
vim.g.python2_host_prog = os.getenv("PYENV_ROOT") .. "/versions/nvim2/bin/python"
-- }

-- Python3 for neovim {
vim.g.python3_host_prog = os.getenv("PYENV_ROOT") .. "/versions/nvim3/bin/python"
vim.g.python_host_prog = os.getenv("PYENV_ROOT") .. "/versions/nvim3/bin/python"
-- }
-- }

-- Node {
vim.g.node_host_prog = os.getenv("NVM_BIN") .. "/neovim-node-host"
-- }
