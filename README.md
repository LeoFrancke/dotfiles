# dotfiles
Config files for my dev environment. Managed by symlinks.
It handles distro detection, TTY detection, idempotent plugin installations.


## Including:
- terminal: `.wezterm.lua`
- shell: `.zshrc` + `.p10k.zsh`
- editor: `.vimrc` + `vim/`
- git: `.gitconfig`
- keyboard: `kanata.kbd`
- A bash script `install.sh`: file system, packages, symlinks

## TO-DO:
Modern CLI tools replacements
- [x] btop config file
- [x] grep -> ripgrep
- [ ] find -> fd
- [ ] diff -> delta
- [ ] cd -> zoxide
- [ ] Vim to Neovim migration
- [ ] start using Tmux

- [ ] install.sh: pacman.conf; locale=en_US; keyboard layout: dvorak;
- [ ] reinstall ly-dm via pacman

