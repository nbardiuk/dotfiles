scriptencoding utf-8

let mapleader="\<Space>"

lua << EOF
require('telescope').setup{
  defaults = {
    prompt_position='top',
    sorting_strategy='ascending'
  }
}
EOF

" run interactive command with selection
function! s:run_interact(command) abort
  " copy last selection into register r
  execute 'normal! gv"ry'

  " copy last selection into search register
  let @/ = @r

  " start interactive command
  execute 'normal :' . a:command . " \<CR>"

  " enter the selection into prompt
  call feedkeys(substitute(@r, "\n$", '', ''))
endfunction

" Help {{{1

" Fat finger escape |map-modes|
noremap <F1> <ESC>
noremap! <F1> <ESC>

nnoremap <silent> <leader>k <cmd>lua require('telescope.builtin').help_tags{
            \previewer = false,
            \prompt_prefix = 'Help> '}<cr>

nnoremap <silent> <leader><leader> <cmd>lua require('telescope.builtin').commands{
            \previewer = false,
            \prompt_prefix = 'Command> '}<cr>

" LSP {{{1

" Configure diagnostics
lua << EOF
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
 vim.lsp.diagnostic.on_publish_diagnostics, {
   underline = false,
   virtual_text = false,
   signs = false,
   update_in_insert = false,
 }
)
EOF

" Common LSP bindings
nnoremap <silent> <leader>la <cmd>lua require('telescope.builtin').lsp_code_actions()<cr>

" Conjure {{{1
let g:conjure#eval#result_register = 'e'
let g:conjure#log#botright = v:true

" list of filetypes to load conjure
let g:conjure#filetypes = []

" Projectionist {{{1
let g:projectionist_heuristics = {}
nnoremap <leader>aa :A<CR>

" Ale {{{1
let g:ale_fixers = { }
let g:ale_fixers['*'] = ['remove_trailing_lines', 'trim_whitespace']
let g:ale_linters = { }

" open lint error details
nnoremap L :ALEDetail<CR>
" toggle linting
nnoremap yol :ALEToggleBuffer<CR>

" Terminal {{{1
if has('nvim')

  " use Esc to exit terminal mode
  tnoremap <Esc> <C-\><C-n>
  " press Esc in terminal mode
  tnoremap <C-v><Esc> <Esc>

  " highlight cursor
  highlight! link TermCursor Cursor
  highlight! TermCursorNC guibg=red guifg=white ctermbg=1 ctermfg=15

endif


let g:loaded_python_provider = 0 | " disable Python 2 support

set shortmess+=I            | " don't give the intro message
set shortmess+=W            | " don't give 'written' when writing a file

set scrolloff=5             | " minimal number of lines around cursor
set sidescrolloff=5         | " minimal number of chars around cursor
set nostartofline           | " keep cursor on the same offset when paging

set hidden                  | " allows to switch a buffer with unsaved changes

set guicursor=a:blinkon0    | " Disable cursor blink in all modes
set mouse=a                 | " Enable mouse in all modes
set mousemodel=popup_setpos | " make mouse behave like in GUI app

set clipboard=unnamedplus   | " Set default copy buffer the same as clipboard

set virtualedit=block       | " Allow virtual editing only in Visual Block mode.

set matchpairs+=<:>         | " Characters that form pairs

set nojoinspaces            | " Insert only one space between joined lines

set signcolumn=yes:1        | " Always show, width 1
set nonumber                | " no line numbers
set norelativenumber        | " not even relative

set colorcolumn=100         | " visual vertical line


" Spelling {{{1
set spelllang=en_us  | " spell check
set nospell          | " disabled by default
set spellsuggest+=10 | " limit spell suggestions list

" turn on spell for misspells navigation
nnoremap <silent> ]s :<C-U>execute ':setlocal spell'\| normal! ]s<CR>
nnoremap <silent> ]S :<C-U>execute ':setlocal spell'\| normal! ]S<CR>
nnoremap <silent> [s :<C-U>execute ':setlocal spell'\| normal! [s<CR>
nnoremap <silent> [S :<C-U>execute ':setlocal spell'\| normal! [S<CR>

set wildmode=list:longest,full | " Commands completion
set wildignorecase             | " case is ignored when completing file names and directories

set list listchars=tab:\▸\ ,trail:·,nbsp:+ | " Display tabs and trailing spaces visually
set showbreak=↳\                           | " a soft wrap break symbol

set shell=~/.nix-profile/bin/zsh

" {{{1 Panes
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


" Text Formatting {{{1
set wrap        | " soft wrap lines
set linebreak   | " break lines at convenient points
set textwidth=0 | " do not break lines while typing

set formatoptions=
set formatoptions+=c | " auto-wrap comments (not code)
set formatoptions+=j | " join comment lines
set formatoptions+=l | " does not break existing long line in insert mode
set formatoptions+=n | " recognize number list
set formatoptions+=o | " auto add comment prefix on 'O'
set formatoptions+=q | " format comments using gq
set formatoptions+=r | " auto add comment prefix on Enter

" Theme {{{1
set background=light
set termguicolors
colorscheme mycolors

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'Normal'],
  \ 'bg+':     ['bg', 'Normal'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

let $FZF_DEFAULT_OPTS='--reverse'
let g:fzf_layout = {'window': { 'width': 0.6, 'height': 1, 'border': 'top' }}
let g:fzf_preview_window = ''

" Status line {{{1
set noruler         | " line and column number of the cursor position
set laststatus=2    | " 2 - allways show status line
set noshowmode      | " dissable mode message
set title           | " update window title
set titlestring=%f  | " file name in title

" Folding {{{1
set foldmethod=syntax
set foldenable          | " enable folding
set foldlevelstart=999  | " all folds are open

set fillchars=fold:‧
let g:crease_foldtext = { 'default': '%{repeat("  ", v:foldlevel - 1)}%t %= %l lines %f%f' }

" toggle current fold
nnoremap <BS> za

" Swap Undo {{{1
set noswapfile
set nobackup
set nowritebackup

" Keep undo history across sessions, by storing in file.
set undofile
set undolevels=10000

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

" Indentation {{{1
set smartindent
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

" VimL {{{1
augroup viml_settings
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType vim setlocal foldlevel=0
  autocmd FileType vim setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END

" Edit my vim config
nnoremap <silent> <leader>ve :vsplit ~/.config/nixpkgs/home/init.vim<cr>

" Source my vim config
nnoremap <silent> <leader>vs :so ~/.config/nixpkgs/home/init.vim<cr>

" eXecute selection as vim command
nnoremap <silent> <leader>vx "vyy:@v<cr>

" Search and Substitute {{{1

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

" search in current buffer with selected text
vnoremap / y/\V<c-r>"<cr>
nnoremap / /\v

" paste escaped java/javascript string
nmap <leader>jp :call setreg('e', json_encode(@+))\| normal "ep<CR>
xmap <leader>jp :<C-U>call setreg('e', json_encode(@+))\| normal gv"ep<CR>
nmap <leader>jP :call setreg('e', json_encode(@+))\| normal "eP<CR>
" yank unescaped java/javascript string
xmap <leader>jy :<C-U>execute 'normal! gv"ey'\| :call setreg('+', json_decode(@e))<CR>


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
            \ --glob=!.cpcache
            \'
  \ }

" Files navigation {{{1

" 'path'
set path=
set path+=.  | " .  current file
set path+=** | " ** children subdirectories 'starstar'

nnoremap <silent> <leader>n <cmd>lua require("telescope.builtin").find_files{
            \previewer = false,
            \find_command = {
            \"fd",
            \"--no-ignore",
            \"--hidden",
            \"--exclude", ".git",
            \"--exclude", "target",
            \"--exclude", "node_modules",
            \"--exclude", "build",
            \"--exclude", ".clj-kondo",
            \"--exclude", ".cpcache",
            \"--exclude", ".venv"
            \},
            \prompt_prefix = 'Files> '}<CR>

nnoremap <silent> <leader>e <cmd>lua require('telescope.builtin').buffers{
            \previewer = false,
            \prompt_prefix = 'Buf> ',
            \sort_lastused = true,
            \ignore_current_buffer = true,
            \}<cr>


let g:loaded_netrwPlugin = 1
let g:dirvish_mode=':sort ,^.*[\/],'

" unload current buffer
nnoremap <leader>x :bd!<cr>
" unload all buffers
nnoremap <leader>X :%bd!<cr>

" jump to any word in buffer
map <silent> <leader>' <cmd>HopChar1<cr>

" Completion {{{1
set complete-=t | " i don't use tags
set completeopt=menuone,noselect
set shortmess+=c  | " turn off completion messages

let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:false
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.omni = v:true

inoremap <silent><expr> <C-N> compe#complete()

" Git {{{1

" If this many milliseconds nothing is typed the swap file will be written to disk speedsup gitgutter
set updatetime=100

let g:gitgutter_map_keys = 0
nmap <Leader>gd :Gdiffsplit<CR>
nmap <Leader>gs :Git<CR>
nmap <Leader>gl :Gclog<CR>
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
function! s:toggle_diff_whitespace() abort
  if &diffopt =~? 'iwhite'
    setlocal diffopt-=iwhite
  else
    setlocal diffopt+=iwhite
  endif
endfunction

" BAG {{{1
" switch word case
inoremap <c-u> <esc>g~iw`]a

" always type wrong letter
cabbrev W w

" create a scratch file with specified suffix in a name
command! -nargs=? Scratch exe 'edit '.tempname().'-'.<q-args>

" Json {{{1
augroup json_bindings
  autocmd!
  autocmd FileType json nnoremap <buffer> <leader>lf :ALEFix<CR>
augroup END
let g:ale_fixers.json = ['jq']
let g:ale_json_jq_options = '--monochrome-output --indent 2'

" XML {{{1
augroup xml_bindings
  autocmd!
  autocmd FileType xml nnoremap <buffer> <leader>lf :ALEFix<CR>
augroup END
let g:ale_fixers.xml = ['xmllint']
let g:ale_linters.xml = ['xmllint']
let g:ale_xml_xmllint_options = '--format --nonet --recover -'

" SQL {{{1
augroup sql_bindings
  autocmd!
  autocmd FileType sql nnoremap <buffer> <leader>lf :ALEFix<CR>
augroup END
let g:ale_fixers.sql = ['pgformatter']
let g:ale_linters.sql = ['sqlint']
let g:ale_sql_pgformatter_options = '--spaces 4 --comma-break'

" JavaScript/Typescript {{{1
function! s:typescript_mappings() abort
  nnoremap <buffer> <leader>lf  :ALEFix<CR>
  nnoremap <buffer> gd          :lua vim.lsp.buf.definition()<CR>
  nnoremap <buffer> <leader>lr  :lua vim.lsp.buf.rename()<CR>
  nnoremap <buffer> <leader>lt  :lua vim.lsp.buf.type_definition()<CR>
  nnoremap <buffer> }           :lua vim.lsp.buf.references()<CR>
  nnoremap <buffer> K           :lua vim.lsp.buf.hover()<CR>
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

lua require'lspconfig'.tsserver.setup{}

" CSS/SASS {{{1
let g:ale_linters.scss = ['stylelint']
let g:ale_linters.css = ['stylelint']
let g:ale_fixers.scss = ['prettier', 'stylelint']
let g:ale_fixers.css = ['prettier', 'stylelint']
augroup css_bindings
  autocmd!
  autocmd FileType css,scss nnoremap <buffer> <leader>lf :ALEFix<CR>
augroup END

" Rust {{{1
function! s:rust_mappings() abort
  nnoremap <buffer> <leader>lf  :ALEFix<CR>
  nnoremap <buffer> gd          :lua vim.lsp.buf.definition()<CR>
  nnoremap <buffer> <leader>lr  :lua vim.lsp.buf.rename()<CR>
  nnoremap <buffer> }           :lua vim.lsp.buf.references()<CR>
  nnoremap <buffer> K           :lua vim.lsp.buf.hover()<CR>
endfunction
augroup rust_bindings
  autocmd!
  autocmd FileType rust call s:rust_mappings()
augroup END

lua require'lspconfig'.rls.setup{}

let g:ale_fixers.rust = ['rustfmt']
let g:ale_linters.rust = ['cargo']
let g:ale_rust_cargo_use_clippy = 1
let g:ale_rust_cargo_check_all_targets = 1

" Python {{{1
lua require'lspconfig'.pyls.setup{}
function! s:python_mappings() abort
  nnoremap <buffer> <leader>lf  :lua vim.lsp.buf.formatting()<CR>
  nnoremap <buffer> gd          :lua vim.lsp.buf.definition()<CR>
  nnoremap <buffer> <leader>lr  :lua vim.lsp.buf.rename()<CR>
  nnoremap <buffer> }           :lua vim.lsp.buf.references()<CR>
  nnoremap <buffer> K           :lua vim.lsp.buf.hover()<CR>
endfunction

augroup python_bindings
  autocmd!
  autocmd FileType python call s:python_mappings()
augroup END

" Haskell {{{1
lua require'lspconfig'.ghcide.setup{}

let g:ale_fixers.haskell = ['hindent']

function! s:haskell_mappings() abort
  nnoremap <buffer> <leader>lf  :ALEFix<CR>
  nnoremap <buffer> K           :lua vim.lsp.buf.hover()<CR>
  nnoremap <buffer> gd          :lua vim.lsp.buf.definition()<CR>
endfunction
augroup haskell_bindings
  autocmd!
  autocmd FileType haskell call s:haskell_mappings()
augroup END

" Nix {{{1
let g:ale_linters.nix = ['nix']
let g:ale_fixers.nix = ['nixpkgs-fmt']

augroup nix_bindings
  autocmd!
  autocmd FileType nix nnoremap <buffer> <leader>lf :ALEFix<CR>
augroup END

" Wiki {{{1
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
let g:wiki_mappings_local['<plug>(wiki-link-toggle)']='<leader>w_disable'
let g:wiki_mappings_local['<plug>(wiki-journal-copy-tonext)']='<leader>w_disable'
let g:wiki_mappings_local['<plug>(wiki-page-toc)']='<leader>w_disable'
let g:wiki_mappings_local['<plug>(wiki-link-next)']='<leader>w_disable'
let g:wiki_mappings_local['<plug>(wiki-link-return)']='<leader>w_disable'

let g:wiki_mappings_global['<plug>(wiki-open)']='<leader>we'
nnoremap <silent> <leader>wn <cmd>lua require("telescope.builtin").find_files{
            \previewer = false,
            \find_command = {
            \"fd",
            \"--exclude", ".stversions",
            \"--exclude", ".stfoldre",
            \},
            \cwd = vim.g.wiki_root,
            \prompt_prefix = 'Wiki> '}<CR>

" Date Time snippets {{{1
let time_format='%H:%M:%S'
let date_format='%Y-%m-%d'
nnoremap <leader>dt a<C-R>=strftime(time_format)<CR><Esc>
nnoremap <leader>dd a<C-R>=strftime(date_format)<CR><Esc>
nnoremap <leader>dz :r!date --utc --iso-8601=seconds<CR><Esc>
xnoremap <leader>dz "zy:r!date --utc --iso-8601=seconds --date='<C-R>z'<CR><Esc>
nnoremap <leader>ds :r!date +'\%s'<CR><Esc>
xnoremap <leader>ds "zy:r!date +'\%s' --date='<C-R>z'<CR><Esc>

" sexp {{{1
function! s:sexp_mappings() abort

  nmap <buffer> doe <Plug>(sexp_raise_element)
  nmap <buffer> dof <Plug>(sexp_raise_list)

  " widens scope of parent expression
  nmap <buffer> yc <Plug>(sexp_convolute)

  " emulate text object for pair of elements
  " i.e. key/value binding/expr test/expr
  "
  "   pair forward
  xmap <buffer> ip <Plug>(sexp_inner_element)<Plug>(sexp_move_to_next_element_tail)
  omap <buffer> ip :<C-U>normal vip<CR>
  "   pair backward
  xmap <buffer> iP <Plug>(sexp_inner_element)o<Plug>(sexp_move_to_prev_element_head)
  omap <buffer> iP :<C-U>normal viP<CR>

  "  swap pair
  nmap <buffer> >p vip>eo<Esc>
  nmap <buffer> <p vip<eo<Esc>

  xmap <buffer> >e <Plug>(sexp_swap_element_forward)
  xmap <buffer> <e <Plug>(sexp_swap_element_backward)
  xmap <buffer> >f <Plug>(sexp_swap_list_forward)
  xmap <buffer> <f <Plug>(sexp_swap_list_backward)

endfunction

augroup more_sexp_mappings
  autocmd!
  execute 'autocmd FileType' get(g:, 'sexp_filetypes', 'lisp,scheme,clojure') 'call s:sexp_mappings()'
augroup END

" Scheme {{{1

function! s:scm_ignore(type) abort
  " navigate to beginning of a text object
  silent normal! `[

  " prepend sexp comment
  silent normal! i#;
endfunction

function! s:scheme_mappings() abort
  nmap      <buffer> <leader>cu :let s=@/<CR>l?\v(#;)+<CR>dgn:let @/=s<CR>
  nmap      <buffer> <leader>c  :<C-U>set opfunc=<SID>scm_ignore<CR>g@
  xmap      <buffer> <leader>c  :<C-U>set opfunc=<SID>scm_ignore<CR>g@`<
  nmap      <buffer> <leader>cc :<C-U>set opfunc=<SID>scm_ignore<CR>g@aF

  nmap      <buffer> <leader>pp <Plug>SlimeMotionSend<Plug>(sexp_outer_top_list)``
  nnoremap  <buffer> K          :SlimeSend1 (pp <C-R><C-W>)<CR>

  nmap      <buffer> <leader>lf ggvG=``
endfunction

augroup scheme_bindings
  autocmd!
  autocmd FileType scheme call s:scheme_mappings()
augroup END

" Clojure {{{1

function! s:clj_ignore(type) abort
  " navigate to beginning of a text object
  silent normal! `[

  " prepend reader macro
  silent normal! i#_
endfunction

function! s:clojure_mappings() abort
  nmap      <buffer> <leader>cu :let s=@/<CR>l?\v(#_)+<CR>dgn:let @/=s<CR>
  nmap      <buffer> <leader>c  :<C-U>set opfunc=<SID>clj_ignore<CR>g@
  xmap      <buffer> <leader>c  :<C-U>set opfunc=<SID>clj_ignore<CR>g@`<
  nmap      <buffer> <leader>cc :<C-U>set opfunc=<SID>clj_ignore<CR>g@aF

  nmap      <buffer> <leader>tn <Plug>(iced_test_ns)
  nmap      <buffer> <leader>ta <Plug>(iced_test_all)
  nnoremap  <buffer> <leader>to :IcedTestBufferOpen<CR>

  nmap      <buffer> <leader>oo <Plug>(iced_stdout_buffer_toggle)
  nmap      <buffer> <leader>oc <Plug>(iced_stdout_buffer_clear)

  nmap      <buffer> <leader>lf <Plug>(iced_format_all)

  nmap      <buffer> <leader>lr <Plug>(iced_rename_symbol)

  nnoremap  <buffer> K          :IcedDocumentPopupOpen<CR>
  nnoremap  <buffer> <leader>cd :IcedClojureDocsOpen<CR>

  nnoremap  <buffer> gd         :IcedDefJump<CR>
  nnoremap  <buffer> }          :IcedBrowseReferences<CR>

  nmap      <buffer> <leader>p  "e<Plug>(iced_eval)
  xmap      <buffer> <leader>p  <esc>`<"e:call iced#operation#setup_eval()<CR>g@v`>
  nmap      <buffer> <leader>pp <Plug>(iced_eval_outer_top_list)
  nmap      <buffer> <leader>pc A ;; => <Esc>"ep

  setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

  " converts package names into file names; useful for "gf"
  setlocal includeexpr=substitute(substitute(v:fname,'\\.','/','g'),'-','_','g')
  setlocal suffixesadd=.clj
endfunction

augroup clojure_bindings
  autocmd!
  autocmd FileType clojure call s:clojure_mappings()
augroup END

let g:ale_linters.clojure = ['clj-kondo']

let g:iced#buffer#stdout#mods = 'botright'
let g:iced#buffer#stdout#enable_notify = v:false

" it requires jet
let g:iced_enable_enhanced_definition_extraction = v:false

" static analysis to speedup navigation/refactorings
let g:iced_enable_clj_kondo_analysis = v:true
let g:iced_enable_clj_kondo_local_analysis = v:true

" use clojure syntax for indentation
let g:iced_enable_auto_indent = v:false
let g:clojure_fuzzy_indent = v:true

let extra_macros = ['Given', 'When', 'Then', 'And', 'let-system']
let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let'] | " Default
let g:iced#format#rule = {}
for macro in extra_macros
  let g:iced#format#rule[macro] = '[[:inner 0]]'
  let g:clojure_fuzzy_indent_patterns += ['^' . macro]
endfor
let g:clojure_syntax_keywords = {'clojureMacro': extra_macros}

" use clojure.vim package directly
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

" Markdown {{{1
let g:markdown_syntax_conceal=0
let g:polyglot_disabled = ['markdown'] | " use dedicated plugin
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_override_foldtext = 0

" Shell {{{1
augroup sh_bindings
  autocmd!
  autocmd FileType sh nnoremap <buffer> <leader>lf :ALEFix<CR>
augroup END
let g:ale_linters.sh = ['shellcheck']
let g:ale_fixers.sh = ['shfmt']
let g:ale_sh_shfmt_options = '-i=2 -sr'

" C {{{1
lua require'lspconfig'.ccls.setup{}

let g:ale_fixers.c = ['clang-format', 'clangtidy']
let g:ale_linters.c = ['clang']

function! s:c_mappings() abort
  vnoremap <buffer> =           :lua vim.lsp.buf.range_formatting()<CR>
  nnoremap <buffer> <leader>lf  :ALEFix<CR>
  nnoremap <buffer> K           :lua vim.lsp.buf.hover()<CR>
  nnoremap <buffer> gd          :lua vim.lsp.buf.definition()<CR>
  nnoremap <buffer> <leader>lr  :lua vim.lsp.buf.rename()<CR>
  nnoremap <buffer> }           :lua vim.lsp.buf.references()<CR>
endfunction
augroup c_bindings
  autocmd!
  autocmd FileType c call s:c_mappings()
  autocmd FileType c setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END

" Curl {{{1
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
  let b:vrc_output_buffer_name = escape(getline('.'), '"')
              \. ' [' . expand('%:t') . ' @ ' . strftime('%H:%M:%S') . ']'
  call VrcQuery()
endfunction

let g:vrc_set_default_mapping = 0
augroup curl_bindings
  autocmd!
  autocmd FileType rest nnoremap <buffer> <leader>cc :call <SID>request()<CR>
  autocmd FileType rest nnoremap <buffer> <leader>cs :call <SID>toggle_split_body()<CR>
  autocmd FileType rest nnoremap <buffer> <leader>cd :call <SID>toggle_debug()<CR>
augroup END

" Slime {{{1

let g:slime_target = 'tmux'
let g:slime_paste_file = tempname()
let g:slime_default_config = {}
let g:slime_default_config.socket_name = 'default'
let g:slime_default_config.target_pane = ':.2'

let g:slime_no_mappings = 1
xmap <leader>s  <Plug>SlimeRegionSend
nmap <leader>s  <Plug>SlimeMotionSend
nmap <leader>ss <Plug>SlimeLineSend
nmap <leader>sc <Plug>SlimeConfig

xmap <leader>sy "sy
nmap <leader>sp :SlimeSend1 <C-R>s<CR>

" Bang {{{1
nmap <silent> <leader>tj :silent !firefox https://jira.inbcu.com/browse/<cfile><CR>
nmap <silent> <leader>tc :silent !firefox https://clojuredocs.org/search\?q=<cword><CR>
nmap <silent> <leader>ts :silent !firefox https://duckduckgo.com/\?q=<cword><CR>
nmap <silent> <leader>tp :silent !firefox https://postgresql.org/search/\?q=<cword><CR>
