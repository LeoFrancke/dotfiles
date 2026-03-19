" Enable persistent undo
set undofile
set undodir^=~/.vim/undo_dir//

if !isdirectory(&undodir)    " Ensure the undodir exists
    call mkdir(&undodir, 'p', 0700)
endif

