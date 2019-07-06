" Rust {{{
augroup rust_bindings
  autocmd!
  autocmd FileType rust nmap <leader>t :!time cargo test<CR>
augroup END
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
cmap <C-F> History:<CR>
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

" LSP {{{

let g:coc_global_extensions = [
      \ 'coc-css',
      \ 'coc-eslint',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-lists',
      \ 'coc-prettier',
      \ 'coc-python',
      \ 'coc-rls',
      \ 'coc-snippets',
      \ 'coc-tslint-plugin',
      \ 'coc-tsserver',
      \ 'coc-yaml',
      \]

let g:coc_user_config = {
      \ 'coc.preferences.formatOnType': 0,
      \ 'codeLens.enable': 1,
      \ 'diagnostic.checkCurrentLine': 1,
      \ 'rust-client.cfg-test': 1,
      \ 'rust-client.disableRustup': 1,
      \ 'suggest.detailField': 'preview',
      \ 'suggest.echodocSupport': 1,
      \ 'suggest.enablePreview': 1,
      \}

let g:echodoc#enable_at_startup = 1
set cmdheight=2

nmap <leader>lp :CocList<CR>
nmap <leader>ld <Plug>(coc-definition)
nmap <leader>lt <Plug>(coc-type-definition)
nmap <leader>li <Plug>(coc-implementation)
nmap <leader>lx <Plug>(coc-references)
nmap <leader>lr <Plug>(coc-rename)
nmap <leader>lf <Plug>(coc-format)
vmap <leader>lf <Plug>(coc-format-selected)
nmap <leader>lF <Plug>(coc-fix-current)
xmap <leader>lF <Plug>(coc-fix-selected)
vmap <leader>lF <Plug>(coc-fix-selected)
nmap <leader>la <Plug>(coc-codeaction)
xmap <leader>la <Plug>(coc-codeaction-selected)
vmap <leader>la <Plug>(coc-codeaction-selected)
nmap <leader>le <Plug>(coc-diagnostic-info)
nnoremap <silent> <leader>lk :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim', 'help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction


" Map <tab> for trigger completion, completion confirm, snippet expand and jump like VSCode. >

inoremap <silent><expr> <TAB>
  \ pumvisible() ? coc#_select_confirm() :
  \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'


"Map <c-space> to trigger completion: >

inoremap <silent><expr> <c-space> coc#refresh()
" }}}

" Text Wrapping {{{
set nowrap         " Don't soft wrap lines
set linebreak      " break lines at convenient points
set textwidth=79   " where to break a line
set winwidth=80    " minimal width of active window
" navigate through display lines
noremap j gj
noremap k gk
" }}}

" Theme {{{
set background=light
colorscheme flattened_light " solarized light
" }}}

" Status line {{{
set laststatus=2
set noshowmode
let g:airline_powerline_fonts=1
let g:airline_detect_spell=0
let g:airline_theme='solarized'
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
nmap <silent> <BS> :nohlsearch<CR>
" search in project files with selected text
noremap <silent> <Leader>f "zy:call <SID>find_selected(@z)<CR>
function! s:find_selected(text)
  execute "normal :Rg \<CR>"
  call feedkeys(a:text)
endfunction
" }}}

" Files navigation {{{
map <silent> <Leader>n :Files<CR>
map <silent> <Leader>E :History<CR>
noremap <leader>e :Buffers<cr>
noremap <leader>/ :BLines<cr>
" }}}

" NetRW {{{
let g:netrw_liststyle = 3                     " tree listing
let g:netrw_sizestyle = 'H'                   " human readable
let g:netrw_hide = 1                          " hide by default
let g:netrw_banner = 0                        " turn banner off
map <leader>N :e %:h<CR>
" }}}

" Completion {{{
set completeopt=menuone,noinsert,noselect
set shortmess+=c                                  " turn off completion messages
let g:deoplete#enable_at_startup = 1              " Use deoplete.
call deoplete#custom#option('smart_case', v:true) " Use smartcase
" }}}

" markdown {{{
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

" haskell {{{

" choose formatter
let g:neoformat_enabled_haskell = ['hindent', 'stylish-haskell']

augroup haskell_bindings
  autocmd!
  autocmd FileType haskell nnoremap <buffer> <leader>lf :Neoformat<CR>
  autocmd FileType haskell nnoremap <buffer> <leader>lt :HdevtoolsType<CR>
  autocmd FileType haskell nnoremap <buffer> <leader>lk :HdevtoolsInfo<CR>
  autocmd FileType haskell nnoremap <buffer> <leader>lc :HdevtoolsClear<CR>
augroup END
" }}}

" Neoformat {{{

" Enable tab to spaces conversion globally
let g:neoformat_basic_format_retab = 1

" Enable trimming of trailing whitespace globally
let g:neoformat_basic_format_trim = 1

" Run all enabled formatters (by default Neoformat stops after the first formatter succeeds)
let g:neoformat_run_all_formatters = 1
" }}}
