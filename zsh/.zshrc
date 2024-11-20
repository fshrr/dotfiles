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

####################### ZSH BASE CONFIGS ###########################

# history
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances of the shell

# command autocomplete
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match

####################### ZINIT ###########################

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

####################### ZINIT PLUGINS ###########################
zinit ice depth=1; zinit light romkatv/powerlevel10k

####################### ALIAS ###########################

# application based aliases
alias sudo="sudo "
alias v="nvim"
alias sv="sudo nvim"
alias chrome="/usr/bin/open -a '/Applications/Google Chrome.app'"
alias safari="/usr/bin/open -a '/Applications/Safari.app'"

# Aliases to make life easier
alias ls="eza"
alias ..="cd .."
alias ...="cd ../.."
alias zconf="nvim ~/.zshrc"
alias vconf="nvim ~/.config/nvim/init.vim"
alias tconf="nvim ~/.tmux.conf"
alias nconf="nvim ~/.config/nix-darwin/flake.nix"
alias dot="cd ~/.dotfiles"
alias rmf="rm -rf"

# tmux aliases
alias tmux="TERM=xterm-256color tmux"
alias tn="tmux new -s"
alias ta="tmux attach -t"
alias tl="tmux ls"
alias tk="tmux kill-session -t"

# tmux aliases
alias tmux="TERM=xterm-256color tmux"
alias tn="tmux new -s"
alias ta="tmux attach -t"
alias tl="tmux ls"
alias tk="tmux kill-session -t"

# python aliases
alias py="python"

# plugin related aliases
alias cp="rsync --progress -ah"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
