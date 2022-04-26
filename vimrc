filetype plugin on

let mapleader = " "
nmap <Leader>b :source ~/.vimrc<cr>
nnoremap <Leader>s :w<cr>
noremap <Leader>q  :q<cr>
nnoremap <Leader>e  :Explore<cr>
nnoremap <Leader>j <C-w>j
nnoremap <Leader>k <C-w>k
nnoremap <Leader>h <C-w>h
nnoremap <Leader>l <C-w>l
nnoremap <Leader>\ :vsplit<cr>
nnoremap <Leader>p "+p
vnoremap <Leader>y "+y
nnoremap <Leader>y "+yy
nnoremap <Leader>] <C-w><C-]>
inoremap jk <esc>
nnoremap <esc> :noh<cr>
nnoremap <Leader>rt :!retag<cr>

" Line moving and duplication
nnoremap ∆ :m .+1 <cr>== " Opttion + j
nnoremap ˚ :m .-2 <cr>== " Opttion + k
nnoremap Ô :t . <cr>== " Shift + Opttion + j

set encoding=utf-8
set cursorline
set modelines=0
set nomodeline
set ignorecase
set smartcase
set smarttab
set mouse=a
set list listchars=tab:>-,trail:·,nbsp:·,space:·
set autoread
set tags=.tags
set re=1
set updatetime=100
set autowrite

set incsearch
set hlsearch
let g:netrw_preview = 1
" Show number of matches
set shortmess-=S

" Load powerline sympbols
let g:airline_powerline_fonts = 1

" Set sidebar numbers
set relativenumber
set nu rnu
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
	 syntax on
endif
au VimResized * :wincmd =

if filereadable(expand("~/.vimrc.bundles"))
	source ~/.vimrc.bundles
endif

