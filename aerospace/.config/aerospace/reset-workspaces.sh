#!/usr/bin/env bash
# Reset all open windows to their assigned workspaces.
# Bound to alt-shift-r in aerospace config.

move_app_windows() {
    local pattern="$1"
    local workspace="$2"

    aerospace list-windows --all --format '%{window-id}|%{app-name}' \
        | awk -F '|' -v pat="$pattern" 'tolower($2) ~ tolower(pat) { print $1 }' \
        | while read -r wid; do
            aerospace move-node-to-workspace --window-id "$wid" "$workspace" 2>/dev/null || true
        done
}

move_app_windows 'Ghostty'    G
move_app_windows 'Zed'        E
move_app_windows 'Zen'        Z
move_app_windows 'Claude'     C
move_app_windows 'Perplexity' C
move_app_windows 'Helium'     H
move_app_windows 'Figma'      F
move_app_windows 'Notion'     N
move_app_windows 'Slack'      S
move_app_windows 'Obsidian'   O
