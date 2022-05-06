#!/bin/bash
set -euo pipefail
if command apt &> /dev/null
then
    sudo apt install neovim
fi

if command dnf &> /dev/null
then
    sudo dnf install --assumeyes neovim 
fi
