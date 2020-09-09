scriptencoding utf-8

" Fat finger escape |map-modes|
noremap <F1> <ESC>
noremap! <F1> <ESC>

" LSP {{{
" Specify whether to use virtual text to display diagnostics.
let g:LanguageClient_useVirtualText = 'CodeLens'
let g:LanguageClient_diagnosticsEnable = 0

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

" open lint error details
nnoremap L :ALEDetail<CR>

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


let g:loaded_python_provider = 0 | " disable Python 2 support

set shortmess+=I            | " don't give the intro message

set scrolloff=5             | " minimal number of lines around cursor
set sidescrolloff=5         | " minimal number of chars around cursor
set nostartofline           | " keep cursor on the same offset when paging

let mapleader="\<Space>"
set hidden                  | " allows to switch a buffer with unsaved changes

set guicursor=a:blinkon0    | " Disable cursor blink in all modes
set signcolumn=yes:1        | " Always show, width 1

set mouse=a                 | " Enable mouse in all modes
set mousemodel=popup_setpos | " make mouse behave like in GUI app

set clipboard=unnamedplus   | " Set default copy buffer the same as clipboard

set virtualedit=block       | " Allow virtual editing only in Visual Block mode.

set matchpairs+=<:>         | " Characters that form pairs

set nojoinspaces            | " Insert only one space between joined lines

set nonumber                | " no line numbers
set norelativenumber        | " not even relative

set colorcolumn=100         | " visual vertical line


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
set wildignorecase             | " case is ignored when completing file names and directories

" commands history
nnoremap q: :History:<CR>

set list listchars=tab:\▸\ ,trail:·,nbsp:+ | " Display tabs and trailing spaces visually
set showbreak=↳\                           | " a soft wrap break symbol

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

" focus on new split
nnoremap <C-w>s <C-w>s<C-w>w
nnoremap <C-w>v <C-w>v<C-w>w

set winwidth=80     " minimal width of active window
set winminwidth=10  " minimal width of inactive window
set winheight=50    " minimal height of active window
set winminheight=10 " minimal height of inactive window
" }}}

" Tabs {{{
nnoremap <Leader>tt :tab split<CR>
nnoremap <Leader>tc :tabclose<CR>
nnoremap <Leader>tn :$tabnew<CR>
nnoremap <Leader>to :tabonly<CR>
for tab in range(1, 9)
  execute 'nnoremap <silent> <Leader>' . tab . ' :' . tab . 'tabnext<CR>'
endfor
" }}}

" Text Formatting {{{
set nowrap         " Don't soft wrap lines
set linebreak      " break lines at convenient points
set textwidth=79   " where to break a line

" c - auto-wrap comments (not code)
" j - join comment lines
" l - does not break existing long line in insert mode
" n - recognize number list
" o - auto add comment prefix on 'O'
" q - format comments using gq
" r - auto add comment prefix on Enter
set formatoptions=cjlnoqr
" }}}

" Theme {{{
set background=light
set termguicolors
colorscheme mycolors
" }}}

" Status line {{{
set noruler         | " line and column number of the cursor position
set laststatus=2    | " 2 - allways show status line
set noshowmode      | " dissable mode message
set title           | " update window title
set titlestring=%f  | " file name
" }}}

" Folding {{{
set foldmethod=syntax
set foldenable         | " enable folding
set foldlevelstart=99  | " but do not fold by default

" toggle current fold
nnoremap <tab> za
" }}}

" Swap Undo {{{
set noswapfile
set nobackup
set nowritebackup

" Keep undo history across sessions, by storing in file.
set undofile

augroup autosave
  autocmd!

  " |autocmd-nested| - also execute the BufRead and BufWrite autocommands
  autocmd FocusLost,BufLeave,CursorHold   * ++nested silent! :update    | " autosafe
  autocmd FocusGained,BufEnter,CursorHold * ++nested silent! :checktime | " autoread

  " jump to last known position when opening buffer
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

" VimL {{{
augroup viml_settings
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType vim setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END
" }}}

" Search and Substitute {{{

" Shows the effects of a command incrementally, as you type.
" Works for |:substitute|, |:smagic|, |:snomagic|. |hl-Substitute|
set inccommand=nosplit

" center on next match
noremap n nzz
noremap N Nzz

set gdefault   " use global substitution
set ignorecase " Ignore case when searching...
set smartcase  " ...unless we type a capital
" search in project files with selected text
vnoremap <silent> <Leader>f :<c-u>call <SID>run_interact("Rg")<CR>
nnoremap <silent> <Leader>f :Rg<CR>

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

let g:FerretMap=0
nmap <leader>* <Plug>(FerretAckWord)
vmap <leader>* y:Ack <c-r>"<cr>
nmap <leader>/ <Plug>(FerretAck)
vmap <leader>/ y:Ack <c-r>"
nmap <leader>r <Plug>(FerretAcks)

let g:FerretExecutable='rg'
let g:FerretExecutableArguments = {
  \   'rg': '
            \ --vimgrep
            \ --no-heading
            \ --smart-case
            \ --sort path
            \ --no-ignore
            \ --hidden
            \ --glob=!.git
            \ --glob=!target
            \ --glob=!node_modules
            \ --glob=!build
            \ --glob=!.clj-kondo
            \'
  \ }
" }}}

" Files navigation {{{

" 'path'
set path=
set path+=.  | " .  current file
set path+=** | " ** children subdirectories 'starstar'

" search project file by selected text
vnoremap <silent> <Leader>n :<c-u>call <SID>run_interact("Files")<CR>
nnoremap <silent> <Leader>n :Files<CR>

" search buffers by selected text
vnoremap <silent> <Leader>e :<c-u>call <SID>run_interact("Buffers")<CR>
nnoremap <silent> <Leader>e :Buffers<CR>

nnoremap <leader>N :Dirvish<CR>
let g:dirvish_mode=':sort ,^.*[\/],'

" unload current buffer
nnoremap <leader>x :bd!<cr>
" unload all buffers
nnoremap <leader>X :%bd!<cr>
" }}}

" Completion {{{
set complete-=t | " i don't use tags
set completeopt=menuone,noinsert,noselect
augroup completoin
  autocmd!
  autocmd BufEnter * call ncm2#enable_for_buffer()
augroup END
let g:ncm2#auto_popup=0 | " popup on demand
inoremap <C-N> <C-R>=ncm2#manual_trigger()<CR>
let g:ncm2#manual_complete_length=[[1,1]]
let g:ncm2#total_popup_limit=20
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
nmap yoh :GitGutterSignsToggle<CR>

set diffopt+=indent-heuristic,internal,algorithm:histogram

nmap <Leader>dw :call <SID>toggle_diff_whitespace()<CR>
function! s:toggle_diff_whitespace()
  if &diffopt =~? 'iwhite'
    setlocal diffopt-=iwhite
  else
    setlocal diffopt+=iwhite
  endif
endfunction

nmap <Leader>dsd :vnew +set\ ft=diff \| :setlocal buftype=nofile \| :r !git secret changes<CR>
nmap <Leader>dsh :!git secret hide
nmap <Leader>dsr :!git secret reveal -f

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
nnoremap <leader>ve :vsplit ~/.config/nixpkgs/home/init.vim<cr>

" source my vim config
nnoremap <leader>vs :source ~/.config/nixpkgs/home/init.vim<cr>

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
  autocmd FileType typescript,javascript,typescriptreact,javascriptreact call s:typescript_mappings()
augroup END

let g:ale_linters.javascript = ['eslint']
let g:ale_linters.typescript = ['tsserver', 'tslint']
let g:ale_fixers.javascript = ['eslint', 'prettier']
let g:ale_fixers.typescript = ['prettier']
let g:ale_fixers.typescriptreact = ['prettier']

let g:LanguageClient_rootMarkers.javascript = ['tsconfig.json', 'package.json']
let g:LanguageClient_rootMarkers.typescript = ['tsconfig.json', 'package.json']

let g:LanguageClient_serverCommands.javascript = ['typescript-language-server', '--stdio']
let g:LanguageClient_serverCommands.typescript = ['typescript-language-server', '--stdio']
let g:LanguageClient_serverCommands.javascriptreact = ['typescript-language-server', '--stdio']
let g:LanguageClient_serverCommands.typescriptreact = ['typescript-language-server', '--stdio']
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
let g:ale_rust_cargo_check_all_targets = 1
" }}}

" Python {{{
let g:LanguageClient_rootMarkers.python = ['requirements.txt', 'setup.py']
let g:LanguageClient_serverCommands.python = ['pyls']
function! s:python_mappings() abort
  nnoremap <buffer> <leader>lf  :call LanguageClient_textDocument_formatting()<CR>
  nnoremap <buffer> <C-]>       :call LanguageClient_textDocument_definition()<CR>
  nnoremap <buffer> <C-W><C-]>  :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
  nnoremap <buffer> <leader>lr  :call LanguageClient_textDocument_rename()<CR>
  nnoremap <buffer> }           :call LanguageClient_textDocument_references({'includeDeclaration': v:false})<CR>
  nnoremap <buffer> K           :call LanguageClient_textDocument_hover()<CR>
endfunction

augroup python_bindings
  autocmd!
  autocmd FileType python call s:python_mappings()
augroup END
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
let g:ale_fixers.nix = ['nixpkgs-fmt']

augroup nix_bindings
  autocmd!
  autocmd FileType nix nnoremap <buffer> <leader>lf :ALEFix<CR>
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

command! -bang -nargs=* WikiGrep
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>).' '.g:wiki_root,
      \   1,
      \   <bang>0)

let g:wiki_mappings_global={}
let g:wiki_mappings_local={}
let g:wiki_mappings_global['<plug>(wiki-journal)']='<leader>w_disable'
let g:wiki_mappings_local['<plug>(wiki-link-toggle)']='<leader>w_disable'
let g:wiki_mappings_local['<plug>(wiki-journal-copy-tonext)']='<leader>w_disable'
let g:wiki_mappings_local['<plug>(wiki-page-toc)']='<leader>w_disable'
let g:wiki_mappings_local['<plug>(wiki-link-next)']='<leader>w_disable'

let g:wiki_mappings_global['<plug>(wiki-open)']='<leader>we'
let g:wiki_mappings_global['<plug>(wiki-fzf-pages)']='<leader>wn'
nnoremap <silent> <Leader>wf :WikiGrep<CR>
nnoremap <silent> <Leader>wt :WikiFzfTags<CR>
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
  xmap      <buffer> gC         S<C-F>comment<CR> | " wrap selection in (comment ) macro
  nmap      <buffer> gce        vieo<Esc>i#_<Esc> | " prepend #_ reader macro to element
  nmap      <buffer> gcf        vafo<Esc>i#_<Esc> | " prepend #_ reader macro to form
  nmap      <buffer> gcF        vaFo<Esc>i#_<Esc> | " prepend #_ reader macro to outer form
  nmap      <buffer> <leader>tn <Plug>(iced_test_ns)
  nmap      <buffer> <leader>ta <Plug>(iced_test_all)
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
  nmap      <buffer> <Leader>vtp :VimuxPromptCommand('(time (do (refresh-all) (clojure.test/run-all-tests #"^.*{}.*-test$")))')<CR>
  nmap      <buffer> <Leader>vta :call VimuxRunCommand("(time (run-tests))")<CR>
  nmap      <buffer> <Leader>vr :call VimuxRunCommand("(time (refresh-all))")<CR>
  nmap      <buffer> <Leader>vR :call VimuxRunCommand("(time (reset-all))")<CR>

  setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

  " converts package names into file names; useful for "gf"
  setlocal includeexpr=substitute(substitute(v:fname,'\\.','/','g'),'-','_','g')
  setlocal suffixesadd=.clj
endfunction

augroup clojure_bindings
  autocmd!
  autocmd FileType clojure call s:clojure_mappings()
  autocmd FileType clojure autocmd BufWritePost <buffer> IcedRequire
augroup END

let g:ale_linters.clojure = ['clj-kondo', 'joker']

let g:iced#nrepl#connect#jack_in_command = 'LOG_LEVEL="OFF" iced repl --without-cljs'
let g:iced#buffer#stdout#mods = 'botright'

" it requires jet
let g:iced_enable_enhanced_definition_extraction = v:false

let extra_macros = ['Given', 'When', 'Then', 'And', 'let-system']
let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let'] | " Default
let g:iced#format#rule = {}
for macro in extra_macros
  let g:iced#format#rule[macro] = '[[:inner 0]]'
  let g:clojure_fuzzy_indent_patterns += ['^' . macro]
endfor
let g:clojure_syntax_keywords = {'clojureMacro': extra_macros}

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

" Markdown {{{
let g:markdown_syntax_conceal=0
let g:polyglot_disabled = ['markdown'] | " use dedicated plugin

augroup markdown_bindings
  autocmd!
  autocmd FileType markdown setlocal foldenable
  autocmd FileType makrdown setlocal foldlevelstart=0
augroup END
" }}}

" Shell {{{
augroup sh_bindings
  autocmd!
  autocmd FileType sh nnoremap <buffer> <leader>lf :ALEFix<CR>
augroup END
let g:ale_linters.sh = ['shellcheck']
let g:ale_fixers.sh = ['shfmt']
let g:ale_sh_shfmt_options = '-i=2 -sr'
" }}}

" Tmux {{{
let g:VimuxOrientation = 'h'
nmap <Leader>vi :VimuxInspectRunner<CR>
nmap <Leader>vv :VimuxRunLastCommand<CR>
nmap <Leader>vz :VimuxZoomRunner<CR>
xmap <Leader>v  "vy :call VimuxSendText(@v)\| call VimuxSendKeys("Enter")<CR>
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
  autocmd FileType c setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END
" }}}

" Curl {{{
let g:vrc_curl_opts = {
  \ '--silent': '',
  \ '--show-error': '',
  \ '--connect-timeout' : 10,
  \ '--location': '',
  \ '--include': '',
  \ '--max-time': 60,
\}

let g:vrc_auto_format_response_patterns = {
  \ 'json': 'jq',
  \ 'xml': 'grep "\S" | xmllint --format --nonet --recover -',
\}

function! s:toggle_split_body() abort
  if exists('b:vrc_split_request_body') && b:vrc_split_request_body
    let b:vrc_split_request_body = 0
  else
    let b:vrc_split_request_body = 1
  endif
  echom 'let b:vrc_split_request_body = ' . b:vrc_split_request_body
endfunction

function! s:toggle_debug() abort
  if exists('b:vrc_debug') && b:vrc_debug
    let b:vrc_debug = 0
  else
    let b:vrc_debug = 1
  endif
  echom 'let b:vrc_debug = ' . b:vrc_debug
endfunction

function! s:request() abort
  let b:vrc_output_buffer_name = escape(getline('.'), '"') . ' [' . expand('%:t') . ' @ ' . strftime('%H:%M:%S') . ']'
  call VrcQuery()
endfunction

let g:vrc_set_default_mapping = 0
augroup curl_bindings
  autocmd!
  autocmd FileType rest nnoremap <buffer> <leader>cc :call <SID>request()<CR>
  autocmd FileType rest nnoremap <buffer> <leader>cs :call <SID>toggle_split_body()<CR>
  autocmd FileType rest nnoremap <buffer> <leader>cd :call <SID>toggle_debug()<CR>
augroup END
" }}}

" DB {{{
augroup db_bindings
  autocmd!
  " select connection under the cursor
  autocmd FileType sql nnoremap <buffer> <leader>sc yiW:DB b:db = <C-R>"<CR>
  " execute statement under the cursor
  autocmd FileType sql nnoremap <buffer> <leader>ss vip:DB
              \ \set ECHO all \;
              \ \timing on \;
              \ \pset null :nil \;<CR>
  autocmd FileType sql xnoremap <buffer> <leader>ss :DB
              \ \set ECHO all \;
              \ \timing on \;
              \ \pset null :nil \;<CR>
  " execute statement under the cursor extended
  autocmd FileType sql nnoremap <buffer> <leader>sx vip:DB
              \ \x on \;
              \ \set ECHO all \;
              \ \timing on \;
              \ \pset null :nil \;<CR>
  " db schema
  autocmd FileType sql nnoremap <buffer> <leader>sd :DB \dt<CR>
  " functions shema
  autocmd FileType sql nnoremap <buffer> <leader>sf :DB \df<CR>
  " table schema under cursor
  autocmd FileType sql nnoremap <buffer> <leader>st :DB \d <C-R><C-W><CR>
  " preview table under cursor
  autocmd FileType sql nnoremap <buffer> <leader>sp :DB
              \ \x on \;
              \ \set ECHO all \;
              \ \timing on \;
              \ \pset null :nil \;
              \ select * from <C-R><C-W> limit 2\;<CR>
  " help for word under cursor
  autocmd FileType sql nnoremap <buffer> K :DB \h <C-R><C-W>
augroup END
" }}}
