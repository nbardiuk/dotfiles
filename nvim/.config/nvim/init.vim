" Plugins {{{
call plug#begin()
Plug 'airblade/vim-gitgutter'                                     " shows git changes stats
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': './install.sh' }
Plug 'flazz/vim-colorschemes'                                     " color theme
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'mzlogin/vim-markdown-toc'
Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }                " haskell ghci
Plug 'neomake/neomake'                                            " linting engine
Plug 'racer-rust/vim-racer'
Plug 'rust-lang/rust.vim'
Plug 'sbdchd/neoformat'
Plug 'sheerun/vim-polyglot'                                       " collection of language packs
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neco-syntax'                                         " completions from syntax file
Plug 'Shougo/neco-vim'                                            " completions for vim
Plug 'tpope/vim-commentary'                                       " enables gc commenting command
Plug 'tpope/vim-fugitive'                                         " git client
Plug 'tpope/vim-markdown'                                         " syntax and folding for markdown
Plug 'tpope/vim-sensible'                                         " sensible vim defaults
Plug 'tpope/vim-surround'                                         " adds surrounding objects
Plug 'tpope/vim-unimpaired'                                       " shortcuts
Plug 'tpope/vim-vinegar'                                          " enhance netrw
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }                       " wiki
call plug#end()
" }}}

" Rust {{{
augroup rust_bindings
  autocmd!
  autocmd FileType rust nmap gd <Plug>(rust-def)
  autocmd FileType rust nmap <leader>gd <Plug>(rust-doc)
  autocmd FileType rust nmap <leader>t :!time cargo test<CR>
  autocmd BufWritePre *.rs undojoin | Neoformat
augroup END
" }}}

" Terminal {{{
if has('nvim')

  " use Esc to exit terminal mode
  tnoremap <Esc> <C-\><C-n>
  " press Esc in terminal mode
  tnoremap <C-v><Esc> <Esc>

  " highlight cursor
  highlight! link TermCursor Cursor
  highlight! TermCursorNC guibg=red guifg=white ctermbg=1 ctermfg=15

endif
" }}}

let mapleader = "\<Space>"
set hidden                          " allows to switch a buffer with unsaved changes
set backspace=indent,eol,start      " Allow backspace in insert mode
set history=1000                    " Store lots of :cmdline history
set showcmd                         " Show incomplete cmds down the bottom
set showmode                        " Show current mode down the bottom
set guicursor=a:blinkon0            " Disable cursor blink
set visualbell                      " No sounds
set autoread                        " Reload files changed outside vim
set mouse=a                         " Enable mouse
set mousemodel=popup_setpos         " make mouse behave like in GUI app
set clipboard+=unnamedplus          " Set default copy buffer the same as clipboard
syntax on                           " turn on syntax highlighting
set nospell spelllang=en_us         " spell check
set wildmode=list:longest,full      " Commands completion
" fzf history
cmap <C-F> History:<CR>
set list listchars=tab:\▸\ ,trail:· " Display tabs and trailing spaces visually
set shell=~/.nix-profile/bin/zsh

" LSP {{{
let g:LanguageClient_serverCommands = { 'haskell': ['hie-wrapper'] }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nmap <leader>lk :call LanguageClient#textDocument_hover()<CR>
nmap <leader>ld :call LanguageClient#textDocument_definition()<CR>
nmap <leader>lr :call LanguageClient#textDocument_rename()<CR>
nmap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
nmap <leader>lb :call LanguageClient#textDocument_references()<CR>
nmap <leader>la :call LanguageClient#textDocument_codeAction()<CR>
nmap <leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>
" }}}

" Text Wrapping {{{
set nowrap         " Don't soft wrap lines
set linebreak      " break lines at convenient points
set textwidth=79   " where to break a line
set winwidth=80    " minimal width of active window
" navigate through display lines
noremap j gj
noremap k gk
" }}}

" Theme {{{
set background=light
set termguicolors
colorscheme flattened_light " solarized light
" }}}

" Status line {{{
set laststatus=2
" }}}

" Folding {{{
set foldmethod=syntax

augroup vimrcFold
  autocmd!
  " fold vimrc itself by categories
  autocmd FileType vim set foldmethod=marker
augroup END
" }}}

" Swap Undo {{{
set noswapfile
set nobackup
set nowritebackup

" Keep undo history across sessions, by storing in file.
call mkdir(&undodir, 'p')
set undofile
set undolevels=1000

augroup autosave
  autocmd!

  " Save file on loosing focus
  autocmd FocusLost * :wa

  " jum to last known position when opening buffer
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
augroup END
" }}}

" Indentation {{{
set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
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
" search in project files
nmap <silent> <Leader>f :Rg<CR>
" }}}

" Files navigation {{{
map <silent> <Leader>n :Files<CR>
map <silent> <Leader>E :History<CR>
noremap <leader>e :Buffers<cr>
" }}}

" NetRW {{{
let g:netrw_liststyle = 1                     " long listing
let g:netrw_sizestyle = 'H'                   " human readable
let g:netrw_hide = 1                          " hide by default
let g:netrw_banner = 0                        " turn banner off
map <leader>N :e %:h<CR>
" }}}

" Completion {{{
set completeopt=menuone,noinsert,noselect
set shortmess+=c                                  " turn off completion messages
let g:deoplete#enable_at_startup = 1              " Use deoplete.
call deoplete#custom#option('smart_case', v:true) " Use smartcase
" }}}

" vimwiki {{{
let g:vimwiki_list = [{
            \   'path': '~/Dropbox/Notes',
            \   'index': '0_index',
            \   'syntax': 'markdown', 'ext': '.md',
            \   'auto_toc': 1,
            \   'auto_tags': 1
            \    }]

augroup vimWiki
  autocmd!
  autocmd FileType vimwiki setlocal wrap
  autocmd FileType vimwiki setlocal textwidth=80
augroup END
" }}}

" haskell {{{
augroup haskellMaps
  autocmd!
  " update tags
  autocmd BufWritePost *.hs :call jobstart('codex update')
augroup END

" choose formatter
let g:neoformat_enabled_haskell = ['stylishhaskell']

" }}}

" Neoformat {{{

" Enable tab to spaces conversion globally
let g:neoformat_basic_format_retab = 1

" Enable trimmming of trailing whitespace globally
let g:neoformat_basic_format_trim = 1

" Run all enabled formatters (by default Neoformat stops after the first formatter succeeds)
let g:neoformat_run_all_formatters = 1
" }}}

" Neomake {{{
" Full config: when writing or reading a buffer, and on changes in insert and
" normal mode (after 1s; no delay when writing).
call neomake#configure#automake('nrwi', 500)
" }}}
