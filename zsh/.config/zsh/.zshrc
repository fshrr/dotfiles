# Modular zsh config — numeric prefixes enforce load order
for conf in "$HOME"/.config/zsh/[0-9]*.zsh; do
  source "$conf"
done
unset conf
