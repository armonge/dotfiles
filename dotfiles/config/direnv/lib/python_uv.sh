#!/bin/bash -x
layout_python_uv() {
  local python
  python=$(uv python find)
  [[ $# -gt 0 ]] && shift
  unset PYTHONHOME
  python_version=$("$python" -V | cut -f 2 | cut -d . -f 1-2)
  local python_version="$python_version"

  if [[ -z $python_version ]]; then
    log_error "Could not find python's version"
    return 1
  fi

  if [[ -n "${VIRTUAL_ENV:-}" ]]; then
    local REPLY
    realpath.absolute "$VIRTUAL_ENV"
    VIRTUAL_ENV=$REPLY
  else
    VIRTUAL_ENV=$(direnv_layout_dir)/python-$python_version
  fi
  if [[ ! -d $VIRTUAL_ENV ]]; then
    uv venv -p "$python" "$@" "$VIRTUAL_ENV"
  fi
  export VIRTUAL_ENV
  PATH_add "$VIRTUAL_ENV/bin"
}
