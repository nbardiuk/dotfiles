scriptencoding utf-8

let g:aniseed#env = v:true

let mapleader="\<Space>"

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


" Conjure {{{1
let g:conjure#eval#result_register = 'e'
let g:conjure#log#botright = v:true

" list of filetypes to load conjure
let g:conjure#filetypes = ['clojure', 'fennel']

" Projectionist {{{1
let g:projectionist_heuristics = {}
nnoremap <leader>aa :A<CR>

" Ale {{{1
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


" Spelling {{{1
" turn on spell for misspells navigation
nnoremap <silent> ]s :<C-U>execute ':setlocal spell'\| normal! ]s<CR>
nnoremap <silent> ]S :<C-U>execute ':setlocal spell'\| normal! ]S<CR>
nnoremap <silent> [s :<C-U>execute ':setlocal spell'\| normal! [s<CR>
nnoremap <silent> [S :<C-U>execute ':setlocal spell'\| normal! [S<CR>


" {{{1 Panes
augroup panes
  autocmd!
  " automatically rebalance windows on vim resize
  autocmd VimResized * :wincmd =
augroup END

" focus on new split
nnoremap <C-w>s <C-w>s<C-w>w
nnoremap <C-w>v <C-w>v<C-w>w

" Folding {{{1
" toggle current fold
nnoremap <BS> za

" Swap Undo {{{1
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

" center on next match
noremap n nzz
noremap N Nzz

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

" Files navigation {{{1

" unload current buffer
nnoremap <leader>x :bd!<cr>
" unload all buffers
nnoremap <leader>X :%bd!<cr>

" jump to any word in buffer
map <silent> <leader>' <cmd>HopChar1<cr>

" Git {{{1

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

" Yaml {{{1
augroup yaml_bindings
  autocmd!
  autocmd FileType yaml nnoremap <buffer> <leader>lf :ALEFix<CR>
augroup END

" Terraform {{{1
augroup tf_bindings
  autocmd!
  autocmd FileType terraform nnoremap <buffer> <leader>lf :ALEFix<CR>
  autocmd FileType hcl nnoremap <buffer> <leader>lf :ALEFix<CR>
augroup END

" XML {{{1
augroup xml_bindings
  autocmd!
  autocmd FileType xml nnoremap <buffer> <leader>lf :ALEFix<CR>
augroup END

" SQL {{{1
augroup sql_bindings
  autocmd!
  autocmd FileType sql nnoremap <buffer> <leader>lf :ALEFix<CR>
augroup END

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

" CSS/SASS {{{1
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

" Python {{{1
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
augroup nix_bindings
  autocmd!
  autocmd FileType nix nnoremap <buffer> <leader>lf :ALEFix<CR>
augroup END

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

let g:sexp_filetypes = 'clojure,scheme,lisp,fennel'
augroup more_sexp_mappings
  autocmd!
  execute 'autocmd FileType' get(g:, 'sexp_filetypes') 'call s:sexp_mappings()'
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

let g:lispdocs_mappings = 0

function! s:clj_ignore(type) abort
  " navigate to beginning of a text object
  silent normal! `[

  " prepend reader macro
  silent normal! i#_
endfunction

function! s:switch_conjure_state() abort
  call fzf#run(fzf#wrap('conjure_state', {
          \ 'options': '--prompt "repl > "',
          \ 'source': 'find -name .nrepl-port | xargs dirname',
          \ 'sink': {v -> execute("ConjureClientState '" . join(reverse(split(v[1:], "/"))[:2], ".") . "'")},
          \ }))
endfunction

function! s:clojure_mappings() abort

  nmap  <buffer> <localleader>cc :call <SID>switch_conjure_state()<CR>

  nmap  <buffer> <leader>cu :let s=@/<CR>l?\v(#_)+<CR>dgn:let @/=s<CR>
  nmap  <buffer> <leader>cu :let s=@/<CR>l?\v(#_)+<CR>dgn:let @/=s<CR>
  nmap  <buffer> <leader>c  :<C-U>set opfunc=<SID>clj_ignore<CR>g@
  xmap  <buffer> <leader>c  :<C-U>set opfunc=<SID>clj_ignore<CR>g@`<
  nmap  <buffer> <leader>cc :<C-U>set opfunc=<SID>clj_ignore<CR>g@aF

  nmap  <buffer> <leader>lf :ALEFix<CR>

  nmap  <buffer> K          <localleader>K
  nmap  <buffer> <leader>K  :lua require'lispdocs'.split()<cr>
  nmap  <buffer> gd         <localleader>gd

  setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

  " converts package names into file names; useful for "gf"
  setlocal includeexpr=substitute(substitute(v:fname,'\\.','/','g'),'-','_','g')
  setlocal suffixesadd=.clj
endfunction

augroup clojure_bindings
  autocmd!
  autocmd FileType clojure call s:clojure_mappings()
augroup END

function! Cljfmt(buffer) abort
    return {
    \   'command': 'cljfmt fix %t'
    \     . ' --indents ~/.config/cljfmt/indentation.edn'
    \     . ' --remove-surrounding-whitespace'
    \     . ' --remove-trailing-whitespace'
    \     . ' --no-remove-consecutive-blank-lines'
    \     . ' --insert-missing-whitespace',
    \   'read_temporary_file': 1,
    \}
endfunction

execute ale#fix#registry#Add('cljfmt', 'Cljfmt', ['clojure'], 'cljfmt for clj')

" use clojure syntax for indentation
let g:clojure_fuzzy_indent = v:true

let extra_macros = ['Given', 'When', 'Then', 'And', 'let-system']
let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let'] | " Default
for macro in extra_macros
  let g:clojure_fuzzy_indent_patterns += ['^' . macro]
endfor
let g:clojure_syntax_keywords = {'clojureMacro': extra_macros}

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

let g:conjure#client#clojure#nrepl#test#current_form_names = ['deftest', 'def-integration-test']
let g:conjure#client#clojure#nrepl#test#runner = 'kaocha'

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

" C {{{1
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
