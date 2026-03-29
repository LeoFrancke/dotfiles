#!/bin/bash
set -e # exit on error

# Steps:
# 1. File system
# 2. Install packages (pacman or apt)
# 3. Dotfiles config


# 1. --- File system structure ---
mkdir -pv \
    "$HOME/10_projects/leofrancke" \
    "$HOME/20_foundations" \
    "$HOME/30_personal/1_documents" \
    "$HOME/30_personal/5_screenshots" \
    "$HOME/30_personal/7_music" \
    "$HOME/40_professional" \
    "$HOME/50_resources" \
    "$HOME/90_archive" \
    "$HOME/Desktop" \
    "$HOME/Downloads"

# XDG default directories
# Single-quoting 'EOF' disables all expansion inside the heredoc.
cat > "$HOME/.config/user-dirs.dirs" <<'EOF'
XDG_DESKTOP_DIR="$HOME/Desktop"
XDG_DOWNLOAD_DIR="$HOME/Downloads"
XDG_DOCUMENTS_DIR="$HOME/30_personal/1_documents"
XDG_PICTURES_DIR="$HOME/30_personal/5_screenshots"
XDG_MUSIC_DIR="$HOME/30_personal/7_music"
XDG_TEMPLATES_DIR="$HOME"
XDG_PUBLICSHARE_DIR="$HOME"
EOF


# 2. --- Package installation ---
# Use the right package manager
if command -v pacman &>/dev/null; then
    sudo pacman -S --needed zsh git curl gvim wezterm bat lsd imv xdg-user-dirs
elif command -v apt &>/dev/null; then
    sudo apt update && sudo apt install -y zsh git curl bat xdg-user-dirs

    # If using Ubuntu in a GUI, then lsd can be used.
    if [[ "$TERM" != "linux" ]]; then
        sudo apt install -y lsd imv gvim
    else
        sudo apt install -y vim
    fi
fi


# update default user dirs
# this command needs to be after xdg-user-dirs installation
xdg-user-dirs-update
echo "File system ready."


# Update shell to zsh
if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
    chsh -s $(which zsh)
else
    echo "Shell is already Zsh."
fi

# --- Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- Powerlevel10k ---
if [[ "$TERM" != "linux" ]] && [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# --- ZSH plugins ---
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

[ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ] && \
    git clone --depth=1 https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"

echo "Zsh plugins installed. Run: source ~/.zshrc"


# 3. --- Dotfiles config ---
DOTFILES="$HOME/10_projects/leofrancke/dotfiles"
mkdir -pv "$HOME/.vim/config"
mkdir -pv "$HOME/.vim/colors"
mkdir -pv "$HOME/.vim/spell"

# symlink of main dotfiles
ln -sfn "$DOTFILES/vim/vimrc.vim"   ~/.vimrc
ln -sfn "$DOTFILES/.zshrc"          ~/.zshrc
ln -sfn "$DOTFILES/.gitconfig"      ~/.gitconfig
ln -sfn "$DOTFILES/.wezterm.lua"    ~/.wezterm.lua
ln -sfn "$DOTFILES/.p10k.zsh"       ~/.p10k.zsh

# vim plug install, if not already installed
[ ! -f ~/.vim/autoload/plug.vim ] && \
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# symlink of vim files
ln -sfn "$DOTFILES/vim/colors/modifications.vim"   ~/.vim/colors/modifications.vim
ln -sfn "$DOTFILES/vim/config/mappings.vim"        ~/.vim/config/mappings.vim
ln -sfn "$DOTFILES/vim/config/persistent_undo.vim" ~/.vim/config/persistent_undo.vim
ln -sfn "$DOTFILES/vim/config/plugins.vim"         ~/.vim/config/plugins.vim
ln -sfn "$DOTFILES/vim/config/statusline.vim"      ~/.vim/config/statusline.vim
ln -sfn "$DOTFILES/vim/spell/en.utf-8.add"         ~/.vim/spell/en.utf-8.add

echo "Dotfiles linked!"
echo 'To verify the symlinks worked: $ ls -la ~ | grep "\->"'
echo "Don't forget to install Vim Plugins." 
echo "Inside Vim: :PlugInstall"

