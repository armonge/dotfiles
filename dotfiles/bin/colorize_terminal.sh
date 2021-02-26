#!/bin/sh
#
# from https://gist.github.com/1397104
#
# Shell script that configures gnome-terminal and guake to use solarized theme
# colors. Works on Ubuntu 11.10, 12.04, 14.04, at least.
#
# Solarized theme: http://ethanschoonover.com/solarized
#
# Adapted from these sources:
# https://gist.github.com/1280177
# http://xorcode.com/guides/solarized-vim-eclipse-ubuntu/
# https://github.com/coolwanglu/guake-colors-solarized
# https://github.com/Anthony25/gnome-terminal-colors-solarized

case "$1" in
"solarized dark")
	PALETTE="#070736364242:#D3D301010202:#858599990000:#B5B589890000:#26268B8BD2D2:#D3D336368282:#2A2AA1A19898:#EEEEE8E8D5D5:#58586E6E7575:#CBCB4B4B1616:#58586E6E7575:#65657B7B8383:#838394949696:#6C6C7171C4C4:#9393A1A1A1A1:#FDFDF6F6E3E3"
	BG_COLOR="#00002B2B3636"
	FG_COLOR="#65657B7B8383"
	;;
"solarized dark higher contrast")
	PALETTE="#070736364242:#D3D301010202:#858599990000:#B5B589890000:#26268B8BD2D2:#D3D336368282:#2A2AA1A19898:#EEEEE8E8D5D5:#58586E6E7575:#CBCB4B4B1616:#58586E6E7575:#65657B7B8383:#838394949696:#6C6C7171C4C4:#9393A1A1A1A1:#FDFDF6F6E3E3"
	BG_COLOR="#001e27"
	FG_COLOR="#9cc2c3"
	;;
"solarized light")
	PALETTE="#000028283131:#d1d11c1c2424:#6c6cbebe6c6c:#a5a577770606:#21217676c7c7:#c6c61c1c6f6f:#252592928686:#eaeae3e3cbcb:#000064648888:#f5f516163b3b:#5151efef8484:#b2b27e7e2828:#17178e8ec8c8:#e2e24d4d8e8e:#0000b3b39e9e:#fcfcf4f4dcdc"
	BG_COLOR="#FDFDF6F6E3E3"
	FG_COLOR="#838394949696"
	;;
"ura")
	PALETTE="#000000000000:#c2c21b1b6f6f:#6f6fc2c21b1b:#c2c26f6f1b1b:#1b1b6f6fc2c2:#6f6f1b1bc2c2:#1b1bc2c26f6f:#808080808080:#808080808080:#eeee8484b9b9:#b9b9eeee8484:#eeeeb9b98484:#8484b9b9eeee:#b9b98484eeee:#8484eeeeb9b9:#e5e5e5e5e5e5"
	BG_COLOR="#FEFEFFFFEEEE"
	FG_COLOR="#232347476A6A"
	;;
*)
	echo "Usage: colorize_terminal.sh [solarized light | solarized dark | solarized dark higher contrast | ura]"
	exit
	;;
esac

# This works for Ubuntu 14.04
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_background" --type bool false
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_colors" --type bool false
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/palette" --type string "$PALETTE"
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/background_color" --type string "$BG_COLOR"
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/foreground_color" --type string "$FG_COLOR"

# But in 16.04 terminal uses Gnome3 settings:

# Get default profile ID
GT_PROFILE_ID=$(gsettings get org.gnome.Terminal.ProfilesList default | tail -c +2 | head -c -2)
SCHEMA="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${GT_PROFILE_ID}/"

# set array-format palette for gsettings
PALETTE_ARRAY="["
OIFS=$IFS
IFS=":"
for color in $PALETTE; do
	PALETTE_ARRAY="${PALETTE_ARRAY}'${color}', "
done
PALETTE_ARRAY="${PALETTE_ARRAY%??}]"
IFS=$OIFS

gsettings set "$SCHEMA" background-color "$BG_COLOR"
gsettings set "$SCHEMA" foreground-color "$FG_COLOR"
gsettings set "$SCHEMA" palette "$PALETTE_ARRAY"
