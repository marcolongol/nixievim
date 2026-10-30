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

```nix
# flake.nix
{
  inputs.nixievim.url = "github:marcolongol/nixievim";
}
```

### Home Manager Module (recommended)

```nix
{ inputs, ... }: {
  imports = [ inputs.nixievim.homeManagerModules.default ];

  programs.nixievim = {
    enable = true;
    defaultEditor = true;   # sets $EDITOR to nvim
    neovide.enable = true;  # Neovide GUI wrapper + .desktop entry
  };
}
```

| Option | Default | Description |
| --- | --- | --- |
| `programs.nixievim.enable` | `false` | Install nixievim |
| `programs.nixievim.package` | `packages.${system}.default` | Nixievim package to install (e.g. `base`) |
| `programs.nixievim.defaultEditor` | `false` | Set `$EDITOR` to `nvim` |
| `programs.nixievim.neovide.enable` | `false` | Install the Neovide wrapper |
| `programs.nixievim.neovide.package` | `packages.${system}.neovide` | Neovide wrapper package to install |

### As a Package

```nix
# Home Manager
home.packages = [ inputs.nixievim.packages.${pkgs.stdenv.hostPlatform.system}.default ];

# NixOS
environment.systemPackages = [ inputs.nixievim.packages.${pkgs.stdenv.hostPlatform.system}.default ];

# With Neovide GUI
home.packages = [ inputs.nixievim.packages.${pkgs.stdenv.hostPlatform.system}.neovide ];
```

Runtime tools (`ripgrep`, `fd`, `gcc`) are bundled on the wrapper's `PATH`, so you don't need to install them separately.

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
