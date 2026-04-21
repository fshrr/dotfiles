# --- Base ---
export EDITOR=$(command -v nvim)
export VISUAL="$EDITOR"
export TERM=xterm-256color
export PATH="$HOME/.local/bin:$PATH"

# --- Homebrew (macOS only) ---
case "$OSTYPE" in
  darwin*)
    for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
      [ -x "$_brew" ] && eval "$("$_brew" shellenv)" && break
    done
    unset _brew
    ;;
esac

# --- Rust (ecosystem) ---
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# --- JavaScript (ecosystem): Bun ---
if [ -d "$HOME/.bun" ]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

# --- JavaScript (ecosystem): pnpm ---
case "$OSTYPE" in
  darwin*) _pnpm_home="$HOME/Library/pnpm" ;;
  linux*)  _pnpm_home="$HOME/.local/share/pnpm" ;;
esac
if [ -n "${_pnpm_home:-}" ] && [ -d "$_pnpm_home" ]; then
  export PNPM_HOME="$_pnpm_home"
  case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
  esac
fi
unset _pnpm_home

# --- Go (ecosystem) — placeholder for future ---
# if command -v go >/dev/null; then
#   export GOPATH="$HOME/go"
#   export PATH="$GOPATH/bin:$PATH"
# fi
