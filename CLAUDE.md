# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a sophisticated personal dotfiles repository built around **dotdrop** - a powerful dotfiles management system. The repository uses a modular, cross-platform approach to manage development environments across different hosts and operating systems.

### Core Structure

- **Entry Point**: `./dotdrop.sh` - Wrapper script for dotdrop execution with auto-updates
- **Configuration**: `config.yaml` - Central dotdrop configuration defining dotfiles, profiles, and deployment rules  
- **Installation**: `scripts/install-deps.sh` - Comprehensive dependency installation for development environment
- **Dotfiles**: `dotfiles/` - All managed configuration files organized by category
- **Dotdrop**: `dotdrop/` - Git submodule pointing to https://github.com/deadc0de6/dotdrop

### Key Configuration Files

- `config.yaml` - Dotdrop configuration with profile `armonge-laptop` managing 20+ dotfiles
- `dotdrop.sh` - Main execution wrapper with profile pre-configuration
- `scripts/install-deps.sh` - Cross-platform dependency installer (macOS/Fedora)
- `dotfiles/config/nvim/` - Sophisticated Neovim configuration (see its own CLAUDE.md)

## Development Commands

### Dotdrop Operations

```bash
# Deploy all dotfiles to current system
./dotdrop.sh install

# Compare local files with stored dotfiles
./dotdrop.sh compare

# Import new dotfiles into repository
./dotdrop.sh import <file_path>

# Update stored dotfiles with local changes
./dotdrop.sh update <file_path>

# List available dotfiles and profiles
./dotdrop.sh files
./dotdrop.sh profiles
```

### System Setup

```bash
# Install all development dependencies
./scripts/install-deps.sh

# Install specific components only
./scripts/install-deps.sh rust python nodejs

# Preview what would be installed (dry run)
./scripts/install-deps.sh --dry-run

# Force reinstall of components
./scripts/install-deps.sh --force

# Install with verbose logging
./scripts/install-deps.sh --verbose

# List available components
./scripts/install-deps.sh --list
```

## Architecture and Design Patterns

### Dotdrop Configuration

The repository uses a **single profile architecture**:
- Profile: `armonge-laptop` (configured in dotdrop.sh)
- **Absolute symlinks** for real-time config updates
- **Modular dotfiles** organized by function (shell, git, nvim, etc.)
- **Template support** for host-specific configurations

### Development Environment Stack

**Package Management**:
- **Python**: uv (modern pip replacement)
- **Node.js**: nvm (version management)
- **Rust**: rustup (official toolchain)
- **System**: Homebrew (macOS), dnf (Fedora)

**Core Tools**:
- **Shell**: Bash with Starship prompt
- **Editor**: Neovim with LSP and AI integration
- **Terminal**: WezTerm
- **CLI**: bat, fzf, ripgrep, eza, fd, delta

### Cross-Platform Support

**macOS Support**:
- Homebrew package management
- Native app installations (WezTerm, fonts)
- Platform-specific configurations

**Linux Support** (Fedora):
- dnf package management  
- Build essentials for compilation
- Platform-specific tool alternatives

## Development Workflow

### Adding New Dotfiles

1. **Place file** in desired location
2. **Import**: `./dotdrop.sh import ~/.newconfig`
3. **Verify**: Check `config.yaml` for new entry
4. **Test**: `./dotdrop.sh compare` to verify

### Updating Existing Dotfiles

1. **Edit directly** (files are symlinked)
2. **Update repository**: `./dotdrop.sh update <dotfile>`
3. **Verify changes**: `./dotdrop.sh compare`

### Setting Up New Host

1. **Clone repository**: `git clone <repo> dotfiles`
2. **Install dependencies**: `./scripts/install-deps.sh`
3. **Deploy dotfiles**: `./dotdrop.sh install`
4. **Verify setup**: `./dotdrop.sh compare`

## Important Notes

### Symlink Architecture

- Uses **absolute symlinks** for immediate config updates
- Changes to dotfiles are reflected instantly
- No need to "sync" changes during development

### Component Installation

The install script supports **granular component selection**:
- `all` - Complete development environment
- `packages` - OS-specific package installation
- `rust` - Rust toolchain and cargo tools
- `python` - Python with uv package manager
- `nodejs` - Node.js with nvm
- `fonts` - JetBrains Mono Nerd Font
- `starship` - Modern shell prompt

### Neovim Integration

The Neovim configuration is highly sophisticated with its own architecture:
- **LSP support** for 10+ languages
- **AI integration** with Copilot
- **Modern plugin stack** with Lazy.nvim
- **Performance optimized** with lazy loading

Refer to `dotfiles/config/nvim/CLAUDE.md` for detailed Neovim guidance.