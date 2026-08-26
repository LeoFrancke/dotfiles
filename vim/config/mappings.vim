" Setting the leader early in VIMRC; it guarantees every mapping file sees the correct leader.
"-- Leader key: <space>

" --- File / buffers ---
nnoremap <leader>w :w<CR>
" Write all modified buffers:
nnoremap <leader>W :wa<CR>
nnoremap <leader>q :call ConfirmQuit()<CR>
nnoremap <silent> <leader>x :wq<CR>
nnoremap <leader>s :setlocal spell! spell?<CR>
" Accepts first spelling suggestion
nnoremap <leader>z 1z=

" Run python script
augroup python_run_script
    " every autocmd should be inside an augroup, so it becomes idempotent.
    autocmd!
    autocmd FileType python nnoremap <buffer> <F5> :!python %<CR>
augroup END

" --- Navigation ---
" Toggle highlight search
nnoremap <silent> <leader>h :set hlsearch!<CR>
" Toggles 'wrap_search': Searches wraps around the end of the file.
" 'k' was chosen because it's the 'next search' in Dvorak layout.
nnoremap <leader>k :set wrapscan!<CR>
" Toggles line numbers
nnoremap <silent> <leader>n :set number! relativenumber!<CR>
" Toggles invisible characters
nnoremap <silent> <leader>l :set list!<CR>
" <CR> (Enter key) creates a new line.
nnoremap <leader><CR> o<Esc>
" Ctrl+<CR>  creates a new line (insert mode).
inoremap <C-CR> <Esc>o

" Keep cursor centered while scrolling
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Moving up/down by function, unfolding current function but folding all else
" ***needs some testing!
noremap [[  [[zMzvz.
noremap ]]  ]]zMzvz.



" --- Clipboard (system clipboard) ---
" Portable yank to system clipboard
if has('wsl') || !empty($WSL_DISTRO_NAME)
    " WSL: Pipe visual selection straight to Windows clip.exe
    nnoremap <leader>y :w !clip.exe<CR><CR>
    vnoremap <leader>y :w !clip.exe<CR><CR>
else
    " Native Linux: Standard X11/Wayland clipboard register
    nnoremap <leader>y "+y
    vnoremap <leader>y "+y
endif

nnoremap <leader>p "+p
vnoremap <leader>p "+p
" Paste/Put before:
nnoremap <leader>P "+P
vnoremap <leader>P "+P


" --- Quick config edit ---
" Reload .vimrc; redraw; error handling;
nnoremap <leader>r :try \| source $MYVIMRC \| redraw! \| echo "Reloaded .vimrc" \| catch \| echo "Error in .vimrc" \| endtry<CR>

" Determining the highlight group that the word under the cursor belongs to
nmap <silent> <F10>   :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>



" --- Dvorak friendly movement ---
" Left   Down   Up   Right
"  h      t     n      s

" Normal mode ~ (vertical motion respects wrapping)
nnoremap t gj
nnoremap n gk
nnoremap s l

" Visual mode
vnoremap t gj
vnoremap n gk
vnoremap s l

" Operator-pending mode
onoremap t gj
onoremap n gk
" Conflict with vim-surround:
" d, c and y are operators. Followed by 's', it triggers vim-surround.
"onoremap s l


" --- Legacy motions ---
"nnoremap l <nop>
inoremap <C-s> <nop>
nnoremap T J

" Until motion: <J ~ j>
noremap j t
noremap J T

" Search: <K ~ k>
noremap k nzzzv
noremap K Nzzzv
" ~ Center screen after search jumps
" n     : performs search   -> jumps to the next match
" zz    : recenter          -> forces redraw
" zv    : open folds        -> forces redraw again



" --- Confirm before :q! (if unsaved changes)
function! ConfirmQuit()
  if &modified
    if confirm("Unsaved changes! Quit without saving?", "&Yes\n&No", 2) == 1
      execute "q!"
    endif
  else
    execute "q"
  endif
endfunction

