# Profiling zsh startup time, so it can be optimized. Run: zsh_startup
if [[ -n "$ZSH_DEBUGRC" ]]; then
  zmodload zsh/zprof
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
if [[ "$TERM" != "linux" ]]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"
else
    # TTY uses $TERM=linux
    ZSH_THEME="ys"
fi

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

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

# Plugins
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(zsh-autosuggestions fast-syntax-highlighting zsh-completions)
    # git                       # only aliases and functions
    # gitfast                   # git completions
    # zsh-syntax-highlighting   # there's a better and faster plugin

# Load ohmyzsh
source $ZSH/oh-my-zsh.sh



# --- USER CONFIGURATION ---
# Go language path (different than default)
export GOPATH="$HOME/.local/share/go"
export PATH="$GOPATH/bin:$PATH"

# Easy access for most common dirs
export dots="$HOME/10_projects/leofrancke/dotfiles"
export python="$HOME/10_projects/leofrancke/python_crashcourse"
export docs="$HOME/30_personal/1_documents"
export ss="$HOME/30_personal/5_screenshots"
export music="$HOME/30_personal/7_music"

# Preferred editor
export EDITOR="vim"

# Set personal aliases - for a full list, run `alias`.
alias reload='source ~/.zshrc && echo "zshrc reloaded"'
# alias dot-neovim='$EDITOR ~/...'
alias dot-vim='$EDITOR ~/.vimrc'
alias dot-zsh='$EDITOR ~/.zshrc'
alias dot-wezterm='$EDITOR ~/.wezterm.lua'
alias dot-p10k='$EDITOR ~/.p10k.zsh'
alias dot-kanata='$EDITOR ~/.config/kanata/kanata.kbd'
alias dot-history='$EDITOR ~/.zsh_history'

# file browsing
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias md='mkdir -pv'
alias rd='rmdir -v'     # only empty dirs
alias rm='rm -Iv'       # interactive=always + verbose
alias mv='mv -iv'


# ubuntu's binary is batcat
if command -v bat &>/dev/null; then
    alias cat='bat'
elif command -v batcat &>/dev/null; then
    alias cat='batcat'
fi

# if not TTY
if [[ "$TERM" != "linux" ]]; then
    # if the target dir is ~ (home), then ignore some heavy dirs and echo msg
    function lsd_home_function() {
        # last argument, which would be the target path
        local target="${@[-1]}"     
        # if (isEmpty OR isNot a Directory) ... then change $target variable.
        [[ -z "$target" || ! -d "$target" ]] && target="$PWD"

        local -a extra_flags    # array definition
        if [[ "$target" == "$HOME" ]]; then
            extra_flags=(
                --ignore-glob=".local" --ignore-glob=".cache"
                --ignore-glob=".zen" --ignore-glob=".vscode"
            )
            local extra_msg="\n  (hidden dirs: .local .cache .zen .vscode)"
        fi

        lsd -lAh --sort=time --reverse --total-size --header \
            --date '+%Y %b %d %H:%M' \
            "${extra_flags[@]}" "$@"  # $@ allows all arguments passed to the function to be sent to lsd.

        [[ -z "$extra_msg" ]] || echo -e "$extra_msg"  # print msg only if Not empty
    }

    alias ls='lsd'
    alias lst='lsd --tree --depth 3'
    alias la='lsd_home_function'
    alias img='imv'
    alias zen='zen-browser'

    # https://github.com/nvbn/thefuck
    # eval $(thefuck --alias fk)
else
    # TTY doesn't support lsd/nerd-fonts, so use ls
    alias la='ls -lAh --sort=time --reverse --color=tty'

    # autocomplete on tty
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=yellow'
fi


# Highlight style
FAST_HIGHLIGHT_STYLES[command]='fg=green,bold'
FAST_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
FAST_HIGHLIGHT_STYLES[alias]='fg=green,bold'

# Remove bold from executable files / dirs are still bold.
LS_COLORS="${LS_COLORS}:ex=32"

# Shell options (settings). For a complete list: set -o
set -o vi           # vim mode on the command line
set -o dvorak       # Adjusts the spelling corrector's typo heuristics for Dvorak
set -o noclobber    # Prevents file overwrite by the '>' operator
set +o emacs        # disabled
set +o extendedglob # Enables powerful glob operators like ^, #, ~. Off to avoid trouble

# Enable command-line editing in Vim
# autoload -U edit-command-line
# zle -N edit-command-line
# bindkey '^v' edit-command-line  # Ctrl + v to edit command in Vim


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

# Press 'Esc + Esc': sudo + last command
sudo-last-command() { BUFFER="sudo $(fc -ln -1)"; zle accept-line }
zle -N sudo-last-command            # make possible to set a key-binding
bindkey "^[^[" sudo-last-command    # Esc + Esc


# Expands an alias to its full command when Space is pressed.
function globalias() {
    zle _expand_alias      # expand the alias under the cursor
    # zle expand-word        # expand anything else (globs, variables, etc.)
    zle self-insert
}
zle -N globalias           # Register the function as a ZLE widget so it can be bound to a key.
bindkey ' '  globalias     # Space      → expand alias, then insert space
bindkey '^ ' magic-space   # Ctrl+Space → insert a literal space (no expansion)


# Profiles zsh startup time using zprof.
# Run, then look for slow entries at the top of the report (self+calls).
zsh_startup() {
    echo "--- zsh startup time ---"
    time ZSH_DEBUGRC=1 zsh -i -c exit 2>&1 | head -33
}


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zsh startup time
if [[ -n "$ZSH_DEBUGRC" ]]; then
  zprof
fi

