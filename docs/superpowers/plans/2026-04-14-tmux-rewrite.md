# Tmux Rewrite Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the Oh My Tmux-based `tmux.conf.local` (494 lines) with a standalone, hand-written `tmux.conf` that uses `~` as prefix, vim pane navigation, capital-letter directional splits, window-as-tab bindings, and an ANSI-palette theme that tracks Ghostty's light/dark switch.

**Architecture:** Single standalone `tmux.conf` at `tmux/.config/tmux/tmux.conf` replacing the current symlink into the Oh My Tmux submodule. Old `tmux.conf.local` is preserved as `tmux.conf.local.bak` for reference. The `omt/` submodule is left in place (dormant, unreferenced). Theme uses `colourN` ANSI slots (0–15) rather than hex, so it inherits whatever palette Ghostty currently has loaded.

**Tech Stack:** tmux 3.x, GNU Stow, zsh.

**Spec:** [`docs/superpowers/specs/2026-04-14-tmux-rewrite-design.md`](../specs/2026-04-14-tmux-rewrite-design.md)

**Testing notes:** tmux config isn't unit-testable in the traditional sense. Verification is a parse check (`tmux -f <conf> new-session -d \; kill-session` exits 0) plus manual smoke testing of each binding. Each task that writes config ends with a parse check before commit.

---

## Task 1: Back up the old config and remove the symlink

**Files:**
- Rename: `tmux/.config/tmux/tmux.conf.local` → `tmux/.config/tmux/tmux.conf.local.bak`
- Delete: `tmux/.config/tmux/tmux.conf` (symlink into `omt/`)

- [ ] **Step 1: Confirm current state**

Run from repo root (`/Users/protoxpire0/.dotfiles`):
```bash
ls -la tmux/.config/tmux/
```
Expected: you should see `tmux.conf -> omt/.tmux.conf` (a symlink), `tmux.conf.local` (regular file, ~494 lines), and `omt/` (submodule).

- [ ] **Step 2: Rename the existing local override to .bak**

```bash
git mv tmux/.config/tmux/tmux.conf.local tmux/.config/tmux/tmux.conf.local.bak
```

Using `git mv` so the rename is tracked.

- [ ] **Step 3: Remove the tmux.conf symlink**

```bash
git rm tmux/.config/tmux/tmux.conf
```

This removes the symlink from both the working tree and the index. The `omt/` submodule directory is untouched.

- [ ] **Step 4: Verify state**

```bash
ls -la tmux/.config/tmux/
```
Expected: no `tmux.conf` entry, `tmux.conf.local.bak` present, `omt/` still present.

- [ ] **Step 5: Commit the backup step alone**

```bash
git commit -m "tmux: back up old config, remove omt symlink

Prep for standalone tmux.conf rewrite. Oh My Tmux submodule
stays in tree but is no longer referenced."
```

Committing this separately so the next commit (the new config) has a clean diff.

---

## Task 2: Write the new standalone tmux.conf

**Files:**
- Create: `tmux/.config/tmux/tmux.conf`

- [ ] **Step 1: Create the new tmux.conf with the full config**

Write this exact content to `tmux/.config/tmux/tmux.conf`:

```tmux
# ~/.config/tmux/tmux.conf
# Standalone config. See docs/superpowers/specs/2026-04-14-tmux-rewrite-design.md.

# -- prefix --------------------------------------------------------------------

unbind C-b
set -g prefix "~"
bind "~" last-window           # double-tap prefix -> last window

# -- options -------------------------------------------------------------------

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

# -- pane navigation (vim) -----------------------------------------------------

bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# -- pane splitting (capital = direction of new pane) --------------------------

unbind '"'
unbind %
bind H split-window -hb -c '#{pane_current_path}'   # new pane on the left
bind J split-window -v  -c '#{pane_current_path}'   # new pane below
bind K split-window -vb -c '#{pane_current_path}'   # new pane above
bind L split-window -h  -c '#{pane_current_path}'   # new pane on the right

# -- windows (tabs) ------------------------------------------------------------

bind t new-window -c '#{pane_current_path}'
bind 1 select-window -t :1
bind 2 select-window -t :2
bind 3 select-window -t :3
bind 4 select-window -t :4
bind 5 select-window -t :5
bind 6 select-window -t :6
bind 7 select-window -t :7
bind 8 select-window -t :8
bind 9 select-window -t :9
bind s choose-tree -Z

# -- reload --------------------------------------------------------------------

bind r source-file ~/.config/tmux/tmux.conf \; display "reloaded"

# -- theme (ANSI palette; tracks Ghostty light/dark) ---------------------------
# Slots: 0=dim-bg  3=yellow/warn  4=blue/accent  7=fg  8=subtle

set -g status-style "bg=colour0,fg=colour8"
set -g status-left  "#[fg=colour4,bold] #S #[default] "
set -g status-right "#{?client_prefix,#[fg=colour3]⌨ ,}#[fg=colour8]%H:%M #[fg=colour4]#h "
set -g status-left-length 30
set -g status-right-length 60

setw -g window-status-format         " #I #W "
setw -g window-status-current-format "#[fg=colour7,bg=colour4,bold] #I #W #[default]"
setw -g window-status-activity-style "fg=colour3"

set -g pane-border-style        "fg=colour8"
set -g pane-active-border-style "fg=colour4"

set -g message-style         "fg=colour0,bg=colour3,bold"
set -g message-command-style "fg=colour3,bg=colour0,bold"
setw -g mode-style           "fg=colour0,bg=colour3,bold"
```

- [ ] **Step 2: Parse-test the config**

Run from repo root:
```bash
tmux -f tmux/.config/tmux/tmux.conf -L spec-test new-session -d \; kill-server
```
Expected: exit code 0, no error output. Any parse error will print here and set a non-zero exit.

If it fails, read the error, fix the offending line in the file, re-run until it passes. Do not proceed until this is clean.

- [ ] **Step 3: Stage and commit**

```bash
git add tmux/.config/tmux/tmux.conf
git commit -m "tmux: add standalone tmux.conf

Replaces the Oh My Tmux-based layered config. Prefix is ~,
vim-style pane nav (hjkl), capital-letter directional splits,
t for new window, 1-9 for jump, s for tree, ~~ for last-window.
Theme uses ANSI colour slots so it tracks Ghostty's light/dark
auto-switch."
```

---

## Task 3: Restow the tmux package and smoke-test in a live tmux

**Files:** None modified. This is a verification task.

- [ ] **Step 1: Re-stow tmux**

From repo root:
```bash
stow -R tmux
```
Expected: no output (success). If stow complains about conflicts, investigate — it likely means `~/.config/tmux/tmux.conf` exists as a real file and needs removing.

- [ ] **Step 2: Verify the symlink points to the new file**

```bash
ls -la ~/.config/tmux/tmux.conf
```
Expected: symlink pointing into `~/.dotfiles/tmux/.config/tmux/tmux.conf` (the new regular file, not into `omt/`).

- [ ] **Step 3: Kill any running tmux server and start fresh**

```bash
tmux kill-server 2>/dev/null || true
tmux new-session -d -s smoke
tmux list-sessions
```
Expected: session `smoke` listed.

- [ ] **Step 4: Manually verify each binding**

Attach: `tmux attach -t smoke`

Walk through every binding and confirm behavior:

| Test | Expected |
|---|---|
| `~ ?` | list-keys overlay appears (stock binding still works) |
| `~ t` | new window created, current path preserved |
| `~ 1`, `~ 2` | switches between windows 1 and 2 |
| `~ ~` | flips to the previously active window |
| `~ H` / `~ J` / `~ K` / `~ L` | splits pane with new pane on left/down/up/right |
| `~ h` / `~ j` / `~ k` / `~ l` | moves pane focus in that direction |
| `~ s` | tree picker appears, zoomed |
| `~ r` | status line shows "reloaded" |
| Active pane border | rendered with the terminal's blue (colour4) |
| Status bar bottom | session name left, clock + host right |

Any failure → stop, fix the config, re-stow, restart tmux server, retest.

- [ ] **Step 5: Toggle Ghostty light/dark and confirm the theme follows**

Switch macOS appearance (or toggle Ghostty's theme manually) and observe the running tmux status bar. Colors should flip automatically without reloading.

If colors don't change, the terminal isn't propagating palette changes to running children. Not a config bug; note it and move on.

- [ ] **Step 6: Detach and clean up the smoke session**

```bash
tmux kill-session -t smoke
```

No commit — this task produced no file changes.

---

## Task 4: Update CLAUDE.md to describe the new tmux setup

**Files:**
- Modify: `CLAUDE.md` (the tmux package description and the "Key Details" tmux bullet)

- [ ] **Step 1: Read the current CLAUDE.md tmux sections**

```bash
grep -n -A3 -i "tmux" CLAUDE.md
```

Note the two places that need updating:
1. The `**tmux**` bullet under `## Packages` (mentions Oh My Tmux override).
2. The `Tmux uses Oh My Tmux...` bullet under `## Key Details`.

- [ ] **Step 2: Replace the Packages-section tmux bullet**

Find the line that starts with `- **tmux** — Oh My Tmux!` and replace the bullet with:

```markdown
- **tmux** — Standalone `tmux.conf` (`~/.config/tmux/`). Prefix is `~` (tilde), vim-style pane nav (`hjkl`), capital-letter directional splits (`HJKL`), `t` for new window, `1`–`9` to jump, `s` for tree picker, `~ ~` for last-window. Theme uses ANSI palette slots (`colour0`..`colour15`) so it tracks Ghostty's light/dark auto-switch. Previous Oh My Tmux-based override is retained as `tmux.conf.local.bak`; the `omt/` submodule is still in the tree but unreferenced.
```

- [ ] **Step 3: Remove or rewrite the Key Details tmux bullet**

Find the bullet that starts with `**Tmux** uses [Oh My Tmux]`. Since Oh My Tmux is no longer the base, remove this bullet entirely (the package description above now covers the essentials).

- [ ] **Step 4: Verify the diff reads cleanly**

```bash
git diff CLAUDE.md
```
Expected: one bullet replaced, one bullet removed, no other changes.

- [ ] **Step 5: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: update CLAUDE.md for standalone tmux config"
```

---

## Self-Review Notes

- **Spec coverage:** prefix (Task 2), double-tap last-window (Task 2), vim pane nav (Task 2), capital directional splits (Task 2), `t` new window (Task 2), `1`–`9` window jump (Task 2), `s` tree picker (Task 2), ANSI-palette theme (Task 2), `tmux.conf.local` → `.bak` (Task 1), symlink removal (Task 1), omt submodule left dormant (no task — that's the null action), CLAUDE.md update (Task 4). ✓
- **No placeholders** — every step has concrete commands or full code. ✓
- **Type consistency** — bindings referenced in verification (Task 3) match exactly what's in Task 2. ✓
