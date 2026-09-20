# Modular zsh config — numeric prefixes enforce load order
for conf in "$HOME"/.config/zsh/[0-9]*.zsh; do
  source "$conf"
done
unset conf

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
