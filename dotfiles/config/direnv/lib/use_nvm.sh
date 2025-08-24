#!/bin/bash -x

use_nvm() {
  local node_version=$1

  nvm_sh=~/.nvm/nvm.sh
  if [[ -e $nvm_sh ]]; then
    # shellcheck source=/dev/null
    source "$nvm_sh"
    nvm use "$node_version"
  fi
}
