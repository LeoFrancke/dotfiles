" Léo Francke's vimrc, 2025
" francke.leandro at {gmail}


" To check for errors, type :messages

" Enable modern Vim features
" Avoid side-effects when nocompatible has already been set.
if &compatible
    set nocompatible
endif

" Enable filetype detection, with filetype-specific plugins and indentation.
filetype plugin indent on    
syntax on    " Syntax highlighting

" Visual tweaks
set number          " Show line numbers
set relativenumber  " Relative line numbers
set cursorline      " Highlight current line

" Basic settings for performance and usability
set tabstop=4 shiftwidth=4 expandtab  " 4-space indentation
set hlsearch incsearch        " Highlight and incremental search
set ignorecase smartcase      " Case-insensitive search unless caps used
set clipboard=unnamedplus     " Use system clipboard
set backspace=indent,eol,start

" Persistence between sessions:
" '100: Save up to 100 files. 
" f1: store global marks.
" <50: Limit registers to 50 lines each. 
" s10: Max 10KB per item. 
" h: Disable hlsearch on startup.
set viminfo='100,f1,<50,s10,h

" Force Esc to be recognized instantly
"set timeout
"set ttimeout
"set timeoutlen=500
"set ttimeoutlen=10
"set noesckeys  "disabled: interfering with arrow keys


" Load all config files
" :scriptnames    -> shows loaded scripts
for file in glob('$HOME/.vim/config/*.vim', 0, 1)
    execute 'source '.file
endfor

" True color support
set termguicolors        
colorscheme grok
