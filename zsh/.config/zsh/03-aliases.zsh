# --- Universal aliases ---

# system
alias sudo='sudo '
alias dushr='du -sh * | sort -rh'
alias ssh='ssh -C'

# directory
alias ..='cd ..'
alias ...='cd ../..'
alias mkdir="mkdir -p"
alias rmf="rm -rf"
alias dot="cd ~/.dotfiles"

# editors
alias v='nvim'
alias less='nvim -R '

# eza
alias l="eza -alg"
alias ls="eza"

# tmux
alias tmux="TERM=xterm-256color tmux"
tn() { tmux new-session -A -s "${1:-${PWD##*/}}"; }
alias ta="tmux attach -t"
t() {
  if [ -n "$TMUX" ]; then
    tmux choose-session -Z
  elif tmux has-session 2>/dev/null; then
    tmux attach \; choose-session -Z
  fi
}
alias tl="tmux ls"
alias tk="tmux kill-session -t"

# python
alias py="python3"

# docker
alias dps='docker ps -a'
alias recyclarr="docker exec recyclarr recyclarr"

# config shortcuts
alias zshconf="nvim ~/.config/zsh/"
alias nvimconf="nvim ~/.config/nvim"
alias tmuxconf="nvim ~/.config/tmux"
alias gitconf="nvim ~/.config/git/config"
alias sshconf="nvim ~/.ssh/config"

# --- Platform-specific aliases ---
case "$OSTYPE" in
  darwin*)
    alias nconf="nvim ~/.config/nix-darwin/flake.nix"
    alias kconf="nvim ~/.config/kitty/kitty.conf"
    alias ghostconf="nvim ~/.config/ghostty/config"
    ;;
  linux*)
    # Linux-specific aliases go here
    ;;
esac
