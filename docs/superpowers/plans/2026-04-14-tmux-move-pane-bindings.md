# Tmux Move-Pane Bindings Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add bindings to `tmux/.config/tmux/tmux.conf` for moving the current pane into another window — existing by number (`prefix m 1`–`9`), new at end of list (`prefix m 0`), or new immediately after current (`prefix M`).

**Architecture:** Pure tmux config edit. Uses tmux's key-table mechanism (`switch-client -T move-pane`) to namespace the digits following `m` so they don't collide with the existing `prefix 1`…`prefix 9` window-jump bindings. Uppercase `M` is a direct binding on the main prefix table for the "new window after current" one-shot.

**Tech Stack:** tmux 3.x.

**Spec:** [`docs/superpowers/specs/2026-04-14-tmux-move-pane-bindings.md`](../specs/2026-04-14-tmux-move-pane-bindings.md)

**Testing notes:** Tmux config isn't unit-testable. Verification per config-change task is `tmux -f <conf> -L <label> new-session -d \; kill-server` (parse check, exit 0). Behavior verification is manual and handled in Task 3.

---

## Task 1: Add the move-pane bindings to tmux.conf

**Files:**
- Modify: `tmux/.config/tmux/tmux.conf` — insert a new section between the existing "windows (tabs)" block (ends at line 53 with `bind s choose-tree -Z`) and the "reload" block (starts at line 55 with `# -- reload`).

- [ ] **Step 1: Insert the move-pane section**

Open `tmux/.config/tmux/tmux.conf`. After the line `bind s choose-tree -Z` and the blank line following it, **before** the `# -- reload` comment, insert this block:

```tmux
# -- move pane -----------------------------------------------------------------
# m <1-9> : join current pane into existing window N (focus follows)
# m 0     : break current pane into a new window at the end
# M       : break current pane into a new window right after current

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

Preserve the existing blank lines on either side of the new section so the file structure stays readable.

- [ ] **Step 2: Parse-test the updated config**

Run from repo root:
```bash
tmux -f tmux/.config/tmux/tmux.conf -L move-pane-test new-session -d \; kill-server
```
Expected: exit code 0, no error output.

If it fails, read the error, fix the offending line, re-run until clean. Do not proceed until this passes.

- [ ] **Step 3: Sanity-check the inserted section with a diff**

```bash
git diff tmux/.config/tmux/tmux.conf
```
Expected: exactly one added block (13 non-blank `bind` / `bind -T` lines plus 4 comment lines), no unrelated changes, no changes to the surrounding sections.

- [ ] **Step 4: Commit**

```bash
git add tmux/.config/tmux/tmux.conf
git commit -m "tmux: add move-pane bindings (m <N>, m 0, M)

prefix m 1-9 joins the current pane into that window; m 0
breaks it into a new window at the end; M breaks it into a
new window right after the current one. Uses a move-pane
key-table so digits after m don't collide with prefix 1-9
window-jump bindings."
```

---

## Task 2: Update CLAUDE.md to mention the new bindings

**Files:**
- Modify: `CLAUDE.md` — the `**tmux**` bullet under `## Packages`.

- [ ] **Step 1: Locate the current tmux bullet**

Run:
```bash
grep -n "^- \*\*tmux\*\*" CLAUDE.md
```
Expected: one line pointing at the tmux package bullet.

- [ ] **Step 2: Extend the bullet**

In the tmux bullet, find the fragment that ends `... \`s\` for tree picker, \`~ ~\` for last-window.` (or equivalent trailing sentence listing the current bindings). Immediately before the next sentence (the one that starts "Theme uses ANSI palette slots…"), insert this text:

```
Move-pane bindings: `m <1-9>` joins the current pane into that window, `m 0` breaks it into a new window at the end, `M` breaks it into a new window right after current.
```

The result should read as one extra sentence inside the tmux bullet, with a single space separating it from the surrounding sentences.

- [ ] **Step 3: Verify the diff**

```bash
git diff CLAUDE.md
```
Expected: the tmux bullet gains one sentence; no other lines change.

- [ ] **Step 4: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: mention tmux move-pane bindings in CLAUDE.md"
```

---

## Task 3: Manual smoke test (user-interactive)

**Files:** None modified. Verification only.

- [ ] **Step 1: Reload the running tmux**

Inside an attached tmux session, hit the prefix then `r`. Status line should show `reloaded`.

If you don't have a session running: `tmux new-session` from a shell, then reload with prefix+`r`.

- [ ] **Step 2: Verify `m 1`–`9` joins into existing windows**

Setup: have at least 2 windows open (create one with prefix+`t` if needed). From window 1, split a pane (prefix+`L`) so you have something visibly distinct in the right pane. Focus the right pane.

Hit: prefix, then `m`, then `2`.

Expected: the right pane disappears from window 1 and reappears in window 2; your focus follows to window 2 and the moved pane is active.

- [ ] **Step 3: Verify `m 0` breaks to a new window at the end**

Setup: be on a window that is not the last in the list (e.g. window 2 of 3). Have at least two panes in it.

Hit: prefix, then `m`, then `0`.

Expected: a new window appears at the end of the window list (e.g. window 4 if you had 3); the active pane is now its only pane; focus follows.

- [ ] **Step 4: Verify `M` breaks to a new window right after current**

Setup: be on window 2 of at least 3, with at least two panes.

Hit: prefix, then `M` (Shift+m).

Expected: a new window appears at position 3, the previously-windows-3+ shift forward, the active pane is the only pane of the new window, focus follows.

- [ ] **Step 5: Verify non-existent target behavior**

Setup: have windows 1 and 2 only (so 7 doesn't exist).

Hit: prefix, then `m`, then `7`.

Expected: a brief error message in the status line (`can't find window: 7` or similar); no window or pane movement.

- [ ] **Step 6: Verify source-window auto-close**

Setup: a window with exactly one pane, and at least one other window.

From the single-pane window, hit prefix, then `m`, then a digit for an existing other window.

Expected: the pane joins the target window; the source window disappears from the list; remaining windows repack (because `renumber-windows on` is already set).

Any failing step → stop, fix the config, reload with prefix+`r`, retest. Do not mark this task complete until all six steps pass.

No commit — this task produces no file changes.

---

## Self-Review Notes

- **Spec coverage:** `m <1-9>` (Task 1 Step 1 + Task 3 Step 2), `m 0` (Task 1 Step 1 + Task 3 Step 3), `M` (Task 1 Step 1 + Task 3 Step 4), target-doesn't-exist behavior (Task 3 Step 5), source-window auto-close (Task 3 Step 6), CLAUDE.md update (Task 2). ✓
- **No placeholders** — every step has concrete commands, exact config block, or explicit expectations. ✓
- **Type/binding consistency** — the key-table name `move-pane` matches across `bind m switch-client -T move-pane` and every `bind -T move-pane` line; digit keys `0`–`9` each appear once; `M` on the main prefix table is the only uppercase direct binding added. ✓
