#!/bin/bash
# Dotfiles installer for Arch Linux
# Usage: ./install.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info()  { echo -e "\033[1;36m==>\033[0m $1"; }
ok()    { echo -e "\033[1;32m  ✓\033[0m $1"; }
warn()  { echo -e "\033[1;33m  !\033[0m $1"; }

if ! command -v pacman &>/dev/null; then
    echo "This installer is for Arch Linux only (pacman not found)."
    exit 1
fi

# Pull in submodules (e.g. nvim config) if this is a git checkout that forgot --recurse-submodules
if [[ -f "$DOTFILES_DIR/.gitmodules" ]] && command -v git &>/dev/null; then
    git -C "$DOTFILES_DIR" submodule update --init --recursive 2>/dev/null || true
fi

# ----------------------------------------------------------------------------
# 1. Packages
# ----------------------------------------------------------------------------
info "Installing packages"

PACKAGES=(
    zsh
    tmux
    wezterm
    neovim
    git
    base-devel
    fzf
    fd
    ripgrep
    bat
    eza
    zoxide
    zsh-autosuggestions
    zsh-syntax-highlighting
    fastfetch
    btop
    cmatrix
    wl-clipboard
    # LSP servers used by nvim/lua/plugins/lsp.lua (no Mason, system binaries)
    gopls
    lua-language-server
    go
)

sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"
ok "Packages installed"

# ----------------------------------------------------------------------------
# 2. Symlinks
# ----------------------------------------------------------------------------
info "Linking config files"

link() {
    local src="$1"
    local dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        mv "$dst" "$dst.bak.$(date +%s)"
        warn "Backed up existing $dst"
    fi
    ln -sfn "$src" "$dst"
    ok "$dst -> $src"
}

link "$DOTFILES_DIR/zsh/.zshrc"           "$HOME/.zshrc"
link "$DOTFILES_DIR/tmux/.tmux.conf"      "$HOME/.tmux.conf"
link "$DOTFILES_DIR/wezterm/.wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"

if [[ -d "$DOTFILES_DIR/nvim" && -n "$(ls -A "$DOTFILES_DIR/nvim" 2>/dev/null)" ]]; then
    link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
else
    warn "nvim/ is empty - did you run 'git submodule update --init'?"
fi

# ----------------------------------------------------------------------------
# 3. Scripts in bin/
# ----------------------------------------------------------------------------
info "Linking scripts"

mkdir -p "$HOME/.local/bin"
for script in "$DOTFILES_DIR"/bin/*; do
    name="$(basename "$script")"
    chmod +x "$script"
    ln -sfn "$script" "$HOME/.local/bin/$name"
    ok "$name -> ~/.local/bin/$name"
done

mkdir -p "$HOME/dev"

# ----------------------------------------------------------------------------
# 4. Default shell
# ----------------------------------------------------------------------------
if [[ "$SHELL" != *zsh* ]]; then
    info "Setting zsh as default shell"
    chsh -s "$(command -v zsh)"
    ok "Default shell changed to zsh (takes effect next login)"
fi

info "Done. Restart your terminal or run: exec zsh"
