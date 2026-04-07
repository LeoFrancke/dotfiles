# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
if [[ "$TERM" != "linux" ]]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"
else
    # TTY uses TERM=linux
    ZSH_THEME="ys"
fi

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git 
    gitfast # git completions
    zsh-autosuggestions zsh-completions zsh-syntax-highlighting
    # colored-man-pages
    # rust
)

source $ZSH/oh-my-zsh.sh

# Colored man pages
export MANPAGER="bat -plman"



# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi
export EDITOR='vim'
export VISUAL='vim'


# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
alias vimrc='$EDITOR ~/.vimrc'
alias wez='$EDITOR ~/.wezterm.lua'
alias zshrc='$EDITOR ~/.zshrc'
alias zh='$EDITOR ~/.zsh_history'

alias md='mkdir -pv'
alias rd='rmdir -v' # only empty dirs
alias rm='rm -iv' # interactive=always + verbose
alias mv='mv -iv'

# file browsing
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# activate virtual env. for python:
# alias venv="source ~/pyvenv/bin/activate"

# ubuntu's binary is batcat
if command -v bat &>/dev/null; then
    alias cat='bat'
elif command -v batcat &>/dev/null; then
    alias cat='batcat'
fi

# if not TTY
if [[ "$TERM" != "linux" ]]; then
    alias ls='lsd'
    alias lst='lsd --tree --depth 2'

    # https://github.com/nvbn/thefuck
    eval $(thefuck --alias fk)

    # if in ~ (home), then ignore some dirs and echo msg
    function lsd_long_all_human_readable() {
        if [[ "$PWD" == "$HOME" ]]; then
            lsd -lAh --sort=time --reverse --total-size --header \
                --date '+%Y %b %d %H:%M' \
                --ignore-glob=".local" --ignore-glob=".cache" \
                --ignore-glob=".zen" --ignore-glob=".vscode" \
                "$@" # Allows all arguments passed to the function to be sent to lsd.

            echo "\n  (hidden dirs: .local .cache .zen .vscode)"
        else
            lsd -lAh --sort=time --reverse --total-size --header \
                --date '+%Y %b %d %H:%M' \
                "$@" # Allows all arguments passed to the function to be sent to lsd.
        fi
    }

    unalias la 2>/dev/null # avoids errors
    alias la='lsd_long_all_human_readable'

    alias img='imv'          # or 'imv -f' for fullscreen
    alias zen='zen-browser'
else
    # TTY doesn't support lsd/nerd-fonts, so use ls
    alias la='ls -lAh --sort=time --reverse --color=tty'

    # autocomplete on tty
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=yellow'
fi



# highlight style
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'

# Remove bold from executable files / dirs are still bold.
LS_COLORS="${LS_COLORS}:ex=32"

# vim mode
# bindkey -v


# Enable command-line editing in Vim
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^v' edit-command-line  # Ctrl + v to edit command in Vim


# --- key-bindings ---
# Dvorak-friendly navigation (mimicking custom Vim htsn)
bindkey '^h' backward-char       # Ctrl + h (Dvorak h, QWERTY j) for left
bindkey '^t' down-history        # Ctrl + t (Dvorak t, QWERTY k) for down (next history)
bindkey '^n' up-history          # Ctrl + n (Dvorak n, QWERTY l) for up (previous history)
bindkey '^s' forward-char        # Ctrl + s (Dvorak s, QWERTY semicolon) for right

# Additional useful bindings
# bindkey '^H' backward-kill-word # default: Ctrl+W to delete a word
bindkey '^a' beginning-of-line   # Ctrl + a (Dvorak a, QWERTY a) for start of line
bindkey '^e' end-of-line         # Ctrl + e (Dvorak e, QWERTY e) for end of line
bindkey '^r' history-incremental-search-backward  # Ctrl + r (Dvorak r, QWERTY r) for history search backward
bindkey '^l' history-incremental-search-forward   # Ctrl + l (Dvorak l, QWERTY n) for history search forward

# Clear screen (Dvorak o, QWERTY s)
bindkey '^o' clear-screen

# Press 'Esc + Esc' to trigger sudo + last command
sudo-last-command() { BUFFER="sudo $(fc -ln -1)"; zle accept-line }
zle -N sudo-last-command
bindkey "^[^[" sudo-last-command  # Esc Esc


# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

