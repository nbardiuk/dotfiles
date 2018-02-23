set nocompatible

set relativenumber              "Line numbers are good
set number
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim

"Set default copy buffer the same as clipboard
set clipboard=unnamedplus

"turn on syntax highlighting
syntax on
set spell spelllang=en

set backspace=indent,eol,start "Delete everything

"Commands completion
set wildmode=list:longest,full

" Folding
set foldmethod=syntax

augroup vimrcFold
  " fold vimrc itself by categories
  autocmd!
  autocmd FileType vim set foldmethod=marker
  autocmd FileType vim set foldlevel=0
augroup END

" ================ Turn Off Swap Files ==============
set noswapfile
set nobackup
set nowb

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
if has('persistent_undo')
    silent !mkdir ~/.config/nvim/backups > /dev/null 2>&1
    set undodir=~/.config/nvim/backups
    set undofile
    set undolevels=1000
endif

" ================ Indentation ======================

set autoindent
set smartindent
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=8
set expandtab

filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually
set list listchars=tab:\▸\ ,trail:·

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ================ Search ===========================

set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital
" Stop highgliting until next search
nmap <silent> <BS> :nohlsearch<CR>


set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='solarized'

nnoremap ; :
let mapleader = "\<Space>"
set encoding=utf-8

map <leader>n :NERDTreeToggle<CR>

" =====================================================
map <silent> <Leader>t :Files<CR>
map <silent> <Leader>e :History<CR>
noremap <leader>b<space> :Buffers<cr>
set hidden " allows to switch a buffer with unsaved changes
" =====================================================

" CTAGS

set tags=tags;/,codex.tags;/
nmap <leader>o :TagbarToggle<CR>

" Completion {{{

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use deoplete.
let g:deoplete#enable_at_startup = 1

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" Close popup by <Space>.
inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" }}}

" vim-plug {{{

call plug#begin()

    Plug 'airblade/vim-gitgutter'
    Plug 'bling/vim-airline'
    Plug 'christoomey/vim-sort-motion'
    Plug 'garbas/vim-snipmate'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'ledger/vim-ledger'
    Plug 'lifepillar/vim-solarized8'
    Plug 'majutsushi/tagbar'
    Plug 'MarcWeber/vim-addon-mw-utils'
    Plug 'nelstrom/vim-markdown-folding'
    Plug 'scrooloose/nerdtree'
    Plug 'sheerun/vim-polyglot'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'Shougo/vimproc.vim', {'do' : 'make'}
    Plug 'tomtom/tlib_vim'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-markdown'
    Plug 'tpope/vim-sensible'
    Plug 'tpope/vim-surround'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
    Plug 'w0rp/ale'

    " Haskell
    Plug 'alx741/vim-hindent', { 'for': 'haskell' }
    Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
    Plug 'parsonsmatt/intero-neovim', { 'for': 'haskell' }

call plug#end()

" }}}

" =========================================================
" Remove gvim widgets
:set guioptions-=m  "remove menu bar
:set guioptions-=T  "remove toolbar
:set guioptions-=r  "remove right-hand scroll bar
:set guioptions-=R  "remove right-hand scroll bar
:set guioptions-=L  "remove left-hand scroll bar
:set guioptions-=l  "remove left-hand scroll bar

" Save file on loosing focus
au FocusLost * :wa

set guifont=Iosevka\ 12
set background=light
set t_Co=256           "use 256 colors
colorscheme solarized8

func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

" Load haskell configuration 
let config_haskell = expand(resolve($HOME . "/.config/nvim/vimrc.haskell"))
execute 'source '. config_haskell

" vimwiki {{{
let g:vimwiki_list = [{'path': '~/Dropbox/Notes',
            \   'syntax': 'markdown', 'ext': '.md',
            \   'auto_tags': 1, 'auto_toc': 1}]

autocmd FileType vimwiki setlocal wrap
autocmd FileType vimwiki setlocal textwidth=80
" }}}
