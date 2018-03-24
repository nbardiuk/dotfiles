" vim-plug {{{
call plug#begin()
Plug 'airblade/vim-gitgutter'                                     " shows git changes stats
Plug 'godlygeek/tabular'                                          " heps to align text in tabular form
Plug 'hashivim/vim-terraform'                                     " syntax and formatter for terraform
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'lifepillar/vim-solarized8'                                  " color theme
Plug 'sheerun/vim-polyglot'                                       " collection of language packs
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neco-syntax'                                         " completions from syntax file
Plug 'Shougo/neco-vim'                                            " completions for vim
Plug 'tpope/vim-commentary'                                       " enables gc commenting command
Plug 'tpope/vim-markdown'                                         " syntax and folding for markdown
Plug 'tpope/vim-sensible'                                         " sensible vim defaults
Plug 'tpope/vim-surround'                                         " adds surrounding objects
Plug 'vim-airline/vim-airline'                                    " statusline
Plug 'vim-airline/vim-airline-themes'                             " color theme for statusline
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }                       " wiki
Plug 'w0rp/ale'                                                   " linting engine
call plug#end()
" }}}

let mapleader = "\<Space>"
set hidden                          " allows to switch a buffer with unsaved changes
set number                          " show line number
set relativenumber                  " Line numbers are good
set backspace=indent,eol,start      " Allow backspace in insert mode
set history=1000                    " Store lots of :cmdline history
set showcmd                         " Show incomplete cmds down the bottom
set showmode                        " Show current mode down the bottom
set gcr=a:blinkon0                  " Disable cursor blink
set visualbell                      " No sounds
set autoread                        " Reload files changed outside vim
set mouse=a                         " Enable mouse
set mousemodel=popup_setpos         " make mouse behave like in GUI app
set clipboard=unnamedplus           " Set default copy buffer the same as clipboard
syntax on                           " turn on syntax highlighting
set nospell spelllang=en_us           " enable spell check
set wildmode=list:longest,full      " Commands completion
set list listchars=tab:\▸\ ,trail:· " Display tabs and trailing spaces visually
autocmd FocusLost * :wa             " Save file on loosing focus

" Text Wrapping {{{
set nowrap         " Don't soft wrap lines
set linebreak      " break lines at convenient points
set textwidth=79   " where to break a line
set colorcolumn=80 " visually highlight the wrap
set winwidth=80    " minimal width of the buffer
" navigate through display lines
noremap j gj
noremap k gk
" }}}

" Theme {{{
set background=light
set termguicolors
colorscheme solarized8
" }}}

" Status line {{{
set laststatus=2                             " always show status line
let g:airline#extensions#tabline#enabled = 1 " enable buffer names on top
let g:airline_theme='solarized'
let g:airline_powerline_fonts = 1
" }}}

" Folding {{{
set foldmethod=syntax

augroup vimrcFold
  " fold vimrc itself by categories
  autocmd!
  autocmd FileType vim set foldmethod=marker
  autocmd FileType vim set foldlevel=0
augroup END
" }}}

" Swap Files {{{
set noswapfile
set nobackup
set nowb
" }}}

" Persistent Undo {{{
" Keep undo history across sessions, by storing in file.
if has('persistent_undo')
    silent !mkdir ~/.config/nvim/backups > /dev/null 2>&1
    set undodir=~/.config/nvim/backups
    set undofile
    set undolevels=1000
endif
" }}}

" Indentation {{{
set autoindent
set smartindent
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

filetype plugin on
filetype indent on
" }}}

" Search and Substitute {{{
set gdefault   " use global substitution
set incsearch  " Find the next match as we type the search
set hlsearch   " Highlight searches by default
set ignorecase " Ignore case when searching...
set smartcase  " ...unless we type a capital
" Stop highgliting until next search
nmap <silent> <BS> :nohlsearch<CR>
" }}}

" Files navigation {{{
map <silent> <Leader>t :Files<CR>
map <silent> <Leader>e :History<CR>
noremap <leader>b :Buffers<cr>
" }}}

" NetRW {{{
let g:netrw_liststyle = 1                     " detail view
let g:netrw_sizestyle = 'H'                   " human readable
let g:netrw_list_hide = '\(^\|\s\s)\zs\.\S\+' " hide dotfiles
let g:netrw_hide = 1                          " hide by default
let g:netrw_banner = 0                        " turn banner off
map <leader>n :Explore!<CR>
" }}}

" Completion {{{
set completeopt=menuone,noinsert,noselect
set shortmess+=c                          " turn off completion messages
let g:deoplete#enable_at_startup = 1      " Use deoplete.
" }}}

" vimwiki {{{
let g:vimwiki_list = [{'path': '~/Dropbox/Notes',
            \   'syntax': 'markdown', 'ext': '.md',
            \   'auto_tags': 1, 'auto_toc': 1}]

autocmd FileType vimwiki setlocal wrap
autocmd FileType vimwiki setlocal textwidth=80
" }}}

" terraform {{{
let g:terraform_align=1         " apply override alignment
let g:terraform_fold_sections=1 " apply specific folding
let g:terraform_fmt_on_save=1   " reformat on save
autocmd FileType terraform setlocal commentstring=#%s
" }}}
