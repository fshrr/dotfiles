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
setopt auto_list       # automatically list choices on ambiguous completion
setopt auto_menu       # automatically use menu completion
setopt always_to_end   # move cursor to end if word had one match

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Core shell integrations
command -v fzf >/dev/null && source <(fzf --zsh)
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# tre wrapper — sources its aliases file after run
tre() { command tre "$@" -e && source "/tmp/tre_aliases_$USER" 2>/dev/null; }
