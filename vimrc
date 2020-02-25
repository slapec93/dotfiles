filetype plugin indent on

set encoding=utf-8

let mapleader = " "

set relativenumber
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
	syntax on
endif

call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'tomasiser/vim-code-dark'
Plug 'chiel92/vim-autoformat'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf.vim'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'slim-template/vim-slim'
Plug 'pangloss/vim-javascript'
Plug 'cakebaker/scss-syntax.vim'
if isdirectory("/usr/local/opt/fzf")
	Plug '/usr/local/opt/fzf'
else
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }'
endif
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

colorscheme codedark

" Sets regex engine and solves Ruby type and navigation lagging:
" https://stackoverflow.com/questions/16902317/vim-slow-with-ruby-syntax-highlighting
set re=1

" Load powerline sympbols
let g:airline_powerline_fonts = 1

nnoremap <c-p> :Files<cr>
nnoremap <Leader>s :w<cr>
nnoremap <Leader>q  :q<cr>
nnoremap <Leader>e  :E<cr>
nnoremap <Leader>f  :Autoformat<cr>
nmap <Leader>b :source ~/.vimrc<cr>
nnoremap <Leader>c :bp\|bd #<CR>
nnoremap <Leader>h :Ag! <C-R><C-W><cr>:cw<cr>
nnoremap <Leader>\ :vsplit<cr>
nnoremap <Leader>gp :Gpush<cr>
nnoremap <Leader>gl :Gpull<cr>
set redrawtime=10000

set cursorline
set updatetime=100
set backspace=2
set noswapfile
set ruler
set incsearch
set invlist listchars=tab:>-,trail:·,nbsp:·,space:·
hi SpecialKey ctermfg=239
match WhiteSpaceMol / /
2match WhiteSpaceBol /^ \+/
hi WhiteSpaceBol ctermfg=239
hi WhiteSpaceMol ctermfg=235

au BufWrite * :Autoformat
au VimResized * :wincmd =

au BufEnter,BufRead *.js.erb set ft=javascript

" Plugin Gitgutter
let g:gitgutter_override_sign_column_highlight = 0
hi SignColumn ctermbg=black
hi GitGutterAdd ctermbg=28 ctermfg=15
hi GitGutterChange ctermbg=blue ctermfg=232
let g:gitgutter_sign_removed = '-'
hi GitGutterDelete ctermbg=red
hi GitGutterChangeDelete ctermbg=red
au BufNewFile,BufRead *.slim set tabstop=2 noexpandtab

let g:autoformat_autoindent = 0
let g:autoformat_retab = 0

" COC
" It is handle by coc, disable in vim-go
let g:go_def_mapping_enabled = 0
" Endwise
" disable mapping to not break coc.nvim
let g:endwise_no_mappings = 1

set hidden
set cmdheight=2
set shortmess+=c
set signcolumn=yes
" Use tab for trigger completion
" It would jump snippet positions too, but use C-j instead - more reliable
inoremap <silent><expr> <TAB>
			\ pumvisible() ? coc#_select_confirm() :
			\ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
			\ <SID>check_back_space() ? "\<TAB>" :
			\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction

" Highlight symbol under cursor on CursorHold
au CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
	autocmd!
	" Setup formatexpr specified filetype(s).
	autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
	" Update signature help on jump placeholder
	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
" nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
" nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" nmap <silent> <C-d> <Plug>(coc-range-select)
" xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')


" Using CocList
" Show all diagnostics
" nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
" nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
" nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
" nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
" nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
" nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
" nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
" nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" COC END

