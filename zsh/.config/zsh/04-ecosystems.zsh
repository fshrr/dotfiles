# Language ecosystem integrations — each guarded by `command -v`.
# Activates only where the tool is installed, regardless of OS.

# --- JavaScript ---
if command -v bun >/dev/null; then
  [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
fi

# (pnpm: PATH/env handled in .zprofile)

# --- Python ---
if command -v uv >/dev/null; then
  uvrun() { uv run "$@"; }
fi

# --- Go --- (placeholder)
# if command -v go >/dev/null; then
#   ...
# fi

# --- Rust --- (cargo env sourced in .zprofile)
