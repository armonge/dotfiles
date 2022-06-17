#!/bin/bash
if command -v flatpak 1>/dev/null 2>&1; then
	flatpak run --file-forwarding re.sonny.Commit @@ $@
elif command -v nvim 1>/dev/null 2>&1; then
	nvim $@
elif command -v vim 1>/dev/null 2>&1; then
	vim $@
fi
