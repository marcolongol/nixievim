# Nixievim

> My personal Neovim configuration built with [nixvim](https://github.com/nix-community/nixvim)

A modular, reproducible Neovim setup featuring AI integration, modern completion, and comprehensive language support.

## Quick Start

```bash
# Try instantly (no install required)
nix run "github:marcolongol/nixievim"           # Full configuration
nix run "github:marcolongol/nixievim#base"      # Minimal setup
nix run "github:marcolongol/nixievim#neovide"   # Neovide GUI wrapper
```

## Installation

### As a Package

```nix
# flake.nix
{
  inputs.nixievim.url = "github:marcolongol/nixievim";
}

# Home Manager
home.packages = [ inputs.nixievim.packages.${pkgs.system}.default ];

# NixOS
environment.systemPackages = [ inputs.nixievim.packages.${pkgs.system}.default ];

# With Neovide GUI
home.packages = [ inputs.nixievim.packages.${pkgs.system}.neovide ];
```

### Individual Modules

```nix
# Import specific plugins into your nixvim config
programs.nixvim = {
  enable = true;
  imports = [ inputs.nixievim.nixiePlugins.ai ];
};
```

## Configuration Variants

**Base**: Essential plugins (neo-tree, treesitter, git, bufferline)
**Core**: Full setup with AI tools, LSP, telescope, completion, language support
**Neovide**: Core wrapped for the [Neovide](https://neovide.dev) GUI — includes transparency, animations, font config, and a `.desktop` entry for launcher integration

## Features

- **AI Integration**: Claude Code, GitHub Copilot
- **Language Support**: Nix, Python, Lua, Markdown, Web Development
- **Modern UI**: Dashboard, snacks.picker, neo-tree, bufferline
- **Smart Completion**: blink-cmp with multiple sources
- **Git Integration**: Built-in git workflow tools

## Available Modules

**Core**: `common`, `neo-tree`, `snacks`, `treesitter`, `git`, `bufferline`
**Languages**: `lang.nix`, `lang.python`, `lang.lua`, `lang.md`, `lang.webdev`
**Tools**: `ai`, `lsp`, `blink-cmp`, `firenvim`, `ux`, `neovide`

## Requirements

- [Nix](https://nixos.org/download.html) with flakes enabled

## License

MIT License - see [LICENSE](LICENSE) file.

## Acknowledgments

Built with [nixvim](https://github.com/nix-community/nixvim) • Inspired by [nvix](https://github.com/niksingh710/nvix)
