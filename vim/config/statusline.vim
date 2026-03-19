" Always show statusline
set laststatus=2

" Custom lightline setup
let g:lightline = {
  \ 'colorscheme': 'mycolors',
  \ 'active': {
  \   'left': [['filetype'], ['filename'], ['modified'] ],
  \   'right': [ ['lineinfo'], ['percent'] ]
  \ },
  \ 'component': {
  \   'lineinfo': '%3l:%-2c',
  \   'modified': '%{&modified?"[+]":""}',
  \ },
  \ }

" Define the palette with shades
let s:palette = {}

" Normal mode: Dark blue base (#1a3a5a)
let s:palette.normal = {
  \ 'middle': [ ['#d7d7d7', '#1a3a5a', 251, 23] ],
  \ 'left': [ ['#d7d7d7', '#34678a', 251, 24] ],
  \ 'right': [ ['#d7d7d7', '#132d47', 251, 17] ]
  \ }

" Insert mode: Green base (#2a8a2a)
let s:palette.insert = {
  \ 'middle': [ ['#1a1a1a', '#2a8a2a', 235, 28] ],
  \ 'left': [ ['#1a1a1a', '#4ab34a', 235, 35] ],
  \ 'right': [ ['#1a1a1a', '#1a671a', 235, 22] ]
  \ }

" Visual mode: Purple base (#5a2a5a)
let s:palette.visual = {
  \ 'middle': [ ['#e0e080', '#5a2a5a', 186, 53] ],
  \ 'left': [ ['#e0e080', '#7a3a7a', 186, 60] ],
  \ 'right': [ ['#e0e080', '#431f43', 186, 238] ]
  \ }

" Replace mode: Red base (#8a2a2a)
let s:palette.replace = {
  \ 'middle': [ ['#ffffff', '#8a2a2a', 15, 88] ],
  \ 'left': [ ['#ffffff', '#ab4a4a', 15, 95] ],
  \ 'right': [ ['#ffffff', '#671f1f', 15, 52] ]
  \ }

" Command mode: Orange base (#d75f00)
let s:palette.command = {
  \ 'middle': [ ['#1a1a1a', '#d75f00', 235, 166] ],
  \ 'left': [ ['#1a1a1a', '#ff8700', 235, 208] ],
  \ 'right': [ ['#1a1a1a', '#af5f00', 235, 130] ]
  \ }

" Register the custom palette
let g:lightline#colorscheme#mycolors#palette = s:palette
