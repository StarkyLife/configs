set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" ui

" Plug 'drewtempelmeyer/palenight.vim'
Plug 'tomasiser/vim-code-dark'

" syntax

Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'

" autocompletion and linting

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" git

Plug 'tpope/vim-fugitive'

" search

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" common

Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-unimpaired'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-commentary'

call plug#end()

" ===========================> CoC server setup

let g:coc_global_extensions = [
  \ 'coc-tsserver'
  \ ]
if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

" set background=dark
" colorscheme palenight

set termguicolors
colorscheme codedark

syntax on
set number
set signcolumn=yes
set hidden
set mouse=a
set cmdheight=2
set updatetime=300

set hlsearch
set ignorecase
set smartcase

set nobackup
set nowb

filetype plugin indent on

cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" ===========================> NERDTree setup

let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=1

nmap <silent> <leader>t :NERDTreeToggle<CR>
nmap <C-\> :NERDTreeFind<CR>

" ===========================> FZF setup

nmap <silent> <C-f> :Files<CR>
nmap <silent> <Leader>f :Rg<CR>
nmap <silent> <Leader>b :Buffers<CR>

" ===========================> CoC setup

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
