# dotfiles
Config files for my dev environment. Managed by symlinks.
It handles distro detection, TTY detection, idempotent plugin installations.


## Including but not limited to:
- terminal: `.wezterm.lua`
- shell: `.zshrc` + `.p10k.zsh`
- editor: `.vimrc` + `vim/`
- keyboard: `kanata.kbd`
- A bash script `install.sh`: file system, packages, symlinks

## TO-DO:
Modern CLI tools replacements
- [ ] (priority) start using Tmux
- [x] btop
- [x] grep -> ripgrep
- [ ] find -> fd
- [ ] diff -> delta
- [ ] cd -> zoxide
- [ ] Vim -> Neovim
- [x] kmscon

- [ ] install.sh: pacman.conf; locale=en_US; GUI keyboard layout: dvorak;
- [ ] reinstall ly-dm via pacman

