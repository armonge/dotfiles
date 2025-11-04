#!/usr/bin/env bash
# install-deps.sh - Comprehensive dependency installation script for development environment
#
# This script sets up a complete development environment across different operating systems:
# - macOS (via Homebrew)
# - Fedora (via dnf)
#
# Features:
# - Cross-platform package installation
# - Programming languages: Python (uv), Node.js (nvm), Rust, Lua, Go, Ruby, Java
# - Modern CLI tools: bat, fzf, ripgrep, eza, delta, etc.
# - Text editor: Neovim with Python support
# - Terminal: WezTerm
# - Shell: Starship prompt
# - Fonts: JetBrains Mono Nerd Font
#
# Usage:
#   ./scripts/install-deps.sh [OPTIONS] [COMPONENTS...]
#   ./scripts/install-deps.sh --help for more information

set -euo pipefail

# Check bash version (need 4+ for associative arrays)
if [[ "${BASH_VERSION%%.*}" -lt 4 ]]; then
  echo "Error: This script requires bash version 4 or higher"
  echo "Current version: ${BASH_VERSION}"
  echo ""
  echo "On macOS, you can install a newer bash with: brew install bash"
  echo "Then either:"
  echo "  1. Add /opt/homebrew/bin to the beginning of your PATH"
  echo "  2. Run this script with: /opt/homebrew/bin/bash $0"
  exit 1
fi

# Configuration
LOG_FILE="${LOG_FILE:-/tmp/install-deps-$(date +%Y%m%d-%H%M%S).log}"
VERBOSE="${VERBOSE:-false}"
DRY_RUN="${DRY_RUN:-false}"
FORCE="${FORCE:-false}"

# Version management
NVM_VERSION="${NVM_VERSION:-v0.39.5}"
PYTHON_VERSION="${PYTHON_VERSION:-3.12}"

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Package arrays for macOS
declare -a MACOS_IMAGE_LIBS=(libjpeg libtiff little-cms2 openjpeg webp pkg-config fontconfig cairo libmagic)
declare -a MACOS_CORE_TOOLS=(make wget direnv cmake fzf xz jq miller git git-lfs bat nvim gpg)
declare -a MACOS_DEV_TOOLS=(awscli aws-iam-authenticator the_silver_searcher fd django-completion podman httpie chafa pgformatter jd composer k3d tflint yq)
declare -a MACOS_EXTRA_TOOLS=(git-absorb duckdb difftastic tectonic imagemagick ghostscript pngpaste git-spice tldr)
declare -a MACOS_FUN_TOOLS=(tldr lynx cowsay fortune)

# Package arrays for Fedora
declare -a FEDORA_BUILD_ESSENTIALS=(make gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel patch libX11-devel libXi-devel)
declare -a FEDORA_CLI_TOOLS=(bat lua fzf ripgrep fd-find cmake g++ tldr the_silver_searcher wl-clipboard git git-lfs chafa difftastic lynx cowsay fortune-mod libxcb-devel direnv jq miller neovim podman httpie)
declare -a FEDORA_DEV_TOOLS=(awscli2 pgformatter composer git-absorb duckdb ImageMagick ghostscript)
declare -a FEDORA_LANGUAGES=(golang-bin luarocks texlive-latex lua5.1)

# Logging functions
log() {
  local level="$1"
  shift
  local message="$*"
  local timestamp
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')

  case "$level" in
  ERROR) color="$RED" ;;
  SUCCESS) color="$GREEN" ;;
  WARN) color="$YELLOW" ;;
  INFO) color="$BLUE" ;;
  *) color="$NC" ;;
  esac

  echo -e "${color}[${level}]${NC} ${message}"
  echo "[${timestamp}] [${level}] ${message}" >>"$LOG_FILE"
}

# Progress indication
progress() {
  log "INFO" "▶ $1"
}

# Command execution wrapper
execute() {
  local cmd="$*"

  if [[ "$DRY_RUN" == "true" ]]; then
    log "INFO" "[DRY RUN] Would execute: $cmd"
    return 0
  fi

  if [[ "$VERBOSE" == "true" ]]; then
    log "INFO" "Executing: $cmd"
    eval "$cmd" 2>&1 | tee -a "$LOG_FILE"
  else
    eval "$cmd" >>"$LOG_FILE" 2>&1
  fi

  return "${PIPESTATUS[0]}"
}

# Check if command exists
command_exists() {
  command -v "$1" &>/dev/null
}

# OS Detection
detect_os() {
  local uname_out
  uname_out="$(uname -a)"

  if grep -q "Darwin" <<<"$uname_out"; then
    echo "macos"
  elif grep -q "fedora" <<<"$uname_out"; then
    echo "fedora"
  else
    echo "unknown"
  fi
}

# Check if package is installed (platform-specific)
package_installed() {
  local package="$1"
  local os
  os="$(detect_os)"

  case "$os" in
  macos)
    brew list "$package" &>/dev/null || brew list --cask "$package" &>/dev/null
    ;;
  fedora)
    rpm -q "$package" &>/dev/null
    ;;
  *)
    return 1
    ;;
  esac
}

# Installation functions
install_homebrew() {
  if ! command_exists brew; then
    progress "Installing Homebrew"
    execute '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  else
    log "SUCCESS" "Homebrew already installed"
  fi
}

install_macos_packages() {
  progress "Installing macOS packages"

  # Environment variables for Pillow image library compilation
  export LDFLAGS="-L/opt/homebrew/opt/zlib/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/zlib/include"

  # Install image processing libraries
  progress "Installing image processing libraries"
  for package in "${MACOS_IMAGE_LIBS[@]}"; do
    if ! package_installed "$package" || [[ "$FORCE" == "true" ]]; then
      execute "brew install --quiet $package"
    fi
  done

  # Install core development tools
  progress "Installing core development tools"
  for package in "${MACOS_CORE_TOOLS[@]}"; do
    if ! package_installed "$package" || [[ "$FORCE" == "true" ]]; then
      execute "brew install --quiet $package"
    fi
  done

  # Install additional dev tools
  progress "Installing additional development tools"
  for package in "${MACOS_DEV_TOOLS[@]}"; do
    if ! package_installed "$package" || [[ "$FORCE" == "true" ]]; then
      execute "brew install --quiet $package"
    fi
  done

  # Install WezTerm
  if ! package_installed "wezterm" || [[ "$FORCE" == "true" ]]; then
    progress "Installing WezTerm"
    execute "brew install --cask wezterm"
  fi

  # Install extra tools
  progress "Installing extra tools"
  execute "brew install jstkdng/programs/ueberzugpp" # Terminal image viewer
  execute "brew install neilotoole/sq/sq"            # Swiss-army knife for data

  for package in "${MACOS_EXTRA_TOOLS[@]}"; do
    if ! package_installed "$package" || [[ "$FORCE" == "true" ]]; then
      # Handle git-spice and ghostscript conflict
      if [[ "$package" == "git-spice" ]] && package_installed "ghostscript"; then
        progress "Handling git-spice/ghostscript conflict (git-spice will take precedence)"
        execute "brew unlink ghostscript"
        execute "brew install $package"
        # Keep git-spice's 'gs' binary active
      elif [[ "$package" == "ghostscript" ]] && package_installed "git-spice"; then
        progress "Installing ghostscript without linking (git-spice has precedence)"
        execute "brew install $package"
        execute "brew unlink ghostscript"
      else
        execute "brew install $package"
      fi
    fi
  done

  # Install fun tools
  progress "Installing fun tools"
  for package in "${MACOS_FUN_TOOLS[@]}"; do
    if ! package_installed "$package" || [[ "$FORCE" == "true" ]]; then
      execute "brew install $package"
    fi
  done
}

install_fedora_packages() {
  progress "Installing Fedora packages"

  # Enable WezTerm repository
  execute "sudo dnf --assumeyes copr enable wezfurlong/wezterm-nightly"

  # Install all package groups
  local all_packages=(
    "${FEDORA_BUILD_ESSENTIALS[@]}"
    "${FEDORA_CLI_TOOLS[@]}"
    "${FEDORA_DEV_TOOLS[@]}"
    "${FEDORA_LANGUAGES[@]}"
    "wezterm"
  )

  progress "Installing packages"
  execute "sudo dnf install --assumeyes ${all_packages[*]}"
}

install_rust() {
  progress "Setting up Rust"

  if [[ ! -d "$HOME/.cargo" ]]; then
    execute 'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y'
    source "$HOME/.cargo/env"
  else
    log "INFO" "Rust already installed"
  fi

  execute "rustup update"

  # Install Rust-based CLI tools
  progress "Installing Rust CLI tools"
  local rust_tools=(git-delta tree-sitter-cli jless eza viu)
  for tool in "${rust_tools[@]}"; do
    if ! command_exists "$tool" || [[ "$FORCE" == "true" ]]; then
      execute "cargo install $tool"
    fi
  done
}

install_lua_packages() {
  progress "Installing Lua packages"
  execute "sudo luarocks install --lua-version 5.1 tiktoken_core"
}

install_python() {
  progress "Setting up Python with uv"

  if ! command_exists uv; then
    execute 'curl -LsSf https://astral.sh/uv/install.sh | sh'
    export PATH="$HOME/.cargo/bin:$PATH"
  else
    log "INFO" "uv already installed"
  fi

  execute "uv python install"

  # Set up Python environment for Neovim
  progress "Setting up Python environment for Neovim"
  (
    execute "mkdir -p ~/.config/nvim"
    cd ~/.config/nvim
    if [[ ! -d .venv ]] || [[ "$FORCE" == "true" ]]; then
      execute "uv venv --seed --python $PYTHON_VERSION"
    fi
    execute "source .venv/bin/activate && python -m pip install neovim"
  )

  # Set up Python environment for dotfiles management
  progress "Setting up Python environment for dotfiles"
  (
    cd ~/dotfiles
    if [[ ! -d .venv ]] || [[ "$FORCE" == "true" ]]; then
      execute "uv venv --seed --python $PYTHON_VERSION"
    fi
    execute "source .venv/bin/activate && python -m pip install dotdrop"
  )
}

install_nodejs() {
  progress "Setting up Node.js with NVM"

  # Node.js installation via NVM (Node Version Manager)
  if [[ ! -d "$HOME/.config/nvm" ]] && [[ ! -d "$HOME/.nvm" ]]; then
    execute "unset NVM_DIR"
    execute "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash"
  else
    log "INFO" "NVM already installed"
  fi

  # Load NVM
  NVM_DIR="$([ "${XDG_CONFIG_HOME-}" = "" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  export NVM_DIR
  [ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"
  [ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion"

  # Install multiple Node.js LTS versions
  progress "Installing Node.js LTS versions"
  execute "nvm install lts/gallium lts/erbium lts/fermium"
  execute "nvm install lts/*"
  execute "nvm alias default stable"
  execute "nvm use stable"

  # Install global npm packages
  progress "Installing global npm packages"
  execute "npm install --global --upgrade npm neovim @mermaid-js/mermaid-cli"
}

install_fonts() {
  progress "Installing JetBrains Mono Nerd Font"

  if [[ ! -f "${HOME}/.local/share/fonts/ttf/JetBrainsMonoNLNerdFont-Regular.ttf" ]] || [[ "$FORCE" == "true" ]]; then
    execute "wget -O /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    execute "cd /tmp && unzip -o JetBrainsMono.zip"
    execute "mkdir -p ${HOME}/.local/share/fonts/ttf/"
    execute "mv /tmp/JetBrainsMono*.ttf ${HOME}/.local/share/fonts/ttf/"

    # Update font cache on Linux
    if command_exists fc-cache; then
      execute "fc-cache -f"
    fi
  else
    log "INFO" "JetBrains Mono Nerd Font already installed"
  fi
}

install_starship() {
  progress "Installing Starship prompt"

  if ! command_exists starship || [[ "$FORCE" == "true" ]]; then
    execute "mkdir -p ~/.local/bin"
    execute 'curl -sS https://starship.rs/install.sh | BIN_DIR=~/.local/bin/ sh -s -- -y'
  else
    log "INFO" "Starship already installed"
  fi
}

# Component definitions
declare -A COMPONENTS=(
  [homebrew]="Install Homebrew (macOS only)"
  [packages]="Install OS-specific packages"
  [rust]="Install Rust and tools"
  [lua]="Install Lua packages"
  [python]="Install Python with uv"
  [nodejs]="Install Node.js with NVM"
  [fonts]="Install Nerd Fonts"
  [starship]="Install Starship prompt"
)

# Help function
show_help() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS] [COMPONENTS...]

Comprehensive dependency installation script for development environment.

OPTIONS:
    -h, --help          Show this help message
    -v, --verbose       Enable verbose output
    -d, --dry-run       Show what would be installed without doing it
    -f, --force         Force reinstall even if already installed
    -l, --list          List available components
    --log-file FILE     Set custom log file location

COMPONENTS:
    all                 Install everything (default)
    homebrew            Install Homebrew (macOS only)
    packages            Install OS-specific packages
    rust                Install Rust and tools
    lua                 Install Lua packages
    python              Install Python with uv
    nodejs              Install Node.js with NVM
    fonts               Install Nerd Fonts
    starship            Install Starship prompt

EXAMPLES:
    # Install everything
    $(basename "$0")

    # Install only Rust and Python
    $(basename "$0") rust python

    # Dry run to see what would be installed
    $(basename "$0") --dry-run

    # Force reinstall with verbose output
    $(basename "$0") --force --verbose

ENVIRONMENT VARIABLES:
    PYTHON_VERSION      Python version to install (default: 3.12)
    NVM_VERSION         NVM version to install (default: v0.39.5)
    LOG_FILE            Custom log file location
    VERBOSE             Set to true for verbose output
    DRY_RUN             Set to true for dry run mode
    FORCE               Set to true to force reinstall
EOF
}

# Parse command line arguments
parse_args() {
  local components=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -h | --help)
      show_help
      exit 0
      ;;
    -v | --verbose)
      VERBOSE=true
      shift
      ;;
    -d | --dry-run)
      DRY_RUN=true
      shift
      ;;
    -f | --force)
      FORCE=true
      shift
      ;;
    -l | --list)
      echo "Available components:"
      for comp in "${!COMPONENTS[@]}"; do
        printf "  %-12s - %s\n" "$comp" "${COMPONENTS[$comp]}"
      done | sort
      exit 0
      ;;
    --log-file)
      LOG_FILE="$2"
      shift 2
      ;;
    -*)
      log "ERROR" "Unknown option: $1"
      show_help
      exit 1
      ;;
    *)
      components+=("$1")
      shift
      ;;
    esac
  done

  # If no components specified, install all
  if [[ ${#components[@]} -eq 0 ]] || [[ " ${components[*]} " =~ " all " ]]; then
    SELECTED_COMPONENTS=(homebrew packages rust lua python nodejs fonts starship)
  else
    SELECTED_COMPONENTS=("${components[@]}")
  fi
}

# Main installation function
main() {
  parse_args "$@"

  log "INFO" "Starting installation process"
  log "INFO" "Log file: $LOG_FILE"

  local os
  os="$(detect_os)"
  log "INFO" "Detected OS: $os"

  if [[ "$DRY_RUN" == "true" ]]; then
    log "WARN" "DRY RUN MODE - No changes will be made"
  fi

  # Process selected components
  for component in "${SELECTED_COMPONENTS[@]}"; do
    case "$component" in
    homebrew)
      if [[ "$os" == "macos" ]]; then
        install_homebrew
      else
        log "WARN" "Skipping Homebrew (macOS only)"
      fi
      ;;
    packages)
      case "$os" in
      macos) install_macos_packages ;;
      fedora) install_fedora_packages ;;
      *) log "ERROR" "Unsupported OS for package installation: $os" ;;
      esac
      ;;
    rust) install_rust ;;
    lua) install_lua_packages ;;
    python) install_python ;;
    nodejs) install_nodejs ;;
    fonts) install_fonts ;;
    starship) install_starship ;;
    *)
      log "ERROR" "Unknown component: $component"
      exit 1
      ;;
    esac
  done

  log "SUCCESS" "Installation completed successfully!"
  log "INFO" "Check the log file for details: $LOG_FILE"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
