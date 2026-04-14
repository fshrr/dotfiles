# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a cross-platform (macOS + Linux) dotfiles repository managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory is a stow package that mirrors the target structure under `$HOME`.

## Install script

`./install.sh <profile>` is a profile-aware stow runner. Profiles:
- `mac` — zsh git nvim tmux ghostty oh-my-posh skhd
- `server` — zsh git nvim tmux oh-my-posh
- `minimal` — zsh git

See `DEPENDENCIES.md` for system tools each profile expects.

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
- **tmux** — Standalone `tmux.conf` (`~/.config/tmux/`). Prefix is `~` (tilde), vim-style pane nav (`hjkl`), capital-letter directional splits (`HJKL`), `t` for new window, `1`–`9` to jump, `s` for tree picker, `~ ~` for last-window. Move-pane bindings: `m <1-9>` joins the current pane side-by-side into that window, `m 0` breaks it into a new window at the end, `M` breaks it into a new window right after current, `w` swaps the window layout between side-by-side and stacked. Theme uses ANSI palette slots (`colour0`..`colour15`) so it tracks Ghostty's light/dark auto-switch. Previous Oh My Tmux-based override is retained as `tmux.conf.local.bak`; the `omt/` submodule is still in the tree but unreferenced.
- **zsh** — Modular zsh config. `~/.zshrc` is a thin glob loader that sources numeric-prefixed modules under `~/.config/zsh/` (`01-shell.zsh`, `02-plugins.zsh`, `03-aliases.zsh`, `04-ecosystems.zsh`). Env/PATH lives in `~/.zprofile`. OS splits use `case $OSTYPE`; language ecosystems (bun, pnpm, uv, cargo) are `command -v`-guarded and cross-platform. Per-machine overrides go in a gitignored `~/.config/zsh/99-local.zsh`.

## Key Details

- **Neovim** config is a single `init.lua` derived from kickstart.nvim — all plugin specs and config live in that one file.
- **Zsh** uses [Zinit](https://github.com/zdharma-continuum/zinit) for plugin management (syntax highlighting, completions, autosuggestions, OMZ snippets).
- **Shell prompt** is Oh My Posh with the `zen.toml` theme.
- **Ghostty** uses a light/dark auto-switching theme configuration.
