#!/bin/bash
set -e   # exit on error
DOTFILES="$HOME/10_projects/leofrancke/dotfiles"

######             INSTRUCTIONS                #####
# Just run the command below to get your env ready #
# curl -fsSL https://raw.githubusercontent.com/LeoFrancke/dotfiles/main/install.sh | bash

## Script steps:
# 0. Clone the repo
# 1. Install packages (pacman or apt) and plugins
# 2. Dotfiles configuration
# 3. Create the file system
# 4. Kanata config and service


# Helper functions
is_WSL() { grep -qi microsoft /proc/version &>/dev/null; }
has_cmd() { command -v "$1" &>/dev/null; }
if ! has_cmd git; then
    echo "Error: git not installed. Do it manually."
    exit 1
fi


# 0. --- Cloning the GitHub repo ---
if [ ! -d "$DOTFILES/.git" ]; then
    echo "==> Cloning dotfiles..."
    git clone https://github.com/LeoFrancke/dotfiles.git "$DOTFILES"
fi


# 1. --- Package and Plugins installation ---
## 1.1 Package list
#  Shared across all environments.
#  already installed: git curl
cli_packages=(
    zsh neovim tmux bat lsd ripgrep fzf git-delta openssh \
    tldr fastfetch glow btop xdg-user-dirs 
)

# GUI-only packages
gui_packages=(wezterm firefox imv)

## 1.2 Determine final target packages
packages=("${cli_packages[@]}")
if ! is_WSL; then
    packages+=("${gui_packages[@]}")
fi
if ! has_cmd vim; then
    packages+=("gvim")
fi

## 1.3 Package manager detection & execution
# Arch Linux (pacman)
if has_cmd pacman; then
    sudo pacman -Syyu     # update first, otherwise any package may fail
    echo "==> Installing packages via Pacman..."
    sudo pacman -S --needed "${packages[@]}" ttf-firacode-nerd  # pacman specific font

    # Kanata (Only native Linux, via AUR)
    if ! is_WSL; then
        if has_cmd yay; then
            yay -S --needed kanata-bin
        else
            echo "Warning: yay not found!"
            echo "Install it manually and re-run this script to get kanata-bin."
        fi
    fi

# Debian/Ubuntu (apt)
elif has_cmd apt; then
    echo "==> Updating and installing packages via APT..."
    sudo apt update
    sudo apt install -y "${packages[@]}"

    # Kanata binary install (Only native Linux)
    if ! is_WSL && ! has_cmd kanata; then
        echo "==> Downloading Kanata binary..."
        sudo curl -L https://github.com/jtroo/kanata/releases/latest/download/kanata \
            -o /usr/local/bin/kanata
        sudo chmod +x /usr/local/bin/kanata
    fi
fi

## 1.4 Update shell to zsh
if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
    chsh -s "$(which zsh)"
    echo -e "Your shell is now zsh \n"
fi

## 1.5 Zshell
# --- Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- Powerlevel10k theme ---
if [[ "$TERM" != "linux" ]] && [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" && \
    echo "Theme installed: PowerLevel10k"
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


# 2. --- Dotfiles config ---
mkdir -pv \
    "$HOME/.config/nvim" \
    "$HOME/.config/tmux" \
    "$HOME/.vim/config" \
    "$HOME/.local/state" \
    "$HOME/.vim/colors" \
    "$HOME/.vim/spell" \
    "$HOME/.ssh" \
    "$HOME/.config/ripgrep" \
    "$HOME/.config/lsd" \
    "$HOME/.config/rmpc/themes" \
    "$HOME/.config/glow" \
    "$HOME/.config/btop"

if ! is_WSL; then
    mkdir -pv \
        "$HOME/.config/kanata" \
        "$HOME/.config/systemd/user"
fi

# OpenSSH requires strict owner-only permissions (user=full access / group+others=none)
chmod u=rwx,go=                                 "$HOME/.ssh"
chmod u=rw,go=                                  "$DOTFILES/ssh/config"

## Symlink of main dotfiles
ln -sfn "$DOTFILES/shell/.zshrc"                "$HOME/.zshrc"
ln -sfn "$DOTFILES/shell/.p10k.zsh"             "$HOME/.p10k.zsh"
ln -sfn "$DOTFILES/vim/vimrc.vim"               "$HOME/.vimrc"
# ln -sfn "$DOTFILES/vim/vimrc.vim"               "$HOME/.config/nvim/init.vim"
ln -sfn "$DOTFILES/tmux/tmux.conf"              "$HOME/.config/tmux/.tmux.conf"
ln -sfn "$DOTFILES/.gitconfig"                  "$HOME/.gitconfig"
ln -sfn "$DOTFILES/ssh/config"                  "$HOME/.ssh/config"
ln -sfn "$DOTFILES/ripgrep.conf"                "$HOME/.config/ripgrep/ripgrep.conf"
ln -sfn "$DOTFILES/lsd/config.yaml"             "$HOME/.config/lsd/config.yaml"
ln -sfn "$DOTFILES/lsd/icons.yaml"              "$HOME/.config/lsd/icons.yaml"
ln -sfn "$DOTFILES/rmpc/config.ron"             "$HOME/.config/rmpc/config.ron"
ln -sfn "$DOTFILES/rmpc/theme_catppuccin.ron"   "$HOME/.config/rmpc/themes/theme_catppuccin.ron"
ln -sfn "$DOTFILES/glow.yml"                    "$HOME/.config/glow/glow.yml"
ln -sfn "$DOTFILES/btop.conf"                   "$HOME/.config/btop/btop.conf"

if ! is_WSL; then    ## wezterm + kanata run natively on Windows, not inside WSL
    ln -sfn "$DOTFILES/.wezterm.lua"            "$HOME/.wezterm.lua"
    ln -sfn "$DOTFILES/kanata/kanata.kbd"       "$HOME/.config/kanata/kanata.kbd"
fi
echo -e "==> Dotfiles linked! \n"

## Vim plug install, if not already installed
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "Don't forget to install Vim Plugins"
    echo -e "Inside Vim: :PlugInstall \n"
fi

## Symlink of vim files
ln -sfn "$DOTFILES/vim/colors/modifications.vim"   "$HOME/.vim/colors/modifications.vim"
ln -sfn "$DOTFILES/vim/config/mappings.vim"        "$HOME/.vim/config/mappings.vim"
ln -sfn "$DOTFILES/vim/config/persistent_undo.vim" "$HOME/.vim/config/persistent_undo.vim"
ln -sfn "$DOTFILES/vim/config/plugins.vim"         "$HOME/.vim/config/plugins.vim"
ln -sfn "$DOTFILES/vim/config/statusline.vim"      "$HOME/.vim/config/statusline.vim"
ln -sfn "$DOTFILES/vim/spell/en.utf-8.add"         "$HOME/.vim/spell/en.utf-8.add"


# 3. --- File system structure ---
mkdir -pv \
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

# Update default user directories
xdg-user-dirs-update
echo "File system ready"


# 4. --- KANATA keyboard config and installation ---
if has_cmd kanata; then
    # groups & udev
    sudo groupadd --system uinput 2>/dev/null || true  # returns True if group already exists
    sudo usermod -aG input,uinput "$USER"
    echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' \
        | sudo tee /etc/udev/rules.d/99-kanata.rules > /dev/null
    sudo udevadm control --reload-rules && sudo udevadm trigger

    # load uinput on boot
    echo "uinput" | sudo tee /etc/modules-load.d/uinput.conf > /dev/null

    # user service
    cp "$DOTFILES/kanata/kanata.service" $HOME/.config/systemd/user/kanata.service
    systemctl --user daemon-reload
    systemctl --user enable kanata
    echo "Kanata service enabled. Reboot needed."
fi

