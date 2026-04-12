# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a macOS dotfiles repository managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory is a stow package that mirrors the target structure under `$HOME`.

## Stow Usage

Each directory (e.g., `ghostty/`, `zsh/`) is a stow package. Files inside follow the path they should have relative to `$HOME`.

```bash
# Symlink a package (e.g., ghostty) into $HOME
stow ghostty

# Remove symlinks for a package
stow -D ghostty

# Re-stow (remove then re-symlink)
stow -R ghostty

# Stow all packages
stow */
```

## Packages

- **ghostty** — Ghostty terminal config and theme files (`~/.config/ghostty/`)
- **git** — Git config and global ignore (`~/.config/git/`)
- **nvim** — Neovim config based on kickstart.nvim (`~/.config/nvim/`)
- **oh-my-posh** — Shell prompt themes (`~/.config/oh-my-posh/`)
- **skhd** — macOS hotkey daemon bindings (`~/.config/skhd/`)
- **tmux** — Oh My Tmux! local overrides with Everforest theme (`~/.config/tmux/`); the `omt` submodule is the upstream Oh My Tmux framework
- **zsh** — Zsh config with Zinit plugin manager (`~/.zshrc`)

## Key Details

- **Tmux** uses [Oh My Tmux](https://github.com/gpakosz/.tmux) as a git submodule at `tmux/.config/tmux/omt`. Only `tmux.conf.local` is edited; the base `tmux.conf` comes from the submodule.
- **Neovim** config is a single `init.lua` derived from kickstart.nvim — all plugin specs and config live in that one file.
- **Zsh** uses [Zinit](https://github.com/zdharma-continuum/zinit) for plugin management (syntax highlighting, completions, autosuggestions, OMZ snippets).
- **Shell prompt** is Oh My Posh with the `zen.toml` theme.
- **Ghostty** uses a light/dark auto-switching theme configuration.
