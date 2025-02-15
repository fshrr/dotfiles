fortune | cowsay | lolcat
####################### P10K ###########################

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

####################### ENV STUFF ###########################

export EDITOR=$(which nvim)
export VISUAL=$(which nvim)
export TERM=xterm-256color
export PATH="/Users/protoxpire0/.local/bin:$PATH"

####################### ZSH BASE CONFIGS ###########################

# history
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt inc_append_history 
setopt append_history
setopt share_history
setopt hist_reduce_blanks
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# command autocomplete
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match

####################### ZINIT ###########################

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

####################### ZINIT PLUGINS & SNIPPETS ###########################
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
# zinit snippet OMZP::sudo
zinit snippet OMZP::cp
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::command-not-found
zinit snippet OMZP::alias-finder

# Load completions
# autoload -Uz compinit && compinit

zinit cdreplay -q

####################### ZSTYLES ###########################

# alias-finder
zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
zstyle ':omz:plugins:alias-finder' longer yes # disabled by default
zstyle ':omz:plugins:alias-finder' exact yes # disabled by default
zstyle ':omz:plugins:alias-finder' cheaper yes # disabled by default

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

####################### SHELL INTEGRATIONS ###########################

source <(fzf --zsh)
eval "$(zoxide init zsh)"

tre() { command tre "$@" -e && source "/tmp/tre_aliases_$USER" 2>/dev/null; }

function uvrun() {
    uv run "$@"
}

####################### ALIAS ###########################

# system
alias sudo='sudo '
alias dushr='du -sh * | sort -rh'

# directory related aliases
alias ..='cd ..'
alias ...='cd ../..'
alias mkdir="mkdir -p"

# application based aliases
alias v='nvim'
alias less='nvim -R '

# Aliases to make life easier
alias l="eza -al"
alias ls="eza"
alias zconf="nvim ~/.zshrc"
alias vconf="nvim ~/.config/nvim"
alias tconf="nvim ~/.config/tmux/tmux.conf.local"
alias nconf="nvim ~/.config/nix-darwin/flake.nix"
alias kconf="nvim ~/.config/kitty/kitty.conf"
alias gconf="nvim ~/.config/ghostty/config"
alias gitconf="nvim ~/.config/git/config"
alias npm="pnpm"
alias npx="pnpx"

alias dot="cd ~/.dotfiles"
alias rmf="rm -rf"

# tmux aliases
alias tmux="TERM=xterm-256color tmux"
alias tn="tmux new -s"
alias ta="tmux attach -t"
alias tl="tmux ls"
alias tk="tmux kill-session -t"

# python aliases
alias py="python3"

# docker aliases
alias dps='docker ps -a'

# homelab related aliases
alias recyclarr="docker exec recyclarr recyclarr"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# To customize prompt, run `p10k configure` or edit ~/.dotfiles/zsh/.p10k.zsh.
[[ ! -f ~/.dotfiles/zsh/.p10k.zsh ]] || source ~/.dotfiles/zsh/.p10k.zsh
