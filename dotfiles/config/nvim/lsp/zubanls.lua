return {
	name = "ZubanLS",
	cmd = { "uvx", "--from=zuban", "zubanls" },
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
	filetypes = { "python" },
}
