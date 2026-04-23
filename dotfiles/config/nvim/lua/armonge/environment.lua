-- Override gs alias (git-spice) with real ghostscript for plugins that need it {
vim.env.PATH = "/opt/homebrew/opt/ghostscript/bin:" .. vim.env.PATH
-- }

-- Python {
vim.opt.pyx = 3

-- Python3 for neovim {
vim.g.python3_host_prog = os.getenv("HOME") .. "/.config/nvim/.venv/bin/python"
vim.g.python_host_prog = os.getenv("HOME") .. "/.config/nvim/.venv/bin/python"
-- }

-- Node {
vim.g.node_host_prog = os.getenv("HOME") .. "/.config/nvm/current/bin/neovim-node-host"
-- }
