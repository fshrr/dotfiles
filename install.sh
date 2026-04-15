#!/usr/bin/env bash
# Profile-aware stow runner. No deps beyond bash + stow.
set -euo pipefail

PROFILE="${1:-}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$PROFILE" in
  mac)     PACKAGES=(zsh git nvim tmux ghostty oh-my-posh skhd aerospace) ;;
  server)  PACKAGES=(zsh git nvim tmux oh-my-posh) ;;
  minimal) PACKAGES=(zsh git) ;;
  ""|-h|--help)
    cat <<EOF
Usage: $0 <profile>

Profiles:
  mac      Full macOS setup (zsh git nvim tmux ghostty oh-my-posh skhd aerospace)
  server   Linux homelab (zsh git nvim tmux oh-my-posh)
  minimal  Bare minimum (zsh git)

See DEPENDENCIES.md for tools each profile needs.
EOF
    exit 0 ;;
  *) echo "Unknown profile: $PROFILE" >&2; exit 1 ;;
esac

cd "$REPO_DIR"

echo "Checking for conflicts..."
conflicts="$(stow -nvR "${PACKAGES[@]}" 2>&1 || true)"
conflicts="$(printf '%s\n' "$conflicts" \
  | sed -nE 's/.*cannot stow [^ ]+ over existing target ([^ ]+) since neither a link nor a directory.*/\1/p')"

if [ -n "$conflicts" ]; then
  while IFS= read -r rel; do
    target="$HOME/$rel"
    backup="$target.pre-stow.bak"
    if [ -e "$backup" ]; then
      echo "Refusing to overwrite existing backup: $backup" >&2
      echo "Resolve manually, then re-run." >&2
      exit 1
    fi
    echo "Backing up $target -> $backup"
    mv "$target" "$backup"
  done <<< "$conflicts"
fi

echo "Stowing: ${PACKAGES[*]}"
stow -R "${PACKAGES[@]}"
echo "Done."
