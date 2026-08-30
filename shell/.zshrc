# Profiling zsh startup time, so it can be optimized. Run: zsh_startup
if [[ -n "$ZSH_DEBUGRC" ]]; then
  zmodload zsh/zprof
fi


# default theme
export P10K="$HOME/.p10k.zsh"
export DOTFILES="$HOME/10_projects/leofrancke/dotfiles"

# --- Terminal Detection ---
if [[ -n "$WAYLAND_DISPLAY" || -n "$DISPLAY" ]]; then
    # 1. Linux GUI session (Wayland / X11)
    export MY_ENV="gui"

elif [[ -n "$WSL_DISTRO_NAME" || -n "$WSL_INTEROP" ]]; then
    # 2. WSL
    export MY_ENV="wsl"

elif [[ "$TERM" == "linux" ]]; then
    # 3. Standard Linux TTY (getty)
    export MY_ENV="tty"

else
    # 4. Everything else
    export MY_ENV="gui"
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
if [[ "$MY_ENV" == "gui" ]]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"

elif [[ "$MY_ENV" == "wsl" ]]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"
    echo "to change theme -> $ p10k configure"

elif [[ "$MY_ENV" == "tty" ]]; then
    # TTY environment: 'ys' theme
    ZSH_THEME="ys"

    # Standard Colors (Dimmer)
    echo -en "\e]P0101010" # Black (Deep)
    echo -en "\e]P1FF0055" # Red (Electric Cherry)
    echo -en "\e]P200FF80" # Green (Neon Mint)
    echo -en "\e]P3FFE000" # Yellow (Laser)
    echo -en "\e]P40077FF" # Blue (Plasma)
    echo -en "\e]P5FF00FF" # Magenta (Shocking Pink)
    echo -en "\e]P600FFFF" # Cyan (Electric)
    echo -en "\e]P7E0E0E0" # White (Silver)
    
    # Bright Colors (For Bold/Vibrant text)
    echo -en "\e]P8404040" # Bright Black (Dark Grey)
    echo -en "\e]P9FF5F5F" # Bright Red
    echo -en "\e]PAA0FF00" # Bright Green (Lime)
    echo -en "\e]PBFFFF00" # Bright Yellow
    echo -en "\e]PC5F87FF" # Bright Blue
    echo -en "\e]PDD787FF" # Bright Magenta
    echo -en "\e]PE87FFFF" # Bright Cyan
    echo -en "\e]PFFFFFFF" # Bright White
    
    clear
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
# aliases
source "$DOTFILES/shell/zsh_aliases"


if [[ "$MY_ENV" == "tty" ]]; then
    # autocomplete on tty
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=yellow'
fi

# Highlight style
FAST_HIGHLIGHT_STYLES[command]='fg=green,bold'
FAST_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
# FAST_HIGHLIGHT_STYLES[alias]='fg=green,bold'

# Remove bold from executable files / dirs are still bold.
LS_COLORS="${LS_COLORS}:ex=32"

# Shell options (settings). For a complete list: set -o
set -o vi           # vim mode on the command line
set -o dvorak       # Adjusts the spelling corrector's typo heuristics for Dvorak
set -o noclobber    # Prevents file overwrite by the '>' operator
set +o emacs        # disabled
set +o extendedglob # Enables powerful glob operators like ^, #, ~. Off to avoid issues.

# Enable command-line editing in Vim
# autoload -U edit-command-line
# zle -N edit-command-line
# bindkey '^v' edit-command-line  # Ctrl + v to edit command in Vim


# --- key-bindings ---
# Dvorak-friendly navigation (mimicking custom Vim htsn)
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
    zle expand-word        # expand anything else (globs, variables, etc.)
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


# Welcome message: to-do list
export TODO_LIST="$HOME/Desktop/todo_today.md"
export TMP_FLAG="/tmp/daily_todo_$(date +%Y-%m-%d)"
if [[ ! -f "$TMP_FLAG" ]]; then
    touch "$TMP_FLAG"
    echo ""

    # Saturday-only reminder (date +%u: 1=Mon, ..., 6=Sat, 7=Sun)
    if [[ "$(date +%u)" -eq 6 ]]; then
        # echo " Pending updates: $(checkupdates 2>/dev/null | wc -l)"
        echo "📅 Happy Saturday! Take some time to plan the next week."
        echo "Don't forget to update your system"
        echo "check: ~/10_projects/00_roadmap/current_week.md"
        echo ""
    fi

    if [[ -f "$TODO_LIST" ]]; then
        echo "=== Today's To-Do List ==="
        cat "$TODO_LIST"
    else 
        echo "Your $TODO_LIST file is missing."
    fi

    echo ""
fi


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
if [[ "$MY_ENV" != "tty" ]]; then
    [[ ! -f "$P10K" ]] || source "$P10K"
fi

# zsh startup time
if [[ -n "$ZSH_DEBUGRC" ]]; then
  zprof
fi

