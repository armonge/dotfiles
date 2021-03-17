#!/bin/bash
set -euo pipefail

GTK_THEME=$(gsettings get org.gnome.desktop.interface gtk-theme)

if [[ $GTK_THEME == *"light"* ]]; then
	THEME="Solarized (light)"
else
	THEME="Solarized (dark)"
fi

delta --color-only \
	--commit-decoration-style="bold yellow box ul" \
	--line-numbers \
	--file-style="bold yellow ul" \
	--file-decoration-style="none" \
	--syntax-theme="$THEME" \
	"${@:1}"
