set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" ui

Plug 'tomasiser/vim-code-dark'
Plug 'itchyny/lightline.vim'

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

Plug 'tpope/vim-unimpaired'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-obsession'

call plug#end()

" ===========================> CoC server setup

let g:coc_global_extensions = [
  \ 'coc-tsserver'
  \ ]
if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

  set termguicolors
endif

colorscheme codedark

syntax on
set number
set signcolumn=yes
set hidden
set mouse=a
set cmdheight=2
set updatetime=100

filetype plugin indent on

set hlsearch
set ignorecase
set smartcase
set nowrap
set autoindent
set expandtab
set shiftwidth=4

set wildmenu
set wildmode=full
set history=1000

set nobackup
set nowb

set laststatus=2

cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
command! BufOnly silent! execute "%bd|e#|bd#"

" ===========================> NERDTree setup

let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=1

nmap <silent> <leader>t :NERDTreeToggle<CR>
nmap <C-\> :NERDTreeFind<CR>

" ====================> lightline setup
let g:lightline = {
    \ 'active': {
        \ 'left': [
            \ [ 'mode', 'paste' ],
            \ [ 'readonly', 'relativepath', 'modified' ]
        \ ],
        \ 'right': [
            \ [ 'lineinfo' ],
            \ [ 'percent' ],
            \ [ 'session', 'fileformat', 'fileencoding' ]
        \ ]
    \ },
    \ 'inactive': {
        \ 'left': [ [ 'relativepath' ] ]
    \ },
    \ 'component': {
        \ 'readonly': '%{&readonly?"\ue0a2":""}',
        \ 'session': '%{ObsessionStatus("\uf03d", "\uf28e")}'
    \ },
    \ 'component_visible_condition': {
        \ 'session': '!empty(ObsessionStatus())'
    \ }
\ }

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

xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
