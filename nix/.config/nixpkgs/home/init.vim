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


" search in project files with selected text
vnoremap <silent> <Leader>f :<c-u>call <SID>run_interact("Rg")<CR>


