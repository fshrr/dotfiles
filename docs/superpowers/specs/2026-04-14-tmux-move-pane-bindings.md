# Tmux Move-Pane Bindings

**Date:** 2026-04-14
**Scope:** Add bindings to the standalone `tmux.conf` for moving the current pane into another window — either an existing window by number, a new window at the end of the list, or a new window immediately after the current one. Follow-on to the 2026-04-14 tmux rewrite.

## Motivation

Rearranging panes across windows in stock tmux requires typing `:join-pane -t :N` or similar at the command prompt. The user does this often enough that a single-chord binding pays for itself.

## Bindings

Prefix remains `~`.

| Key | Action |
|---|---|
| `~ m <1-9>` | Join current pane into existing window N; focus follows to window N |
| `~ m 0` | Break current pane into a new window at the end of the window list; focus follows |
| `~ M` | Break current pane into a new window immediately after the current one; focus follows |

### Mental model

- Lowercase `m` is a **menu key**: hit it, then a digit. The digit chooses where.
  - `1`–`9` = "put it in that specific window"
  - `0` = "put it in a new window, at the end"
- Uppercase `M` is a **one-shot** for the common "spin this off right next door" case.

### Why not auto-create when `m <N>` targets a missing window

Earlier iteration considered having `~ m 5` create window 5 (shifting existing windows forward) if it didn't exist. Dropped as YAGNI — the user's intent when hitting `m 5` is "it's over there already"; creating-and-shifting is a distinct enough action to warrant its own keys (`m 0` and `M`).

### Target-doesn't-exist behavior

`join-pane -t :N` where window N doesn't exist: tmux prints a brief error in the status line and nothing moves. No attempt to recover or fall back to create-mode.

## Implementation

Uses tmux's key-table mechanism so the digit following `m` isn't ambiguous with the existing `prefix 1`…`prefix 9` window-jump bindings (defined in the same file).

Added to `tmux/.config/tmux/tmux.conf`, in a new section immediately after the existing **windows (tabs)** block:

```tmux
# -- move pane -----------------------------------------------------------------

bind m switch-client -T move-pane
bind -T move-pane 1 join-pane -t :1 \; select-window -t :1
bind -T move-pane 2 join-pane -t :2 \; select-window -t :2
bind -T move-pane 3 join-pane -t :3 \; select-window -t :3
bind -T move-pane 4 join-pane -t :4 \; select-window -t :4
bind -T move-pane 5 join-pane -t :5 \; select-window -t :5
bind -T move-pane 6 join-pane -t :6 \; select-window -t :6
bind -T move-pane 7 join-pane -t :7 \; select-window -t :7
bind -T move-pane 8 join-pane -t :8 \; select-window -t :8
bind -T move-pane 9 join-pane -t :9 \; select-window -t :9
bind -T move-pane 0 break-pane
bind M break-pane -a
```

### Why these tmux commands

- **`join-pane -t :N`** puts the current pane into window N but leaves the client on the source window; chaining `select-window -t :N` makes focus follow the pane. Two commands joined by `\;`.
- **`break-pane`** (no flags) creates a new window at the next available index. Because `renumber-windows on` is already set globally, existing windows stay packed, so the next available index equals "end of the list." This matches the `m 0` semantic.
- **`break-pane -a`** creates a new window immediately after the current one. Matches the `M` semantic.
- Both `break-pane` variants follow the new window by default, so no extra `select-window` is needed.

### Source-window auto-close

If the moved pane was the only pane in the source window, tmux auto-closes the source window after the join/break. With `renumber-windows on`, the remaining windows repack. No special handling needed.

## File Changes

- **Modify:** `tmux/.config/tmux/tmux.conf` — add the move-pane section shown above.
- **Modify:** `CLAUDE.md` — extend the **tmux** package bullet to mention the new `m <N>` / `m 0` / `M` bindings.

## Verification

1. Parse check: `tmux -f tmux/.config/tmux/tmux.conf -L spec-test new-session -d \; kill-server` exits 0.
2. Manual smoke test in a live session:
   - Open two windows. From window 1, hit `~ m 2`. Current pane moves into window 2, focus follows.
   - From a multi-pane window, hit `~ m 0`. The active pane becomes a new window at the end; focus follows.
   - From the middle of the window list, hit `~ M`. New window appears at `current+1`; focus follows.
   - Hit `~ m 7` when window 7 doesn't exist. Brief error shows in status line; no windows change.

## Out of Scope

- Auto-creating a missing target window on `m <N>` (explicitly rejected above).
- Moving **whole windows** (use `:movew -t :N` manually; not frequent enough to bind).
- Reverse direction — pulling a pane *from* another window into the current one (`join-pane -s`). Can be added later if it turns out to be wanted.
- Choose-tree-driven variant (pick destination visually). `~ s` already covers visual window selection for navigation; adding a visual move would duplicate the mental model.
