#!/bin/bash -x

layout_pdm() {
  PYPROJECT_TOML="${PYPROJECT_TOML:-pyproject.toml}"
  if [ ! -f "$PYPROJECT_TOML" ]; then
    log_status "No pyproject.toml found. Executing \`pmd init\` to create a \`$PYPROJECT_TOML\` first."
    pdm init --non-interactive --python "$(python3 --version 2>/dev/null | cut -d' ' -f2 | cut -d. -f1-2)"
  fi

  VIRTUAL_ENV=$(pdm venv list | grep "^\*" | awk -F" " '{print $3}')

  if [ -z "$VIRTUAL_ENV" ] || [ ! -d "$VIRTUAL_ENV" ]; then
    log_status "No virtual environment exists. Executing \`pdm info\` to create one."
    pdm info
    VIRTUAL_ENV=$(pdm venv list | grep "^\*" | awk -F" " '{print $3}')
  fi

  PATH_add "$VIRTUAL_ENV/bin"
  export PDM_ACTIVE=1
  export VIRTUAL_ENV
}
