#!/bin/bash
set -e # exit on error

# Steps:
# 1. File system
# 2. Install packages (pacman or apt) and plugins
# 3. Dotfiles config
# 4. Kanata installation


# 1. --- File system structure ---
mkdir -pv \
    "$HOME/10_projects/leofrancke" \
    "$HOME/20_foundations" \
    "$HOME/30_personal/1_documents" \
    "$HOME/30_personal/5_screenshots" \
    "$HOME/30_personal/6_videos" \
    "$HOME/30_personal/7_music" \
    "$HOME/40_professional" \
    "$HOME/50_resources/templates" \
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
XDG_VIDEOS_DIR="$HOME/30_personal/6_videos"
XDG_MUSIC_DIR="$HOME/30_personal/7_music"
XDG_TEMPLATES_DIR="$HOME/50_resources/templates"
XDG_PUBLICSHARE_DIR="$HOME"
XDG_PROJECTS_DIR="$HOME/10_projects"
EOF


# 2. --- Package and Plugins installation ---
# Determine the right package manager
if command -v pacman &>/dev/null; then
    sudo pacman -S --needed wezterm zsh gvim git curl bat lsd thefuck xdg-user-dirs fastfetch imv glow tldr

    # avoids error if yay not installed
    if command -v yay &>/dev/null; then
        yay -S --needed kanata-bin
    else
        echo "yay not found! Install it manually, then run this script again."
    fi

elif command -v apt &>/dev/null; then
    sudo apt update && sudo apt install -y zsh git curl bat thefuck xdg-user-dirs #fastfetch
    
    # kanata install on ubuntu
    if ! command -v kanata &>/dev/null; then
        sudo curl -L https://github.com/jtroo/kanata/releases/latest/download/kanata -o \
            /usr/bin/kanata
        sudo chmod +x /usr/bin/kanata
    fi

    # If using Ubuntu in a GUI, then lsd can be used.
    if [[ "$TERM" != "linux" ]]; then
        sudo apt install -y wezterm gvim lsd imv glow tldr
    else  # tty only
        sudo apt install -y vim
    fi
fi


# update default user directories
# this command needs to be after xdg-user-dirs installation
xdg-user-dirs-update
echo "File system ready."

# Update shell to zsh
if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
    chsh -s $(which zsh)
    echo "Your shell is now zsh."
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
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
        "$ZSH_CUSTOM/plugins/zsh-autosuggestions" && \
    echo "Installed: zsh-autosuggestions"

[ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ] && \
    git clone --depth=1 https://github.com/zsh-users/zsh-completions \
        "$ZSH_CUSTOM/plugins/zsh-completions" && \
    echo "Installed: zsh-completions"

[ ! -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ] && \
    git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting \
        "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" && \
    echo "Installed: fast-syntax-highlighting"



# 3. --- Dotfiles config ---
DOTFILES="$HOME/10_projects/leofrancke/dotfiles"
mkdir -pv \
    "$HOME/.vim/config" \
    "$HOME/.vim/colors" \
    "$HOME/.vim/spell" \
    "$HOME/.config/lsd" \
    "$HOME/.config/rmpc/themes" \
    "$HOME/.config/glow" \
    "$HOME/.config/kanata" \
    "$HOME/.config/systemd/user"

# symlink of main dotfiles
ln -sfn "$DOTFILES/.wezterm.lua"                ~/.wezterm.lua
ln -sfn "$DOTFILES/.zshrc"                      ~/.zshrc
ln -sfn "$DOTFILES/.p10k.zsh"                   ~/.p10k.zsh
ln -sfn "$DOTFILES/vim/vimrc.vim"               ~/.vimrc
ln -sfn "$DOTFILES/.gitconfig"                  ~/.gitconfig
ln -sfn "$DOTFILES/kanata.kbd"                  ~/.config/kanata/kanata.kbd
ln -sfn "$DOTFILES/icons.yaml"                  ~/.config/lsd/icons.yaml
ln -sfn "$DOTFILES/rmpc/config.ron"             ~/.config/rmpc/config.ron
ln -sfn "$DOTFILES/rmpc/theme_catppuccin.ron"   ~/.config/rmpc/themes/theme_catppuccin.ron
ln -sfn "$DOTFILES/glow.yml"                    ~/.config/glow/glow.yml

# vim plug install, if not already installed
[ ! -f ~/.vim/autoload/plug.vim ] && \
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Don't forget to install Vim Plugins, inside vim: :PlugInstall"

# symlink of vim files
ln -sfn "$DOTFILES/vim/colors/modifications.vim"   ~/.vim/colors/modifications.vim
ln -sfn "$DOTFILES/vim/config/mappings.vim"        ~/.vim/config/mappings.vim
ln -sfn "$DOTFILES/vim/config/persistent_undo.vim" ~/.vim/config/persistent_undo.vim
ln -sfn "$DOTFILES/vim/config/plugins.vim"         ~/.vim/config/plugins.vim
ln -sfn "$DOTFILES/vim/config/statusline.vim"      ~/.vim/config/statusline.vim
ln -sfn "$DOTFILES/vim/spell/en.utf-8.add"         ~/.vim/spell/en.utf-8.add

echo "Dotfiles linked!"



# 4. --- KANATA keyboard config and installation ---
if command -v kanata &>/dev/null; then
    # groups & udev
    sudo groupadd --system uinput 2>/dev/null || true
    sudo usermod -aG input,uinput "$USER"
    echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' \
        | sudo tee /etc/udev/rules.d/99-kanata.rules > /dev/null
    sudo udevadm control --reload-rules && sudo udevadm trigger

    # load uinput on boot
    echo "uinput" | sudo tee /etc/modules-load.d/uinput.conf > /dev/null

    # service file `kanata.service`
    cat > "$HOME/.config/systemd/user/kanata.service" <<'EOF'
[Unit]
Description=Kanata keyboard remapper

[Service]
Type=simple
ExecStart=/usr/bin/kanata --cfg %h/.config/kanata/kanata.kbd

[Install]
WantedBy=default.target
EOF
# EOF heredoc must be at column 0

    systemctl --user daemon-reload
    systemctl --user enable kanata
    echo "Kanata enabled. Reboot for group changes to take effect."

fi

