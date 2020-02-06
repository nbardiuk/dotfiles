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

" Ale {{{
let g:ale_fixers = { }
let g:ale_fixers['*'] = ['remove_trailing_lines', 'trim_whitespace']
let g:ale_linters = { }

" toggle linting
nmap yol :ALEToggleBuffer<CR>
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

set scrolloff=1             | " minimal number of lines around cursor
set sidescrolloff=5         | " minimal number of chars around cursor
set nostartofline           | " keep cursor on the same offset when paging

let mapleader="\<Space>"
set hidden                  | " allows to switch a buffer with unsaved changes

set guicursor=a:blinkon0    | " Disable cursor blink in all modes

set mouse=a                 | " Enable mouse in all modes
set mousemodel=popup_setpos | " make mouse behave like in GUI app

set clipboard=unnamedplus   | " Set default copy buffer the same as clipboard


" {{{ Spelling
set spelllang=en_us  | " spell check
set nospell          | " disabled by default
set spellsuggest+=10 | " limit spell suggestions list

" turn on spell for misspells navigation
nnoremap <silent> ]s :<C-U>execute ':setlocal spell'\| normal! ]s<CR>
nnoremap <silent> ]S :<C-U>execute ':setlocal spell'\| normal! ]S<CR>
nnoremap <silent> [s :<C-U>execute ':setlocal spell'\| normal! [s<CR>
nnoremap <silent> [S :<C-U>execute ':setlocal spell'\| normal! [S<CR>
" }}}

set wildmode=list:longest,full | " Commands completion
" commands history
nnoremap q: :History:<CR>
set list listchars=tab:\▸\ ,trail:·,nbsp:+ | " Display tabs and trailing spaces visually
set shell=~/.nix-profile/bin/zsh

" {{{ Surround
let g:surround_{char2nr("\<CR>")}="\n\r\n" | " surround with new lines on Enter
" }}}

" {{{ Panes
augroup panes
  autocmd!
  " automatically rebalance windows on vim resize
  autocmd VimResized * :wincmd =
augroup END
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
set noruler
set title
set titlestring=%f " file name
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
set undofile

augroup autosave
  autocmd!

  " Autosafe file
  autocmd FocusLost,BufLeave,CursorHold * silent! :update

  " jum to last known position when opening buffer
  " https://github.com/vim/vim/blob/eaf35241197fc6b9ee9af993095bf5e6f35c8f1a/runtime/defaults.vim#L108-L117
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif
augroup END
" }}}

" Indentation {{{
set smartindent
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
" }}}

" Search and Substitute {{{
set gdefault   " use global substitution
set ignorecase " Ignore case when searching...
set smartcase  " ...unless we type a capital
" search in project files with selected text
vnoremap <silent> <Leader>f :<c-u>call <SID>run_interact("Rg")<CR>
nnoremap <silent> <Leader>f :Rg<CR>
" search in current buffer with selected text
vnoremap / y/<c-r>"<cr>
vnoremap <silent> <Leader>/ :<c-u>call <SID>run_interact("BLines")<CR>
nnoremap <silent> <Leader>/ :BLines<CR>

" search history
nnoremap q/ :History/<CR>

" paste escaped java/javascript string
nmap <leader>jp :call setreg('e', json_encode(@+))\| normal "ep<CR>
xmap <leader>jp :<C-U>call setreg('e', json_encode(@+))\| normal gv"ep<CR>
nmap <leader>jP :call setreg('e', json_encode(@+))\| normal "eP<CR>
" yank unescaped java/javascript string
xmap <leader>jy :<C-U>execute 'normal! gv"ey'\| :call setreg('+', json_decode(@e))<CR>

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

" .  relative to the directory of the current file
" ,, current directory
set path=.,,

" search project file by selected text
vnoremap <silent> <Leader>n :<c-u>call <SID>run_interact("Files")<CR>
nnoremap <silent> <Leader>n :Files<CR>

" search buffers by selected text
vnoremap <silent> <Leader>e :<c-u>call <SID>run_interact("Buffers")<CR>
nnoremap <silent> <Leader>e :Buffers<CR>

nnoremap <leader>N :Dirvish<CR>
let g:dirvish_mode=':sort ,^.*[\/],'
" }}}

" Completion {{{
set completeopt=menuone,noinsert,noselect
augroup completoin
  autocmd!
  autocmd BufEnter * call ncm2#enable_for_buffer()
augroup END
set shortmess+=c  | " turn off completion messages
let g:float_preview#docked = 0
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
nmap <Leader>gd :Gdiffsplit<CR>
nmap <Leader>gs :Gstatus<CR>
nmap <Leader>gl :Glog<CR>
nmap <Leader>hp <Plug>(GitGutterPreviewHunk)
nmap <Leader>hs <Plug>(GitGutterStageHunk)
nmap <Leader>hu <Plug>(GitGutterUndoHunk)
nmap [h <Plug>(GitGutterPrevHunk)
nmap ]h <Plug>(GitGutterNextHunk)
omap ih <Plug>(GitGutterTextObjectInnerPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)

set diffopt+=indent-heuristic,internal,algorithm:histogram

nmap <Leader>dw :call <SID>toggle_diff_whitespace()<CR>
function! s:toggle_diff_whitespace()
  if &diffopt =~? 'iwhite'
    setlocal diffopt-=iwhite
  else
    setlocal diffopt+=iwhite
  endif
endfunction

augroup git_bindings
  autocmd!
  autocmd FileType git setlocal foldenable
  autocmd FileType git setlocal foldlevelstart=0
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
function! s:typescript_mappings() abort 
  nnoremap <buffer> <leader>lf  :ALEFix<CR>
  nnoremap <buffer> <C-]>       :call LanguageClient_textDocument_definition()<CR>
  nnoremap <buffer> <C-W><C-]>  :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
  nnoremap <buffer> <leader>lr  :call LanguageClient_textDocument_rename()<CR>
  nnoremap <buffer> <leader>lt  :call LanguageClient_textDocument_typeDefinition()<CR>
  nnoremap <buffer> }           :call LanguageClient_textDocument_references({'includeDeclaration': v:false})<CR>
  nnoremap <buffer> K           :call LanguageClient_textDocument_hover()<CR>
endfunction
augroup typescirpt_bindings
  autocmd!
  autocmd FileType typescript,javascript,typescript.tsx,javascript.jsx call s:typescript_mappings()
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
function! s:rust_mappings() abort
  nnoremap <buffer> <leader>t   :!time cargo test -q<CR>
  nnoremap <buffer> <leader>lf  :ALEFix<CR>
  nnoremap <buffer> <C-]>       :call LanguageClient_textDocument_definition()<CR>
  nnoremap <buffer> <C-W><C-]>  :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
  nnoremap <buffer> <leader>lr  :call LanguageClient_textDocument_rename()<CR>
  nnoremap <buffer> }           :call LanguageClient_textDocument_references({'includeDeclaration': v:false})<CR>
  nnoremap <buffer> K           :call LanguageClient_textDocument_hover()<CR>
endfunction
augroup rust_bindings
  autocmd!
  autocmd FileType rust call s:rust_mappings()
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

function! s:haskell_mappings() abort 
  nnoremap <buffer> <leader>lf  :Neoformat<CR>
  nnoremap <buffer> K           :call LanguageClient_textDocument_hover()<CR>
  nnoremap <buffer> <C-]>       :call LanguageClient_textDocument_definition()<CR>
  nnoremap <buffer> <C-W><C-]>  :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
endfunction
augroup haskell_bindings
  autocmd!
  autocmd FileType haskell call s:haskell_mappings()
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

function! s:c_mappings() abort
  vnoremap <buffer> =           :call LanguageClient_textDocument_rangeFormatting()<CR>
  nnoremap <buffer> <leader>lf  :ALEFix<CR>
  nnoremap <buffer> K           :call LanguageClient_textDocument_hover()<CR>
  nnoremap <buffer> <C-]>       :call LanguageClient_textDocument_definition()<CR>
  nnoremap <buffer> <C-W><C-]>  :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
  nnoremap <buffer> <leader>lr  :call LanguageClient_textDocument_rename()<CR>
  nnoremap <buffer> }           :call LanguageClient_textDocument_references({'includeDeclaration': v:false})<CR>
endfunction
augroup c_bindings
  autocmd!
  autocmd FileType c call s:c_mappings()
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

let g:wiki_mappings_global={}
let g:wiki_mappings_local={}
let g:wiki_mappings_global['<plug>(wiki-journal)']='<leader>w_disable'
let g:wiki_mappings_local['<plug>(wiki-journal-copy-tonext)']='<leader>w_disable'

let g:wiki_mappings_global['<plug>(wiki-open)']='<leader>we'
let g:wiki_mappings_global['<plug>(wiki-fzf-pages)']='<leader>wn'
" }}}

" Date Time snippets {{{
let time_format='%H:%M:%S'
let date_format='%Y-%m-%d'
nnoremap <leader>dt a<C-R>=strftime(time_format)<CR><Esc>
nnoremap <leader>dd a<C-R>=strftime(date_format)<CR><Esc>
" }}}

" sexp {{{
function! s:sexp_mappings() abort

  nmap <buffer> doe <Plug>(sexp_raise_element)
  nmap <buffer> dof <Plug>(sexp_raise_list)

  " emulate text object for pair of elements
  " i.e. key/value binding/expr test/expr
  "
  "   pair forward
  xmap <buffer> ip <Plug>(sexp_inner_element)<Plug>(sexp_move_to_next_element_tail)
  omap <buffer> ip :<C-U>normal vip<CR>
  "   pair backward
  xmap <buffer> iP <Plug>(sexp_inner_element)o<Plug>(sexp_move_to_prev_element_head)
  omap <buffer> iP :<C-U>normal viP<CR>

endfunction

augroup more_sexp_mappings
    autocmd!
    execute 'autocmd FileType' get(g:, 'sexp_filetypes', 'lisp,scheme,clojure') 'call s:sexp_mappings()'
augroup END
" }}}

" Clojure {{{
function! s:clojure_mappings() abort
  nmap      <buffer> <leader>tn <Plug>(iced_require)<Plug>(iced_test_ns)
  nmap      <buffer> <leader>ta <Plug>(iced_require_all)<Plug>(iced_test_all)
  nnoremap  <buffer> <leader>to :IcedTestBufferOpen<CR>
  nmap      <buffer> <leader>oo <Plug>(iced_stdout_buffer_open)
  nmap      <buffer> <leader>oc <Plug>(iced_stdout_buffer_clear)
  nmap      <buffer> <leader>oq <Plug>(iced_stdout_buffer_close)
  nmap      <buffer> <leader>lf <Plug>(iced_format_all)
  nnoremap  <buffer> K          :IcedDocumentPopupOpen<CR>
  nnoremap  <buffer> <C-]>      :IcedDefJump<CR>
  nnoremap  <buffer> }          :IcedBrowseReferences<CR>
  nnoremap  <buffer> <leader>la :IcedCommandPalette<CR>
  nmap      <buffer> <leader>p  <Plug>(iced_eval_and_print)
  nmap      <buffer> <leader>pe <Plug>(iced_eval_and_print)<Plug>(sexp_inner_element)
  nmap      <buffer> <leader>pf <Plug>(iced_eval_and_print)<Plug>(sexp_outer_list)
  nmap      <buffer> <leader>pp <Plug>(iced_eval_and_print)<Plug>(sexp_outer_top_list)
endfunction

augroup clojure_bindings
  autocmd!
  autocmd FileType clojure call s:clojure_mappings()
  autocmd FileType clojure autocmd BufWritePost <buffer> IcedRequire
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

" use my clojure syntax fork
let g:polyglot_disabled = ['clojure']

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

" Whiteroom {{{
function! s:goyo_enter()
  ALEDisableBuffer
  setlocal nospell
  call ncm2#disable_for_buffer()
  setlocal wrap
endfunction

function! s:goyo_leave()
  ALEEnableBuffer
  set spell<
  call ncm2#enable_for_buffer()
  set wrap<
endfunction

augroup whiteroom
  autocmd!
  autocmd User GoyoEnter nested call <SID>goyo_enter()
  autocmd User GoyoLeave nested call <SID>goyo_leave()
augroup END

let g:goyo_height='100%'

" toggle whiteroom
nmap yog :Goyo<CR>
" }}}
