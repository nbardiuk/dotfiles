let g:LanguageClient_rootMarkers = { }
let g:LanguageClient_serverCommands = { }
let g:ale_fixers = { }
let g:ale_linters = { }

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
" Set default copy buffer the same as clipboard
set clipboard=unnamed
if has('unnamedplus') " X11 support
  set clipboard+=unnamedplus
endif
syntax on                           " turn on syntax highlighting
set spell spelllang=en_us           " spell check
set wildmode=list:longest,full      " Commands completion
" fzf history
cnoremap <C-F> History:<CR>
set list listchars=tab:\▸\ ,trail:· " Display tabs and trailing spaces visually
set shell=~/.nix-profile/bin/zsh

" {{{ Panes
augroup panes
  autocmd!
  " automatically rebalance windows on vim resize
  autocmd VimResized * :wincmd =
augroup END
" zoom a vim pane
nnoremap <silent> <leader>z :wincmd _<cr>:wincmd \|<cr>
" }}}

" Text Wrapping {{{
set nowrap         " Don't soft wrap lines
set linebreak      " break lines at convenient points
set textwidth=79   " where to break a line
set winwidth=80    " minimal width of active window
" navigate through display lines
nnoremap j gj
nnoremap k gk
" }}}

" Theme {{{
set background=light
set termguicolors
colorscheme github
let g:airline_theme='github'
" }}}

" Status line {{{
set laststatus=2
set noshowmode
let g:airline_powerline_fonts=1
let g:airline_detect_spell=0
let g:airline_exclude_preview=1
let g:airline#extensions#branch#format = 2 " 'foo/bar/baz' becomes 'f/b/baz'
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]' " dont show default filetype
set title
" }}}

" Folding {{{
set foldmethod=syntax
set nofoldenable

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
nnoremap <silent> <BS> :nohlsearch<CR>
" search in project files with selected text
vnoremap <silent> <Leader>f :<c-u>call <SID>run_interact("Rg")<CR>
nnoremap <silent> <Leader>f :Rg<CR>
" search in current buffer with selected text
vnoremap / y/<c-r>"<cr>
vnoremap <silent> <Leader>/ :<c-u>call <SID>run_interact("BLines")<CR>
nnoremap <silent> <Leader>/ :BLines<CR>

" paste yanked text several times
vnoremap <C-P> "0p
nnoremap <C-P> "0p

" run interactive command with selection
function! s:run_interact(command)
  " copy last selection into register r
  execute 'normal! gv"ry'

  " start interactive command
  execute 'normal :' . a:command . " \<CR>"

  " enter the selection into prompt
  call feedkeys(substitute(@r, "\n$", '', ''))
endfunction

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
" }}}

" Files navigation {{{
" search project file by selected text
vnoremap <silent> <Leader>n :<c-u>call <SID>run_interact("Files")<CR>
nnoremap <silent> <Leader>n :Files<CR>
" search buffers by selected text
vnoremap <silent> <Leader>e :<c-u>call <SID>run_interact("Buffers")<CR>
nnoremap <silent> <Leader>e :Buffers<CR>
" }}}

" NetRW {{{
let g:netrw_liststyle = 3                     " tree listing
let g:netrw_sizestyle = 'H'                   " human readable
let g:netrw_hide = 1                          " hide by default
let g:netrw_banner = 0                        " turn banner off
nnoremap <leader>N :e %:h<CR>
" }}}

" Completion {{{
set completeopt=menuone,noinsert,noselect
set shortmess+=c                                  " turn off completion messages
let g:deoplete#enable_at_startup = 1              " Use deoplete.
" }}}

" Markdown {{{
" render style instead of markup
set conceallevel=2
let g:vim_markdown_conceal=1

" use header as folding text
let g:vim_markdown_folding_style_pythonic=1

" code block aliases for syntax highlight
let g:vim_markdown_fenced_languages = [
      \'haskell=hs',
      \'javascript=js',
      \'shell=sh',
      \]

" }}}

" Neoformat {{{

" Enable tab to spaces conversion globally
let g:neoformat_basic_format_retab = 1

" Enable trimming of trailing whitespace globally
let g:neoformat_basic_format_trim = 1

" Run all enabled formatters (by default Neoformat stops after the first formatter succeeds)
let g:neoformat_run_all_formatters = 1

" }}}

" Git {{{

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'

" If this many milliseconds nothing is typed the swap file will be written to disk speedsup gitgutter
set updatetime=100

let g:gitgutter_map_keys = 0
nmap <Leader>hp <Plug>GitGutterPreviewHunk
nmap <Leader>hs <Plug>GitGutterStageHunk
nmap <Leader>hu <Plug>GitGutterUndoHunk
nmap <Leader>h[ <Plug>GitGutterPrevHunk
nmap <Leader>h] <Plug>GitGutterNextHunk
omap ih <Plug>GitGutterTextObjectInnerPending
xmap ih <Plug>GitGutterTextObjectInnerVisual
omap ah <Plug>GitGutterTextObjectOuterPending
xmap ah <Plug>GitGutterTextObjectOuterVisual
" }}}

" BAG {{{
" switch word case
inoremap <c-u> <esc>g~iw`]a

" edit my vim config
nnoremap <leader>ve :vsplit ~/.config/nixpkgs/configs/init.vim<cr>

" source my vim config
nnoremap <leader>vs :source ~/.config/nixpkgs/configs/init.vim<cr>

" always type wrong letter
cabbrev W w
" }}}

" JavaScript/Typescript {{{
augroup typescirpt_bindings
  autocmd!
  autocmd FileType typescript,javascript,typescript.tsx,javascript.jsx nnoremap <buffer> <leader>lf :ALEFix<CR>
  autocmd FileType typescript,javascript,typescript.tsx,javascript.jsx nnoremap <buffer> <C-]> :call LanguageClient#textDocument_definition()<CR>
  autocmd FileType typescript,javascript,typescript.tsx,javascript.jsx nnoremap <buffer> <leader>lr :call LanguageClient#textDocument_rename()<CR>
  autocmd FileType typescript,javascript,typescript.tsx,javascript.jsx nnoremap <buffer> <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
  autocmd FileType typescript,javascript,typescript.tsx,javascript.jsx nnoremap <buffer> } :call LanguageClient_textDocument_references()<CR>
  autocmd FileType typescript,javascript,typescript.tsx,javascript.jsx nnoremap <buffer> K :call LanguageClient_textDocument_hover()<CR>
augroup END
let g:ale_linters.javascript = ['eslint']
let g:ale_linters.typescript = ['tsserver', 'tslint']
let g:ale_fixers.json = ['prettier']
let g:ale_fixers.javascript = ['eslint', 'prettier']
let g:ale_fixers.typescript = ['prettier']

let g:LanguageClient_rootMarkers.javascript = ['tsconfig.json', 'package.json']
let g:LanguageClient_rootMarkers.typescript = ['tsconfig.json', 'package.json']

let g:LanguageClient_serverCommands.javascript = ['typescript-language-server', '--stdio']
let g:LanguageClient_serverCommands.typescript = ['typescript-language-server', '--stdio']
let g:LanguageClient_serverCommands['javascript.jsx'] = ['typescript-language-server', '--stdio']
let g:LanguageClient_serverCommands['typescript.tsx'] = ['typescript-language-server', '--stdio']
" }}}

" CSS/SASS {{{
let g:ale_linters.scss = ['stylelint']
let g:ale_linters.css = ['stylelint']
let g:ale_fixers.scss = ['prettier', 'stylelint']
let g:ale_fixers.css = ['prettier', 'stylelint']
augroup css_bindings
  autocmd!
  autocmd FileType css,scss nnoremap <buffer> <leader>lf :ALEFix<CR>
augroup END
" }}}

" Rust {{{
augroup rust_bindings
  autocmd!
  autocmd FileType rust nnoremap <buffer> <leader>t :!time cargo test<CR>
  autocmd FileType rust nnoremap <buffer> <leader>lf :ALEFix<CR>
  autocmd FileType rust nnoremap <buffer> <C-]> :call LanguageClient#textDocument_definition()<CR>
  autocmd FileType rust nnoremap <buffer> <leader>lr :call LanguageClient#textDocument_rename()<CR>
  autocmd FileType rust nnoremap <buffer> } :call LanguageClient_textDocument_references()<CR>
  autocmd FileType rust nnoremap <buffer> K :call LanguageClient_textDocument_hover()<CR>
augroup END
let g:LanguageClient_rootMarkers.rust = ['Cargo.toml']
let g:LanguageClient_serverCommands.rust = ['rls']
let g:ale_fixers.rust = ['rustfmt']
" }}}

" Haskell {{{
let g:LanguageClient_rootMarkers.haskell = ['*.cabal', 'stack.yaml']
let g:LanguageClient_serverCommands.haskell = ['ghcide', '--lsp']

let g:neoformat_enabled_haskell = ['hindent', 'stylish-haskell']

augroup haskell_bindings
  autocmd!
  autocmd FileType haskell nnoremap <buffer> <leader>lf :Neoformat<CR>
augroup END
" }}}

" Nix {{{
let g:ale_linters.nix = ['nix']

let g:neoformat_nix_nixfmt = { 'exe': 'nixfmt', 'stdin': 1 }
let g:neoformat_enabled_nix = ['nixfmt']

augroup nix_bindings
  autocmd!
  autocmd FileType nix nnoremap <buffer> <leader>lf :Neoformat<CR>
augroup END
" }}}
