" Leandro Francke's vimrc, 2026
" To check for errors, type :messages

" Neovim quickfix
set runtimepath+=~/.vim

" Enable modern Vim features
" Avoid side-effects when nocompatible has already been set.
if &compatible
    set nocompatible
endif

" Enable filetype detection, with filetype-specific plugins and indentation.
filetype plugin indent on    

" Setting the leader early in vimrc; it guarantees every mapping file sees the correct leader.
let mapleader = " "

" Spellcheck off by default, except txt and md. Toggle hotkey: <leader>s
set spelllang=en_us,pt_br,ru
set spelloptions=camel  " CamelCased DifferntWords
augroup filetype_settings
    " every autocmd should be inside an augroup, so it becomes idempotent.
    autocmd!
    autocmd FileType markdown,text setlocal spell
augroup END

" Visual tweaks
syntax on           " Syntax highlighting
set cursorline      " Highlight current line
set number          " Show line numbers
set scrolloff=5     " keeps x lines visible while moving
set signcolumn=yes  " Shows the signColumn on the left (errors, git marks, etc)
set relativenumber  " Relative line numbers
" Relative number on Normal mode / Absolute number on Insert mode
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * if &number | set relativenumber | endif
  autocmd BufLeave,FocusLost,InsertEnter   * if &number | set norelativenumber | endif
augroup END

" Basic settings for performance and usability
set tabstop=4 shiftwidth=4 expandtab  " 4-space indentation
set hlsearch incsearch        " Highlight and incremental search
set ignorecase smartcase      " Case-insensitive search unless caps used
set backspace=indent,eol,start
set nrformats-=octal          " Avoids octal in vim math (increment)
" set nowrapscan                " disable Search Wrap around the end of file
" Folding text:
set foldmethod=indent
set foldlevelstart=4
" zc    : fold close
" zo    : fold open
" zM    : close all folds
" zR    : open all folds


" Suggested by chatgpt:
set hidden          " lets you switch files (buffers) temporarily / smoother plugin behavior
set updatetime=300  " faster CursorHold events
if has('clipboard')
  set clipboard=unnamedplus " Use System clipboard, the 'if' avoids errors
endif
set shortmess+=c    " Completion msgs supressed (Insert-mode: <Ctrl-n/p>)
set noerrorbells
set visualbell
" New windows in vim ~ Modern, intuitive behavior
set splitbelow
set splitright


" Restore cursor position when reopening file
set viminfo^=%
set viminfofile=~/.local/state/viminfo
augroup restore_cursor
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$")
        \ && &filetype !~# 'gitcommit\|gitrebase' |
        \   execute "normal! g`\"" |
        \ endif
augroup END


" Force Esc to be recognized instantly
set timeout
set ttimeout
set timeoutlen=400      " change back to 400ms (or even 300) after building muscle memory. 
set ttimeoutlen=50


source ~/.vim/config/plugins.vim  " Before colorscheme

" Theme & True color support
if $TERM !=# "linux"
    " only if not TTY
    set termguicolors
endif

if has('nvim')
    colorscheme kanagawa-wave
else
    colorscheme retrolegends
    source ~/.vim/colors/modifications.vim  " Fine-tuning
endif

" Load all config files
" :scriptnames    -> shows loaded scripts
source ~/.vim/config/statusline.vim
source ~/.vim/config/persistent_undo.vim
source ~/.vim/config/mappings.vim

