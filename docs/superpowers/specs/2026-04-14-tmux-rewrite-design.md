# Tmux Rewrite: Standalone Config with Tilde Prefix

**Date:** 2026-04-14
**Scope:** Replace the Oh My Tmux-based setup in the `tmux` stow package with a standalone, hand-written `tmux.conf`. New prefix, vim-style pane navigation, capital-letter directional splits, window-as-tab mental model, and a theme that follows the terminal's ANSI palette so it tracks Ghostty's light/dark auto-switch.

## Motivation

Current config is `tmux.conf.local` (494 lines) layered over the Oh My Tmux submodule. Most of it is Oh My Tmux framework configuration the user doesn't customize. The user wants a clean, small, hand-written config with specific bindings that are easier to reason about without the Oh My Tmux indirection.

## File Changes

All paths relative to `/Users/protoxpire0/.dotfiles/tmux/.config/tmux/`.

- **Back up:** `tmux.conf.local` → `tmux.conf.local.bak` (retained in repo as a reference; not sourced)
- **Remove:** `tmux.conf` symlink (currently points to `omt/.tmux.conf`)
- **Create:** `tmux.conf` as a new regular file (the standalone config)
- **Leave in place:** `omt/` submodule (dormant, still tracked in `.gitmodules`, not referenced by anything)

`CLAUDE.md` will need a small update to the **tmux** package description to reflect the new structure.

## Bindings

Prefix is `~` (Shift+backtick). Set via `set -g prefix "~"`, with `C-b` unbound.

### Prefix itself

| Key | Action |
|---|---|
| `~ ~` | `last-window` — double-tap prefix to flip between two most recent windows |

### Pane navigation (lowercase hjkl)

| Key | Action |
|---|---|
| `~ h` | `select-pane -L` |
| `~ j` | `select-pane -D` |
| `~ k` | `select-pane -U` |
| `~ l` | `select-pane -R` |

### Pane splitting (uppercase HJKL — direction of new pane)

| Key | Action |
|---|---|
| `~ H` | `split-window -hb -c '#{pane_current_path}'` (new pane on the left) |
| `~ J` | `split-window -v  -c '#{pane_current_path}'` (new pane below) |
| `~ K` | `split-window -vb -c '#{pane_current_path}'` (new pane above) |
| `~ L` | `split-window -h  -c '#{pane_current_path}'` (new pane on the right) |

### Windows (treated like tabs)

| Key | Action |
|---|---|
| `~ t` | `new-window -c '#{pane_current_path}'` |
| `~ 1`…`~ 9` | `select-window -t :N` (explicit bindings, matching `base-index 1`) |
| `~ s` | `choose-tree -Z` (zoomed tree picker across sessions/windows/panes) |
| `~ r` | `source-file ~/.config/tmux/tmux.conf \; display "reloaded"` |

### Explicit unbinds

To avoid surprise from stock defaults conflicting with the above:

- `unbind C-b` (old prefix)
- `unbind '"'`, `unbind %` (default split bindings — replaced by HJKL)

Other stock bindings (`?` for help, `d` detach, `[` copy-mode, `z` zoom, `x` kill-pane, etc.) are kept as tmux defaults.

## Options

```tmux
set -g prefix "~"
unbind C-b
bind "~" last-window

set -g mouse on
set -g history-limit 10000
set -g status-position bottom
set -g escape-time 10
set -g mode-keys vi

set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",xterm-256color:Tc,*:Tc"

set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on
```

`renumber-windows on` keeps window numbers contiguous after closing a window, so `~ 1…9` stays meaningful.

## Theme: ANSI-palette-driven (follows Ghostty)

**Principle:** use `colourN` (ANSI slots 0–15), never hex. Ghostty is configured with `theme = light:modus-operandi-high-contrast, dark:modus-vivendi-low-contrast`, so the palette shifts with macOS appearance. Tmux inheriting ANSI slots means the status bar flips light/dark automatically with no reload.

Semantic mapping used throughout:

| Slot | Role |
|---|---|
| `colour0` | dim background step (status bar bg) |
| `colour8` | subtle / inactive text and borders |
| `colour4` | primary accent (active window, active border) |
| `colour3` | warning accent (prefix indicator) |
| `colour7` | default foreground (contrast on accent) |

### Status bar

```tmux
set -g status-style "bg=colour0,fg=colour8"
set -g status-left  "#[fg=colour4,bold] #S #[default] "
set -g status-right "#{?client_prefix,#[fg=colour3]⌨ ,}#[fg=colour8]%H:%M #[fg=colour4]#h "
set -g status-left-length 30
set -g status-right-length 60

setw -g window-status-format         " #I #W "
setw -g window-status-current-format "#[fg=colour7,bg=colour4,bold] #I #W #[default]"
setw -g window-status-activity-style "fg=colour3"
```

### Pane borders

```tmux
set -g pane-border-style        "fg=colour8"
set -g pane-active-border-style "fg=colour4"
```

### Message line and mode (copy-mode selection, command prompt)

```tmux
set -g message-style         "fg=colour0,bg=colour3,bold"
set -g message-command-style "fg=colour3,bg=colour0,bold"
setw -g mode-style           "fg=colour0,bg=colour3,bold"
```

### What's deliberately dropped from the old config

- Battery bar, pairing indicator, SSH/root/username flair — not used
- Powerline half-circle separators (`\uE0B4`/`\uE0B6`) — avoids the nerd-font dependency; plain rectangular blocks work in any font
- The `prefix Z` "source zshrc in all panes" helper — niche; can be re-added later if missed

## Install Procedure

Not part of the spec content, but for the implementer's reference — the plan will cover:

1. `cd tmux/.config/tmux && mv tmux.conf.local tmux.conf.local.bak`
2. `rm tmux.conf` (the symlink)
3. Write the new `tmux.conf` as specified above
4. Update `CLAUDE.md` tmux package description
5. Verify: `tmux -f tmux/.config/tmux/tmux.conf new-session -d -s spec-test \; kill-session -t spec-test` should exit 0 (parse check)
6. Restart the user's tmux server (`tmux kill-server` or detach all + restart) to pick up the new config

## Out of Scope

- Removing or deinitializing the `omt/` submodule (user chose option A in brainstorming — leave dormant)
- Tmux plugin manager (tpm) integration — current config didn't use it actively either
- Cross-platform differences — same config works on macOS and Linux; no OS splits needed
- `tmux.conf.local.bak` will not be symlinked into `$HOME`; it's repo-only reference
