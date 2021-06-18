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

" search in project files with selected text
vnoremap <silent> <Leader>f :<c-u>call <SID>run_interact("Rg")<CR>

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
" always type wrong letter
cabbrev W w

" create a scratch file with specified suffix in a name
command! -nargs=? Scratch exe 'edit '.tempname().'-'.<q-args>

" Date Time snippets {{{1
let time_format='%H:%M:%S'
let date_format='%Y-%m-%d'
nnoremap <leader>dt a<C-R>=strftime(time_format)<CR><Esc>
nnoremap <leader>dd a<C-R>=strftime(date_format)<CR><Esc>

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
endfunction

augroup clojure_bindings
  autocmd!
  autocmd FileType clojure call s:clojure_mappings()
augroup END
