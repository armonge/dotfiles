# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a sophisticated Neovim configuration built with Lua, using Lazy.nvim for plugin management. The configuration follows a modular architecture with logical separation under the `armonge` namespace.

### Core Structure

- **Entry Point**: `init.lua` sets leader key and loads modules in specific order
- **Main Namespace**: All configuration lives under `lua/armonge/`
- **Plugin Management**: Lazy.nvim with modular imports and lazy loading
- **Loading Order**: environment → defaults → plugins → filetypes → mappings

### Key Configuration Files

- `lua/armonge/plugins.lua` - Main plugin setup and lazy.nvim bootstrap
- `lua/armonge/lsp.lua` - LSP servers, formatters, and completion setup
- `lua/armonge/defaults.lua` - Core Vim/Neovim settings and options
- `lua/armonge/mappings.lua` - All keybindings organized with which-key
- `lua/armonge/theme.lua` - UI theme and visual customizations

### Plugin Architecture

The configuration uses a modern plugin stack:

- **UI Framework**: Snacks.nvim provides unified UI components (dashboard, picker, etc.)
- **Completion**: Blink.cmp with AI integration (Copilot)
- **LSP Management**: Mason.nvim + nvim-lspconfig + none-ls
- **File Management**: Oil.nvim for directory editing
- **Git Integration**: Gitsigns + Snacks git features
- **AI Tools**: Copilot for completions

## LSP and Language Support

### Comprehensive Language Setup

The LSP configuration supports multiple tools per language:

- **Python**: ruff (format/lint), mypy (types), ty (fast checking)
- **JavaScript/TypeScript**: vtsls (LSP), biome (format/lint)
- **Lua**: lua_ls (LSP), stylua (format)
- **Shell**: bashls (LSP), shellcheck (lint)
- **Specialized**: Beancount, Clojure, Markdown with preview

### LSP Architecture Pattern

Each language typically has:
1. Language server for diagnostics/completion
2. Formatter for code styling
3. Additional linter for enhanced checking

## Development Workflow

### Plugin Management

```bash
# Update plugins (run from Neovim)
:Lazy update

# Check plugin status
:Lazy

# Clean unused plugins
:Lazy clean
```

### Configuration Development

When modifying this config:

1. **Test Changes**: Restart Neovim or use `:source %` for Lua files
2. **Check Lazy Loading**: Use `:Lazy profile` to verify performance
3. **Debug Issues**: Use `:checkhealth` for plugin diagnostics
4. **LSP Debug**: Use `:LspInfo` and `:Mason` for language server issues

### Key Patterns

- **Modular Imports**: Each plugin category has its own file imported by `plugins.lua`
- **Lazy Loading**: Most plugins load on-demand (commands, filetypes, keys)
- **Environment Setup**: `environment.lua` configures Python and Node.js paths
- **Keybinding Groups**: Organized by functionality with which-key integration

## Important Configuration Notes

### AI Integration

This config has AI tooling:
- Copilot integration for inline completions
- Blink.cmp handles AI completion sources

### Performance Considerations

- Plugin lazy loading is carefully configured
- Large plugins (Treesitter, LSP) load conditionally
- Snacks.nvim replaces multiple smaller plugins for efficiency

### Custom Features

- **Oil.nvim**: Edit directories like buffers
- **Beancount Support**: Specialized accounting file handling
- **Environment Detection**: Automatic Python/Node version detection
- **Format on Save**: Automatic code formatting via LSP

## Troubleshooting

### Common Issues

1. **LSP Not Working**: Check `:Mason` for server installation
2. **Slow Startup**: Review `:Lazy profile` for non-lazy plugins
3. **Missing Dependencies**: Run `:checkhealth` for system requirements
4. **Git Issues**: Ensure proper Git configuration for plugin updates

### Health Checks

Always run `:checkhealth` after making significant changes to verify all dependencies and integrations are working correctly.
