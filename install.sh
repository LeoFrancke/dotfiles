#!/bin/bash
DOTFILES="$HOME/10_projects/leofrancke/dotfiles"

ln -sf $DOTFILES/vim/vimrc.vim  ~/.vimrc
ln -sf $DOTFILES/zshrc          ~/.zshrc
ln -sf $DOTFILES/wezterm.lua    ~/.wezterm.lua


curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

ln -sf $DOTFILES/vim/colors/modifications.vim   ~/.vim/colors/modifications.vim

ln -sf $DOTFILES/vim/config/mappings.vim        ~/.vim/config/mappings.vim
ln -sf $DOTFILES/vim/config/persistent_undo.vim ~/.vim/config/persistent_undo.vim
ln -sf $DOTFILES/vim/config/plugins.vim         ~/.vim/config/plugins.vim
ln -sf $DOTFILES/vim/config/statusline.vim      ~/.vim/config/statusline.vim

echo "Dotfiles linked!"
echo 'To verify it worked: \n>$ ls -la ~ | grep "\->"]'

