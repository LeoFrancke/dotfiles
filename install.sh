#!/bin/bash
set -e # exit on error

# Steps:
# 1. File system
# 2. Install packages
# 3. Dotfiles config


# 1. --- File system structure ---
mkdir -pv \
    "$HOME/10_projects/leofrancke" \
    "$HOME/20_foundations" \
    "$HOME/30_personal/1_documents" \
    "$HOME/30_personal/4_photos" \
    "$HOME/30_personal/5_screenshots" \
    "$HOME/30_personal/7_music" \
    "$HOME/40_professional" \
    "$HOME/50_resources" \
    "$HOME/90_archive" \
    "$HOME/Desktop" \
    "$HOME/Downloads"

# XDG user dirs
cat > "$HOME/.config/user-dirs.dirs" <<EOF
XDG_DESKTOP_DIR="$HOME/Desktop"
XDG_DOWNLOAD_DIR="$HOME/Downloads"
XDG_DOCUMENTS_DIR="$HOME/30_personal/1_documents"
XDG_PICTURES_DIR="$HOME/30_personal/4_photos"
XDG_MUSIC_DIR="$HOME/30_personal/7_music"
XDG_TEMPLATES_DIR="$HOME"
XDG_PUBLICSHARE_DIR="$HOME"
EOF

xdg-user-dirs-update #### NEED VERIFICATION: does it work on ubuntu?
echo "Done. File system ready."


# 2. --- Package installation ---
# Detect distro and use the right package manager
if command -v pacman &>/dev/null; then
    sudo pacman -S --needed zsh git curl vim wezterm bat lsd imv
elif command -v apt &>/dev/null; then
    sudo apt update && sudo apt install -y zsh git curl vim bat
fi

# Update shell to zsh
chsh -s $(which zsh)

# --- Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- ZSH plugins ---
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

[ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ] && \
    git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"

echo "Done! Run: source ~/.zshrc"


# 3. --- Dotfiles config ---
DOTFILES="$HOME/10_projects/leofrancke/dotfiles"
mkdir -pv "$DOTFILES/vim"
mkdir -pv "$DOTFILES/vim/config"
mkdir -pv "$DOTFILES/vim/colors"

# symlink of main dotfiles
ln -sfn "$DOTFILES/vim/vimrc.vim"   ~/.vimrc
ln -sfn "$DOTFILES/.zshrc"          ~/.zshrc
ln -sfn "$DOTFILES/.gitconfig"      ~/.gitconfig
ln -sfn "$DOTFILES/.wezterm.lua"    ~/.wezterm.lua
ln -sfn "$DOTFILES/.p10k.zsh"       ~/.p10k.zsh

# vim plug install
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# symlink of vim files
ln -sfn "$DOTFILES/vim/colors/modifications.vim"   ~/.vim/colors/modifications.vim
ln -sfn "$DOTFILES/vim/config/mappings.vim"        ~/.vim/config/mappings.vim
ln -sfn "$DOTFILES/vim/config/persistent_undo.vim" ~/.vim/config/persistent_undo.vim
ln -sfn "$DOTFILES/vim/config/plugins.vim"         ~/.vim/config/plugins.vim
ln -sfn "$DOTFILES/vim/config/statusline.vim"      ~/.vim/config/statusline.vim

echo "Dotfiles linked!"
echo 'To verify the symlinks worked: $ ls -la ~ | grep "\->"'
echo "Don't forget to install Vim Plugins." 
echo "Inside Vim: :PlugInstall"

