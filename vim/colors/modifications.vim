""" Corrections // Load it AFTER colorscheme

" Command to get attr. name under the cursor:
" :echo synIDattr(synID(line('.'), col('.'), 1), 'name')
" update: F10 shows highlight under the cursor.
highlight String guifg=#e5c07b
highlight Constant guifg=#e5c07b
highlight Number guifg=#56b6c2
highlight Float  guifg=#56b6c2

" Bold parentheses, braces, curly braces
highlight MatchParen guifg=#000000 guibg=#45eb45 gui=bold cterm=bold

" Comment
highlight Comment guifg=#282a36 gui=italic cterm=italic


" --- Python specific ---
" Python docstring
highlight pythonTripleQuotes guifg=#282a36
highlight pythonDocString guifg=#282a36 gui=italic cterm=italic
autocmd FileType python syntax region pythonDocString start='"""\ze[^"]' end='"""' contains=pythonTripleQuotes keepend
autocmd FileType python syntax region pythonDocString start="'''\ze[^']" end="'''" contains=pythonTripleQuotes keepend

" Python self. attribute
highlight pythonClassVar guifg=#a6a1ff gui=italic cterm=italic
" attribute: NOT WORKING!
highlight pythonAttribute guifg=#98c379
" Python function
highlight pythonFunction guifg=#61afef gui=bold cterm=bold
highlight pythonBuiltin guifg=#4c80ff gui=italic cterm=italic
highlight FunctionCall guifg=#61afef

highlight pythonQuotes guifg=#e5c07b gui=italic cterm=italic

" f-string improvements
highlight pythonFString guifg=#e5c07b
highlight pythonFStringField guifg=#a8a8a8
highlight pythonFStringDelimiter guifg=#e666ff gui=bold cterm=bold
highlight pythonFStringExpression guifg=#dadada gui=italic cterm=italic
" Apply to Python buffers
autocmd FileType python highlight link pythonFormattedValue pythonFStringExpression
autocmd FileType python highlight link pythonFStringStart pythonFStringDelimiter
autocmd FileType python highlight link pythonFStringEnd pythonFStringDelimiter


" Exceptions
autocmd FileType python syntax keyword pythonException pythonExceptions Keyword Exception ValueError TypeError RuntimeError KeyError IndexError
highlight pythonException guifg=#e06c75 gui=bold



" Ruler (subtle)
autocmd FileType python,c setlocal colorcolumn=88,89
autocmd FileType rust setlocal colorcolumn=100,101
highlight ColorColumn guifg=#ff5555 guibg=#070606 ctermfg=203

" Number Line color
highlight clear LineNr
highlight LineNr guifg=#20222b

" Cursor Line style
highlight CursorLine guibg=#121317 ctermbg=15 cterm=bold term=bold
highlight CursorLineNr guibg=#121317 gui=bold cterm=bold "guifg=#7dff7d

" Search Highlighting
highlight Search guifg=#dadada guibg=#3a3f4a gui=NONE cterm=NONE
highlight CurSearch guifg=#000000 guibg=#45eb45 gui=bold cterm=bold
highlight IncSearch guifg=#f0f0f0 guibg=#ff5555 gui=underline cterm=underline

" Selection Mode
highlight Visual guibg=#4b5263 gui=NONE cterm=NONE

" Make the Sign Column (on the left) transparent.
highlight SignColumn guibg=NONE

" Autocomplete Popup Menu
" highlight Pmenu guifg=#dadada guibg=#2a2e38 gui=NONE cterm=NONE
" highlight PmenuSel guifg=#000000 guibg=#45eb45 gui=bold cterm=bold
" highlight PmenuSbar guifg=NONE guibg=#3a3f4a gui=NONE cterm=NONE
" highlight PmenuThumb guifg=NONE guibg=#6b7280 gui=NONE cterm=NONE
highlight Pmenu guifg=#cfd6e6 guibg=#23262e
highlight PmenuSel guifg=#ffffff guibg=#3e4452 gui=bold
highlight PmenuSbar guibg=#2c313c
highlight PmenuThumb guibg=#4b5263


" Invisible character colors
highlight NonText guifg=#18202a
highlight SpecialKey guifg=#18202a
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,space:·\,eol:¬
 

" Spellcheck
highlight SpellBad   cterm=underline gui=underline ctermfg=red     guifg=#ff6b6b ctermbg=NONE
highlight SpellCap   cterm=underline gui=underline ctermfg=yellow  guifg=#ffd166 ctermbg=NONE
highlight SpellLocal cterm=underline gui=underline ctermfg=cyan    guifg=#c77dff ctermbg=NONE
highlight SpellRare  cterm=underline gui=underline ctermfg=magenta guifg=#4cc9f0 ctermbg=NONE


" Change cursor shape in different modes (Terminal vim)
" \e[1 q: Blinking block
" \e[2 q: Steady block
" \e[3 q: Blinking underline
" \e[4 q: Steady underline
" \e[5 q: Blinking vertical bar
" \e[6 q: Steady vertical bar
if &term =~ 'xterm'
    let &t_EI = "\e[2 q"  " Normal mode
    let &t_SI = "\e[5 q"  " Insert mode
    let &t_SR = "\e[3 q"  " Replace mode
endif

" Force Cursor update on Vim startup
autocmd VimEnter * silent !echo -ne "\e[2 q"
