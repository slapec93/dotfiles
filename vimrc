filetype plugin on

let mapleader = " "
nmap <Leader>b :source ~/.vimrc<cr>
nnoremap <Leader>s :w<cr>
nnoremap <Leader>q  :q<cr>
nnoremap <Leader>e  :Explore<cr>
nnoremap <Leader>j <C-w>j
nnoremap <Leader>k <C-w>k
nnoremap <Leader>h <C-w>h
nnoremap <Leader>l <C-w>l
nnoremap <Leader>p "+p
nnoremap <Leader>] <C-w><C-]>
inoremap jk <esc>
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
set shell=zsh\ -l

set incsearch
set hlsearch
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

" ===========================================================================
" PLUGINS
" ===========================================================================
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'tomasiser/vim-code-dark'
Plug 'vim-airline/vim-airline'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'thoughtbot/vim-rspec'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'Chiel92/vim-autoformat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-commentary'
Plug 'keith/rspec.vim'
call plug#end()

" File search
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l -g ""'
let g:fzf_layout = { 'down': '40%' }
let g:fzf_preview_window = []
nnoremap <c-p> :Files<cr>
nnoremap <Leader>f :Ag!<cr>
nnoremap <Leader>h :Ag! <C-R><C-W><cr>

colorscheme codedark
hi LineNr ctermfg=245
hi CursorLineNr ctermbg=63 ctermfg=255
hi SpecialKey ctermfg=240

" Load powerline sympbols
let g:airline_powerline_fonts = 1

" Fugitive
nnoremap <Leader>g :G<cr>
nnoremap <Leader>gp :G push<cr>
nnoremap <Leader>gu :G pull<cr>
nnoremap <Leader>gc :G commit<cr>

" RSpec
let g:rspec_command = ":w | !bundle exec rspec {spec}"
nmap <Leader>rs :call RunCurrentSpecFile()<cr>
nmap <Leader>r :call RunNearestSpec()<cr>
nmap <Leader>l :call RunLastSpec()<cr>
nmap <Leader>as :call RunAllSpecs()<cr>

" Gitgutter
let g:gitgutter_override_sign_column_highlight = 0
hi SignColumn ctermbg=black
hi GitGutterAdd ctermbg=28 ctermfg=15
hi GitGutterChange ctermbg=blue ctermfg=232
let g:gitgutter_sign_removed = '-'
hi GitGutterDelete ctermbg=red
hi GitGutterChangeDelete ctermbg=red

" Autoformat
let g:formatdef_rubocop = "'rubocop-daemon-wrapper --auto-correct -o /dev/null -s '.bufname('%').'\| sed -n 2,\\$p'"
let g:formatters_ruby = ['rubocop']
au BufWrite * :Autoformat

" Commentary
nmap <Leader>/ <Plug>CommentaryLine
vmap <Leader>/ <Plug>Commentary
