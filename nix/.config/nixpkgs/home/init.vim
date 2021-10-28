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


" search in project files with selected text
vnoremap <silent> <Leader>f :<c-u>call <SID>run_interact("Rg")<CR>


