# dotfiles

Personal dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Usage

```bash
git clone <repo> ~/.dotfiles
cd ~/.dotfiles
./install.sh <profile>
```

### Profiles

| Profile   | Packages                                     |
|-----------|----------------------------------------------|
| `mac`     | zsh git nvim tmux ghostty oh-my-posh skhd    |
| `server`  | zsh git nvim tmux oh-my-posh                 |
| `minimal` | zsh git                                      |

See `DEPENDENCIES.md` for the system packages each profile expects.

## Manual stow

Prefer to pick packages by hand:

```bash
stow zsh git nvim   # or any subset
```

## Migration from pre-existing dotfiles

If `~/.zshrc`, `~/.zprofile`, etc. already exist as real files (not symlinks), `install.sh` auto-backs them up to `*.pre-stow.bak` before stowing. Review/delete those backups once you've confirmed the new config works.

## Per-machine overrides

Drop a `~/.config/zsh/99-local.zsh` for machine-specific aliases/env. It's gitignored.
