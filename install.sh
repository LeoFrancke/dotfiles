#!/bin/bash
set -e # exit on error

# Steps:
# 1. File system
# 2. Install packages (pacman or apt) and plugins
# 3. Dotfiles config
# 4. Kanata config and service

# Helper functions
is_WSL() { grep -qi microsoft /proc/version &>/dev/null; }
has_cmd() { command -v "$1" &>/dev/null; }


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
#
## 2.1 Package list
#  Shared across all environments
cli_packages=(
    zsh neovim vim git curl bat lsd ripgrep fzf \
    tldr fastfetch glow btop xdg-user-dirs
)

# GUI-only packages
gui_packages=(wezterm imv)

## 2.2 Determine final target packages
packages=("${cli_packages[@]}")

if ! is_WSL; then
  packages+=("${gui_packages[@]}")
fi

## 2.3 Package manager detection & execution
# Arch Linux (pacman)
if has_cmd pacman; then
  echo "==> Installing packages via Pacman..."
  #ttf-firacode is pacman specific
  sudo pacman -S --needed "${packages[@]}" ttf-firacode-nerd

  # Kanata (Only native Linux, via AUR)
  if ! is_WSL; then
    if has_cmd yay; then
      yay -S --needed kanata-bin
    else
      echo "Warning: yay not found!
      Install it manually and re-run this script to get kanata-bin."
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


# Update default user directories
# this command needs to be after xdg-user-dirs installation
xdg-user-dirs-update
echo "File system ready."

# Update shell to zsh
if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
    chsh -s "$(which zsh)"
    echo "Your shell is now zsh."
fi

# --- Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- Powerlevel10k ---
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


# 3. --- Dotfiles config ---
DOTFILES="$HOME/10_projects/leofrancke/dotfiles"
mkdir -pv \
    "$HOME/.config/nvim" \
    "$HOME/.vim/config" \
    "$HOME/.local/state" \
    "$HOME/.vim/colors" \
    "$HOME/.vim/spell" \
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


## symlink of main dotfiles
ln -sfn "$DOTFILES/shell/.zshrc"                ~/.zshrc
ln -sfn "$DOTFILES/shell/.p10k.zsh"             ~/.p10k.zsh
ln -sfn "$DOTFILES/vim/vimrc.vim"               ~/.vimrc
# ln -sfn "$DOTFILES/vim/vimrc.vim"               ~/.config/nvim/init.vim
ln -sfn "$DOTFILES/.gitconfig"                  ~/.gitconfig
ln -sfn "$DOTFILES/ripgrep.conf"                ~/.config/ripgrep/ripgrep.conf
ln -sfn "$DOTFILES/lsd/config.yaml"             ~/.config/lsd/config.yaml
ln -sfn "$DOTFILES/lsd/icons.yaml"              ~/.config/lsd/icons.yaml
ln -sfn "$DOTFILES/rmpc/config.ron"             ~/.config/rmpc/config.ron
ln -sfn "$DOTFILES/rmpc/theme_catppuccin.ron"   ~/.config/rmpc/themes/theme_catppuccin.ron
ln -sfn "$DOTFILES/glow.yml"                    ~/.config/glow/glow.yml
ln -sfn "$DOTFILES/btop.conf"                   ~/.config/btop/btop.conf
## wezterm and kanata live outside WSL
if ! is_WSL; then
    ln -sfn "$DOTFILES/.wezterm.lua"                ~/.wezterm.lua
    ln -sfn "$DOTFILES/kanata/kanata.kbd"           ~/.config/kanata/kanata.kbd
fi
echo "Dotfiles linked!"

## vim plug install, if not already installed
[ ! -f ~/.vim/autoload/plug.vim ] && \
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "Don't forget to install Vim Plugins
Inside Vim: :PlugInstall"

## symlink of vim files
ln -sfn "$DOTFILES/vim/colors/modifications.vim"   ~/.vim/colors/modifications.vim
ln -sfn "$DOTFILES/vim/config/mappings.vim"        ~/.vim/config/mappings.vim
ln -sfn "$DOTFILES/vim/config/persistent_undo.vim" ~/.vim/config/persistent_undo.vim
ln -sfn "$DOTFILES/vim/config/plugins.vim"         ~/.vim/config/plugins.vim
ln -sfn "$DOTFILES/vim/config/statusline.vim"      ~/.vim/config/statusline.vim
ln -sfn "$DOTFILES/vim/spell/en.utf-8.add"         ~/.vim/spell/en.utf-8.add


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

