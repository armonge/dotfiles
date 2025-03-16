-- Python {
vim.opt.pyx = 3


-- Python3 for neovim {
vim.g.python3_host_prog = os.getenv("HOME") .. "/.config/nvim/.venv/bin/python"
vim.g.python_host_prog = os.getenv("HOME") .. "/.config/nvim/.venv/bin/python"
-- }

-- Node {
vim.g.node_host_prog = os.getenv("NVM_BIN") .. "/neovim-node-host"
-- }
