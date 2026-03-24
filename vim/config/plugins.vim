" Initialize Vim-Plug
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
"Plug 'vim-python/python-syntax'      " Python syntax
Plug 'rust-lang/rust.vim'            " Rust support

" Auto-closing w/ smart-jump
Plug 'Raimondi/delimitMate'          
autocmd FileType html,rust,c let b:delimitMate_matchpairs = "(:),[:],{:},<:>"
let delimitMate_expand_cr = 1
let delimitMate_jump_expansion = 1
let delimitMate_smart_quotes = 1
let delimitMate_balance_matchpairs = 1
let delimitMate_apostrophes = 1
let delimitMate_nesting_quotes = ['"', "'"]


" Color theme
Plug 'maxmx03/retrolegends.nvim', { 'branch': 'vim' }
let g:retrolegends_transparency = 1

" End plugin section
call plug#end()

