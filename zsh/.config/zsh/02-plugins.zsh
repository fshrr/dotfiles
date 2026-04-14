# Zinit bootstrap
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# OMZ snippets
zinit snippet OMZP::cp
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::command-not-found
zinit snippet OMZP::alias-finder

autoload -Uz compinit && compinit
zinit cdreplay -q

# alias-finder zstyles
zstyle ':omz:plugins:alias-finder' autoload yes
zstyle ':omz:plugins:alias-finder' longer yes
zstyle ':omz:plugins:alias-finder' exact yes
zstyle ':omz:plugins:alias-finder' cheaper yes

# Prompt
if command -v oh-my-posh >/dev/null; then
  case "$OSTYPE" in
    darwin*)
      [ "$TERM_PROGRAM" != "Apple_Terminal" ] && \
        eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/zen.toml)"
      ;;
    linux*)
      eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/zen.toml)"
      ;;
  esac
fi
