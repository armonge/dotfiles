#!/bin/bash
# set -x
set -euo pipefail

BUSNAME="org.gnome.Mutter.DisplayConfig"
OBJECT_PATH="/org/gnome/Mutter/DisplayConfig"
METHOD="ApplyMonitorsConfig"

function get_serial() {
	serial="$(gdbus call --session --dest org.gnome.Mutter.DisplayConfig \
		--object-path /org/gnome/Mutter/DisplayConfig \
		--method org.gnome.Mutter.DisplayConfig.GetResources | awk '{print $2}' | tr -d ',')"
	echo $serial
}

SERIAL=$(get_serial)

gdbus call --session --dest "$BUSNAME" --object-path "$OBJECT_PATH" --method $BUSNAME.$METHOD $SERIAL 1 " [ (1920, 0, 1.0, 0, false, [('HDMI-1', '1920x1080@60', [])]), (0, 0, 1.0, 0, true, [('eDP-1', '1920x1080@59.962844848632812', [])]) ] " "{'layout-mode': <'uint32 2'>, 'legacy-ui-scaling-factor': <'1'>}"

gdbus call --session --dest "$BUSNAME" --object-path "$OBJECT_PATH" --method $BUSNAME.$METHOD $SERIAL 1 "[(0, 0, 1, 0, true, [('HDMI-1', '1920x1080@60', [] ), ('eDP-1', '1920x1080@59.962844848632812', [] )] )]" "{'layout-mode': <'uint32 2'>, 'legacy-ui-scaling-factor': <'1'>}"
