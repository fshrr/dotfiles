# --- Universal aliases ---

# system
alias sudo='sudo '
alias dushr='du -sh * | sort -rh'

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
alias l="eza -al"
alias ls="eza"

# tmux
alias tmux="TERM=xterm-256color tmux"
alias tn="tmux new -s"
alias ta="tmux attach -t"
alias tl="tmux ls"
alias tk="tmux kill-session -t"

# python
alias py="python3"

# docker
alias dps='docker ps -a'
alias recyclarr="docker exec recyclarr recyclarr"

# config shortcuts
alias zconf="nvim ~/.config/zsh/"
alias vconf="nvim ~/.config/nvim"
alias tconf="nvim ~/.config/tmux"
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
