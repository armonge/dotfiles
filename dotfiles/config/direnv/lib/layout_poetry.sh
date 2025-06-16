#!/bin/bash -x
layout_poetry() {
  PYPROJECT_TOML="${PYPROJECT_TOML:-pyproject.toml}"
  if [[ ! -f $PYPROJECT_TOML ]]; then
    log_status "No pyproject.toml found. Executing \`poetry init\` to create a \`$PYPROJECT_TOML\` first."
    uvx poetry init
  fi

  if [[ -d ".venv" ]]; then
    VIRTUAL_ENV="$PWD/.venv"
  else
    VIRTUAL_ENV=$(
      uvx poetry env info --path 2>/dev/null
      true
    )
  fi

  if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
    log_status 'No virtual environment exists. Executing `poetry install` to create one.'
    uvx poetry env use "$(uv python find "$1")"
    uvx poetry install
    VIRTUAL_ENV=$(uvx poetry env info --path)
  fi

  PATH_add "$VIRTUAL_ENV/bin"
  export POETRY_ACTIVE=1
  export VIRTUAL_ENV
}
