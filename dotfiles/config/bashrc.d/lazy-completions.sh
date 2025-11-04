#!/bin/bash
# Lazy-load completion scripts to improve bash startup time
# Completions load on first tab-press for each command

# Track which completions have been loaded
declare -A __completion_loaded

# Generic lazy completion loader
__lazy_load_completion() {
  local cmd="$1"
  local load_function="$2"

  # Only load once
  if [ "${__completion_loaded[$cmd]}" = "1" ]; then
    return 0
  fi

  # Call the loading function
  eval "$load_function"

  # Mark as loaded
  __completion_loaded[$cmd]=1

  # Return success to trigger completion retry
  return 124 # Special return code to tell bash to retry completion
}

# kubectl completion
__load_kubectl_completion() {
  if command -v kubectl &>/dev/null; then
    # shellcheck disable=SC1090
    source <(kubectl completion bash)
    # Also set up alias completion if kubectl alias exists
    if alias k &>/dev/null 2>&1; then
      complete -o default -F __start_kubectl k
    fi
  fi
}

_kubectl_lazy() {
  __lazy_load_completion kubectl __load_kubectl_completion
}

# helm completion
__load_helm_completion() {
  if command -v helm &>/dev/null; then
    # shellcheck disable=SC1090
    source <(helm completion bash)
  fi
}

_helm_lazy() {
  __lazy_load_completion helm __load_helm_completion
}

# k9s completion
__load_k9s_completion() {
  if command -v k9s &>/dev/null; then
    eval "$(k9s completion bash)"
  fi
}

_k9s_lazy() {
  __lazy_load_completion k9s __load_k9s_completion
}

# npm completion
__load_npm_completion() {
  if command -v npm &>/dev/null; then
    # shellcheck disable=SC1090
    source <(npm completion)
  fi
}

_npm_lazy() {
  __lazy_load_completion npm __load_npm_completion
}

# aws completion
__load_aws_completion() {
  local aws_completer
  aws_completer=$(command -v aws_completer 2>/dev/null)
  if [ "$aws_completer" != "" ]; then
    complete -C "$aws_completer" aws
  fi
}

_aws_lazy() {
  __lazy_load_completion aws __load_aws_completion
}

# Set up lazy completion for each command
if command -v kubectl &>/dev/null; then
  complete -F _kubectl_lazy kubectl
  # Also for 'k' alias if it exists
  if alias k &>/dev/null 2>&1; then
    complete -F _kubectl_lazy k
  fi
fi

if command -v helm &>/dev/null; then
  complete -F _helm_lazy helm
fi

if command -v k9s &>/dev/null; then
  complete -F _k9s_lazy k9s
fi

if command -v npm &>/dev/null; then
  complete -F _npm_lazy npm
fi

if command -v aws &>/dev/null; then
  complete -F _aws_lazy aws
fi
