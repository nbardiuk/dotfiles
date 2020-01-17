" LSP {{{
" Specify whether to use virtual text to display diagnostics.
let g:LanguageClient_useVirtualText = 0

let g:LanguageClient_rootMarkers = { }
let g:LanguageClient_serverCommands = { }

" Common LSP bindings
nnoremap <leader>lc :call LanguageClient_contextMenu()<CR>
nnoremap <leader>la :call LanguageClient_textDocument_codeAction()<CR>
" }}}

" Projectionist {{{
let g:projectionist_heuristics = {}
" }}}

let g:ale_fixers = { }
let g:ale_fixers['*'] = ['remove_trailing_lines', 'trim_whitespace']
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

set spelllang=en_us                 " spell check
set nospell                         " disabled by default
" limit spell suggestions list
set spellsuggest+=10

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
" }}}

" Status line {{{
set laststatus=2
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

  " Autosafe file
  autocmd TextChanged,InsertLeave * if &modified | :w | endif

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

let g:fzf_action =
      \{
      \  'ctrl-q': function('s:build_quickfix_list'),
      \  'ctrl-t': 'tab split',
      \  'ctrl-x': 'split',
      \  'ctrl-v': 'vsplit' 
      \}
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
augroup completoin
  autocmd!
  autocmd BufEnter * call ncm2#enable_for_buffer()
augroup END
set shortmess+=c                                  " turn off completion messages
let g:float_preview#docked = 0

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new
" line.
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
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
let g:fzf_commits_log_options =
      \  '--graph'
      \. ' --color=always'
      \. ' --format="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'

" If this many milliseconds nothing is typed the swap file will be written to disk speedsup gitgutter
set updatetime=100

let g:gitgutter_map_keys = 0
nmap <Leader>hp <Plug>(GitGutterPreviewHunk)
nmap <Leader>hs <Plug>(GitGutterStageHunk)
nmap <Leader>hu <Plug>(GitGutterUndoHunk)
nmap <Leader>h[ <Plug>(GitGutterPrevHunk)
nmap <Leader>h] <Plug>(GitGutterNextHunk)
omap ih <Plug>(GitGutterTextObjectInnerPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)

nmap <Leader>dw :call <SID>toggle_diff_whitespace()<CR>
function! s:toggle_diff_whitespace()
  if &diffopt =~ 'iwhite'
    setlocal diffopt-=iwhite
  else
    setlocal diffopt+=iwhite
  endif
endfunction

augroup git_bindings
  autocmd!
  autocmd FileType git set foldenable
  autocmd FileType git set foldlevelstart=0
augroup END
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

" Json {{{
augroup json_bindings
  autocmd!
  autocmd FileType json nnoremap <buffer> <leader>lf :ALEFix<CR>
augroup END
let g:ale_fixers.json = ['jq']
let g:ale_json_jq_options = '--monochrome-output --indent 2 --sort-keys'
" }}}

" XML {{{
augroup xml_bindings
  autocmd!
  autocmd FileType xml nnoremap <buffer> <leader>lf :ALEFix<CR>
augroup END
let g:ale_fixers.xml = ['xmllint']
let g:ale_linters.xml = ['xmllint']
" }}}

" SQL {{{
augroup sql_bindings
  autocmd!
  autocmd FileType sql nnoremap <buffer> <leader>lf :ALEFix<CR>
augroup END
let g:ale_fixers.sql = ['pgformatter']
let g:ale_linters.sql = ['sqlint']
let g:ale_sql_pgformatter_options = '--spaces 4 --comma-break'
" }}}

" JavaScript/Typescript {{{
augroup typescirpt_bindings
  autocmd!
  autocmd FileType typescript,javascript,typescript.tsx,javascript.jsx nnoremap <buffer> <leader>lf :ALEFix<CR>
  autocmd FileType typescript,javascript,typescript.tsx,javascript.jsx nnoremap <buffer> <C-]> :call LanguageClient_textDocument_definition()<CR>
  autocmd FileType typescript,javascript,typescript.tsx,javascript.jsx nnoremap <buffer> <C-W><C-]> :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
  autocmd FileType typescript,javascript,typescript.tsx,javascript.jsx nnoremap <buffer> <leader>lr :call LanguageClient_textDocument_rename()<CR>
  autocmd FileType typescript,javascript,typescript.tsx,javascript.jsx nnoremap <buffer> <leader>lt :call LanguageClient_textDocument_typeDefinition()<CR>
  autocmd FileType typescript,javascript,typescript.tsx,javascript.jsx nnoremap <buffer> } :call LanguageClient_textDocument_references({'includeDeclaration': v:false})<CR>
  autocmd FileType typescript,javascript,typescript.tsx,javascript.jsx nnoremap <buffer> K :call LanguageClient_textDocument_hover()<CR>
augroup END
let g:ale_linters.javascript = ['eslint']
let g:ale_linters.typescript = ['tsserver', 'tslint']
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
  autocmd FileType rust nnoremap <buffer> <leader>t :!time cargo test -q<CR>
  autocmd FileType rust nnoremap <buffer> <leader>lf :ALEFix<CR>
  autocmd FileType rust nnoremap <buffer> <C-]> :call LanguageClient_textDocument_definition()<CR>
  autocmd FileType rust nnoremap <buffer> <C-W><C-]> :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
  autocmd FileType rust nnoremap <buffer> <leader>lr :call LanguageClient_textDocument_rename()<CR>
  autocmd FileType rust nnoremap <buffer> } :call LanguageClient_textDocument_references({'includeDeclaration': v:false})<CR>
  autocmd FileType rust nnoremap <buffer> K :call LanguageClient_textDocument_hover()<CR>
augroup END
let g:LanguageClient_rootMarkers.rust = ['Cargo.toml']
let g:LanguageClient_serverCommands.rust = ['rls']
let g:ale_fixers.rust = ['rustfmt']
let g:ale_linters.rust = ['cargo']
let g:ale_rust_cargo_use_clippy = 1
" }}}

" Haskell {{{
let g:LanguageClient_rootMarkers.haskell = ['*.cabal', 'stack.yaml']
let g:LanguageClient_serverCommands.haskell = ['ghcide', '--lsp']

let g:neoformat_enabled_haskell = ['hindent', 'stylish-haskell']

augroup haskell_bindings
  autocmd!
  autocmd FileType haskell nnoremap <buffer> <leader>lf :Neoformat<CR>
  autocmd FileType haskell nnoremap <buffer> K :call LanguageClient_textDocument_hover()<CR>
  autocmd FileType haskell nnoremap <buffer> <C-]> :call LanguageClient_textDocument_definition()<CR>
  autocmd FileType haskell nnoremap <buffer> <C-W><C-]> :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
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

" C {{{
" more configuration options https://github.com/MaskRay/ccls/wiki/LanguageClient-neovim
let g:LanguageClient_serverCommands.c =
      \[ 'ccls'
      \, '--init={"cache": {"directory": "/tmp/ccls-cache"}}'
      \, '--log-file=/tmp/cc.log'
      \]

let g:ale_fixers.c = ['clang-format', 'clangtidy']
let g:ale_linters.c = ['clang']
augroup c_bindings
  autocmd!
  autocmd FileType c vnoremap <buffer> = :call LanguageClient_textDocument_rangeFormatting()<CR>
  autocmd FileType c nnoremap <buffer> <leader>lf :ALEFix<CR>
  autocmd FileType c nnoremap <buffer> K :call LanguageClient_textDocument_hover()<CR>
  autocmd FileType c nnoremap <buffer> <C-]> :call LanguageClient_textDocument_definition()<CR>
  autocmd FileType c nnoremap <buffer> <C-W><C-]> :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
  autocmd FileType c nnoremap <buffer> <leader>lr :call LanguageClient_textDocument_rename()<CR>
  autocmd FileType c nnoremap <buffer> } :call LanguageClient_textDocument_references({'includeDeclaration': v:false})<CR>
augroup END
" }}}

" Wiki {{{
let g:wiki_root = '~/Notes'
let g:wiki_filetypes = ['md']
let g:wiki_link_extension = '.md'
let g:wiki_link_target_type = 'md'
let g:wiki_journal =
      \{
      \ 'name': 'diary',
      \ 'frequency': 'daily',
      \ 'date_format': {
      \   'daily' : '%Y-%m-%d',
      \   'weekly' : '%Y_w%V',
      \   'monthly' : '%Y_m%m',
      \ },
      \}
" }}}

" Clojure {{{
augroup clojure_bindings
  autocmd!
  autocmd FileType clojure nmap <buffer> <leader>tn <Plug>(iced_require)<Plug>(iced_test_ns)
  autocmd FileType clojure nmap <buffer> <leader>ta <Plug>(iced_require_all)<Plug>(iced_test_all)
  autocmd FileType clojure nnoremap <buffer> <leader>to :IcedTestBufferOpen<CR>
  autocmd FileType clojure nmap <buffer> <leader>oo <Plug>(iced_stdout_buffer_open)
  autocmd FileType clojure nmap <buffer> <leader>oc <Plug>(iced_stdout_buffer_clear)
  autocmd FileType clojure nmap <buffer> <leader>lf <Plug>(iced_format_all)
  autocmd FileType clojure nnoremap <buffer> K :IcedDocumentPopupOpen<CR>
  autocmd FileType clojure nnoremap <buffer> <C-]> :IcedDefJump<CR>
  autocmd FileType clojure nnoremap <buffer> } :IcedBrowseReferences<CR>
  autocmd FileType clojure nnoremap <buffer> <leader>la :IcedCommandPalette<CR>
  autocmd FileType clojure nmap <buffer> <leader>p <Plug>(iced_eval_and_print)
  autocmd FileType clojure nmap <buffer> <leader>pp <Plug>(iced_eval_and_print)<Plug>(sexp_outer_top_list)
  autocmd FileType clojure autocmd BufWritePost <buffer> IcedRequire

  " extra sexp remappings
  autocmd FileType clojure nmap <buffer> doe <Plug>(sexp_raise_element)
  autocmd FileType clojure nmap <buffer> dof <Plug>(sexp_raise_list)
augroup END

let g:ale_linters.clojure = ['joker']

let g:iced#nrepl#connect#jack_in_command = 'LOG_LEVEL="OFF" iced repl --without-cljs'
let g:iced#buffer#stdout#mods = 'botright'

" it requires jet
let g:iced_enable_enhanced_definition_extraction = v:false

let indents = {}
let indents['Given'] = '[[:inner 0]]'
let indents['When'] = '[[:inner 0]]'
let indents['Then'] = '[[:inner 0]]'
let indents['let-system'] = '[[:inner 0]]'
let g:iced#format#rule = indents

let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let', '^Feature', '^Scenario', '^Given', '^When', '^Then', '^And']

let g:projectionist_heuristics['project.clj|deps.edn'] =
\ {
\   'src/*.clj': {
\     'type': 'source',
\     'alternate': 'test/{}_test.clj',
\   },
\   'dev/*.clj': {
\     'type': 'source',
\   },
\   'test/*_test.clj': {
\     'type': 'test',
\     'alternate': 'src/{}.clj',
\   }
\ }
" }}}
