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

" Projectionist {{{1
let g:projectionist_heuristics = {}
nnoremap <leader>aa :A<CR>

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

" Files navigation {{{1

" unload current buffer
nnoremap <leader>x :bd!<cr>
" unload all buffers
nnoremap <leader>X :%bd!<cr>

" jump to any word in buffer
map <silent> <leader>' <cmd>HopChar1<cr>


" BAG {{{1
" switch word case
inoremap <c-u> <esc>g~iw`]a

" always type wrong letter
cabbrev W w

" create a scratch file with specified suffix in a name
command! -nargs=? Scratch exe 'edit '.tempname().'-'.<q-args>

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
    \     . ' --remove-consecutive-blank-lines'
    \     . ' --insert-missing-whitespace',
    \   'read_temporary_file': 1,
    \}
endfunction

execute ale#fix#registry#Add('cljfmt', 'Cljfmt', ['clojure'], 'cljfmt for clj')

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

