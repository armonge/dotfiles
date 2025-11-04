#!/bin/bash
# Lazy-load NVM to improve bash startup time
# NVM loads on first use of node/npm/nvm/npx commands

# Set NVM_DIR if not already set
export NVM_DIR="$HOME/.config/nvm"
export NODE_VERSION_PREFIX=v
export NODE_VERSIONS="${NVM_DIR}/versions/node"

# Flag to track if NVM has been loaded
__nvm_loaded=0

__load_nvm() {
  # Check if nvm function already exists (real one from nvm.sh)
  if ! type -t nvm | grep -q "function" || [ "$(type -t nvm)" = "function" ] && ! declare -f nvm | grep -q "nvm_has"; then
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  fi
}

node() {
  __load_nvm
  command node "$@"
}

npm() {
  __load_nvm
  command npm "$@"
}

npx() {
  __load_nvm
  command npx "$@"
}

vim() {
  __load_nvm
  command vim "$@"
}

nvim() {
  __load_nvm
  command nvim "$@"
}

nvm() {
  __load_nvm
  nvm "$@"
}

export -f node npm npx nvm vim nvim __load_nvm
