# Dependencies

## Required (all profiles)
- `zsh`, `stow`, `git`

## Profile: minimal
Just the required set above.

## Profile: server
Required + these:
- `neovim`, `tmux`, `oh-my-posh`, `eza`, `fzf`, `zoxide`, `fd` (for `tre`)

## Profile: mac
Everything in `server`, plus macOS-only:
- `ghostty`, `skhd`
- Homebrew (for installing the above)

## Language ecosystems (install à la carte, any OS)
Ecosystem integrations are gated by `command -v` — install only what you use.

### JavaScript
- `bun` — runtime
- `pnpm` — package manager

### Python
- `uv` — package/runtime manager (enables `uvrun` helper)

### Rust
- `rustup` / cargo — installs `$HOME/.local/bin/env` which `.zprofile` sources

### Go
- `go` — placeholder; add GOPATH block to `.zprofile` and ecosystem block to `04-ecosystems.zsh` when needed

## Auto-installed at first shell load
- `zinit` — bootstraps itself from `02-plugins.zsh`
