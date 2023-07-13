(local autopairs (require :nvim-autopairs))
(local Comment (require :Comment))
(local c (require :nfnl.core))
(local cmp (require :cmp))
(local cmp_nvim_lsp (require :cmp_nvim_lsp))
(local dressing (require :dressing))
(local fidget (require :fidget))
(local lightspeed (require :lightspeed))
(local lspconfig (require :lspconfig))
(local lspkind (require :lspkind))
(local lualine (require :lualine))
(local luasnip (require :luasnip))
(local null-ls (require :null-ls))
(local oil (require :oil))
(local surround (require :nvim-surround))
(local tel (require :telescope.builtin))
(local telescope (require :telescope))
(local themes (require :telescope.themes))
(local tree-context (require :treesitter-context))
(local tree-conf (require :nvim-treesitter.configs))
(local other (require :other-nvim))


(tree-context.setup
  {:enable true
   :separator "·"})


(macro au [group event pattern ...]
  `(vim.api.nvim_create_autocmd
     ,event
     {:group (vim.api.nvim_create_augroup ,(tostring group) {:clear true})
      :pattern ,pattern
      :callback (fn [] (do ,...) nil)
      :nested true ;; autocmd-nested
      }))

; (vim.opt.runtimepath:append "~/.local/share/nvim/treesitter")
(tree-conf.setup
  {:auto_install false
   ; :parser_install_dir "~/.local/share/nvim/treesitter"
   :indent {:enable true}
   :highlight {:enable true}
   :textobjects {:select {:enable true
                          :lookahead true
                          :keymaps {"aa" "@parameter.outer"
                                    "ia" "@parameter.inner"
                                    "ac" "@comment.outer"
                                    "as" "@statement.outer"}}
                 :swap {:enable true
                        :swap_next {">a" "@parameter.inner"}
                        :swap_previous {"<lt>a" "@parameter.inner"}}}

   :matchup {:enable true}})


(set vim.g.mapleader " ")
(set vim.g.maplocalleader "\t")

(fn indexed->named [keys tbl]
  (for [index (length tbl) 1 -1]
    (let [key (. tbl index)]
      (match (. keys key)
        value (doto tbl
                    (table.remove index)
                    (tset key value)))))
  tbl)

(fn keymap [m args]
  (let [options {:buffer true :silent true :remap true :noremap true}
        args (indexed->named options args)
        lhs (. args 1)
        rhs (. args 2)
        opts (c.select-keys args (c.keys options))]
    (vim.keymap.set m lhs rhs opts)))

(fn nmap     [...] (keymap :n [:remap   ...]))
(fn nnoremap [...] (keymap :n [:noremap ...]))
(fn omap     [...] (keymap :o [:remap   ...]))
(fn tnoremap [...] (keymap :t [:noremap ...]))
(fn vnoremap [...] (keymap :v [:noremap ...]))
(fn xmap     [...] (keymap :x [:remap   ...]))
(fn xnoremap [...] (keymap :x [:noremap ...]))

(local bottom-height 15)

(telescope.setup
  {:defaults (themes.get_ivy
               {:layout_config {:height bottom-height}
                :preview false})
   :extensions {:fzf {:fuzzy true
                      :override_generic_sorter true
                      :override_file_sorter true
                      :case_mode :smart_case}}})
(telescope.load_extension :fzf)

(nnoremap :<Leader>r tel.resume)
(nnoremap :<Leader>k tel.help_tags)
(nnoremap :<Leader><Leader> tel.commands)
(nnoremap :<Leader>n #(tel.find_files {:find_command [:fd :--hidden :--exclude :.git]}))
(nnoremap :<Leader>e #(tel.buffers {:sort_lastused true
                                    :ignore_current_buffer false}))

(dressing.setup
  {:select {:telescope (themes.get_ivy {:layout_config {:height bottom-height}})}})

(cmp.setup
  {:sources [{:name :nvim_lsp}
             {:name :conjure}
             {:name :treesitter}
             {:name :vim-dadbod-completion}
             {:name :lausnip}
             {:name :path}
             {:name :buffer
              :keyword_length 5
              :options {:get_bufnrs #(vim.api.nvim_list_bufs)}}
             {:name :spell
              :keyword_length 5}]
   :formatting {:format
                (lspkind.cmp_format
                  {:mode :symbol_text
                   :symbol_map (collect [k (pairs lspkind.presets.default)] (values k ""))
                   :menu {:nvim_lsp "[lsp]"
                          :conjure "[conj]"
                          :vim-dadbod-completion "[db]"
                          :treesitter "[tree]"
                          :luasnip "[snip]"
                          :path "[path]"
                          :buffer "[buf]"
                          :spell "[spell]"}})}
   :snippet {:expand #(luasnip.lsp_expand (. $1 :body))}
   :mapping {"<C-n>"   (cmp.mapping #(if
                                       (cmp.visible)                (cmp.select_next_item)
                                       (luasnip.expand_or_jumpable) (luasnip.expand_or_jump)
                                       ($1)) [:i :s])
             "<C-p>"   (cmp.mapping #(if
                                       (cmp.visible)         (cmp.select_prev_item)
                                       (luasnip.jumpable -1) (luasnip.jump -1)
                                       ($1)) [:i :s])
             "<C-d>"   (cmp.mapping.scroll_docs -4)
             "<C-u>"   (cmp.mapping.scroll_docs 4)
             "<C-e>"   (cmp.mapping.close)
             "<Space>" (cmp.mapping.confirm)}})

(local lsp-capabilities
  (vim.tbl_deep_extend
    :force
    (vim.lsp.protocol.make_client_capabilities)
    (cmp_nvim_lsp.default_capabilities)
    {:workspace {:workspaceEdit {:documentChanges true}}}))

(surround.setup {})

(set vim.opt.completeopt [:menu :menuone :noselect])
(vim.opt.complete:remove :t)  ; I don't use tags
(vim.opt.shortmess:append :c) ; turn off completion messages

(vim.opt.shortmess:append :I) ; don't give the intro message
(vim.opt.shortmess:append :W) ; don't give 'written' when writing a file

(set vim.opt.scrolloff 5)       ; minimal number of lines around cursor
(set vim.opt.sidescrolloff 5)  ; minimal number of chars around cursor
(set vim.opt.startofline false) ; keep cursor on the same offset when paging

(set vim.opt.guicursor "a:blinkon0")   ; disable cursor blink in all modes
(set vim.opt.mouse :a)                 ; enable mouse in all modes
(set vim.opt.mousemodel :popup_setpos) ; make mouse behave like in GUI app

(set vim.opt.clipboard :unnamedplus) ; set default copy register the same as clipboard
(au yank :TextYankPost :* (vim.highlight.on_yank {:higroup :Visual}))

(set vim.opt.virtualedit :block) ; allow virtual editing only in Visual Block mode.

(vim.opt.matchpairs:append "<:>") ; characters that form pairs

(set vim.opt.joinspaces false) ; insert only one space between joined lines

(set vim.opt.signcolumn "yes:1")   ; always show  signcolumn  with width 1
(set vim.opt.number false)         ; no line numbers
(set vim.opt.relativenumber false) ; not even relative
(set vim.opt.colorcolumn [100])    ; visual vertical line


;; Spelling
(set vim.opt.spelllang :en_us)
(set vim.opt.spell false)
(vim.opt.spellsuggest:append (.. "" bottom-height)) ; limit spell suggestions list
(nnoremap :silent "]s" "<Cmd>execute ':setlocal spell'| normal! ]s<CR>")
(nnoremap :silent "]S" "<Cmd>execute ':setlocal spell'| normal! ]S<CR>")
(nnoremap :silent "[s" "<Cmd>execute ':setlocal spell'| normal! [s<CR>")
(nnoremap :silent "[S" "<Cmd>execute ':setlocal spell'| normal! [S<CR>")


(set vim.opt.wildmode ["list:longest" :full]) ; commands completion
(set vim.opt.wildignorecase true)          ; case is ignored when completing file names and directories

(set vim.opt.list true)
(set vim.opt.listchars {:trail "·" :tab "▸ " :nbsp "+"}) ; display tabs and trailing spaces visually
(set vim.opt.showbreak "↳ ")                             ; a soft wrap break symbol

(set vim.opt.shell "/usr/bin/env zsh")


;; Panes
(au autoresize :VimResized :* (vim.cmd.wincmd "="))
(set vim.opt.winwidth 80)    ; minimal width of active window
(set vim.opt.winminwidth 8)  ; minimal width of inactive window
(set vim.opt.winheight 24)   ; minimal height of active window
(set vim.opt.winminheight 2) ; minimal height of inactive window
(set vim.opt.splitright true)
(set vim.opt.splitbelow true)

(nnoremap :<Leader>x "<Cmd>bd!<CR>") ; close current buffer
(nnoremap :<Leader>X "<Cmd>%bd!<CR>") ; close all buffers


(set vim.opt.wrap true)      ; soft wrap lines
(set vim.opt.linebreak true) ; break lines at convenient points
(set vim.opt.textwidth 0)    ; do not break lines while typing
(set vim.opt.formatoptions
     (..
       :c                    ; auto-wrap comments (not code)
       :j                    ; join comment lines
       :l                    ; does not break existing long line in insert mode
       :n                    ; recognize number list
       :o                    ; auto add comment prefix on 'O'
       :q                    ; format comments using gq
       :r                    ; auto add comment prefix on Enter
       ))


(set vim.opt.background :light)
(set vim.opt.termguicolors true)
(do
  (vim.cmd "colorscheme grey")

  (let [to-clear [:Identifier
                  :Function
                  :Statement
                  :Conditional
                  :Repeat
                  :Label
                  :Operator
                  :Exception
                  :PreProc
                  :Include
                  :Define
                  :Macro
                  :PreCondit
                  :Type
                  :StorageClass
                  :Structure
                  :Typedef
                  :Special
                  :Tag]]
    (each [_ group (pairs to-clear)]
      (vim.cmd (.. "highlight clear " group))))

  (let [to-link {:Delimiter :NonText
                 :Comment :Directory
                 :Whitespace :VertSplit
                 :TermCursorNC :Cursor
                 :Boolean :Yellow
                 "@symbol" :Keyword
                 "@lsp.type.namespace" "@namespace"
                 "@lsp.type.type" "@type"
                 "@lsp.type.class" "@type"
                 "@lsp.type.enum" "@type"
                 "@lsp.type.interface" "@type"
                 "@lsp.type.struct" "@structure"
                 "@lsp.type.parameter" "@parameter"
                 "@lsp.type.variable" "@variable"
                 "@lsp.type.property" "@property"
                 "@lsp.type.enumMember" "@constant"
                 "@lsp.type.function" "@function"
                 "@lsp.type.method" "@method"
                 "@lsp.type.macro" "@macro"
                 "@lsp.type.decorator" "@function"
                 :OilDir :Directory
                 :OilLink :Yellow}]
    (each [src dest (pairs to-link)]
      (vim.api.nvim_set_hl 0 src {:link dest :default false}))))


(set vim.opt.ruler false)      ; line and column number of the cursor position
(set vim.opt.laststatus 3)     ; 3 - only one
(set vim.opt.showmode false)   ; disable mode message
(set vim.opt.title true)       ; update window title
(set vim.opt.titlestring "%f") ; file name in title
(set vim.opt.winbar "%f")      ; file name in buffer title

(lualine.setup
  {:options {:icons_enabled false
             :globalstatus true}})

;; Folding
(set vim.opt.foldmethod :expr)
(set vim.opt.foldexpr "v:lua.vim.treesitter.foldexpr()")
(set vim.opt.foldenable true)    ; enable folding
(set vim.opt.foldlevelstart 999) ; all folds are open
(set vim.opt.fillchars "fold:‧")
(nnoremap :<BS> :za) ; toggle current fold

;; Swap Undo
(set vim.opt.swapfile false)
(set vim.opt.backup false)
(set vim.opt.writebackup false)

; Keep undo history across sessions, by storing in file.
(set vim.opt.undofile true)
(set vim.opt.undolevels 10000)

(set vim.opt.smartindent true)
(set vim.opt.shiftwidth 4)
(set vim.opt.softtabstop 4)
(set vim.opt.tabstop 4)
(set vim.opt.expandtab true)


; Shows the effects of a command incrementally, as you type.
; Works for |:substitute|, |:smagic|, |:snomagic|. |hl-Substitute|
(set vim.opt.inccommand :nosplit)


;; Search
(set vim.opt.gdefault true)   ; use global substitution
(set vim.opt.ignorecase true) ; Ignore case when searching...
(set vim.opt.smartcase true)  ; ...unless we type a capital

;; center on next match
(nnoremap :n :nzz)
(nnoremap :N :Nzz)

;; search in current buffer with selected text
(vnoremap :/ "y/\\V<C-r>\"<CR>")
(nnoremap :/ "/\\v")

;; search in project files
(nnoremap :<Leader>f tel.live_grep)
(nnoremap :<Leader>q tel.quickfix)

(set vim.g.FerretMaxResults 10000)
(set vim.g.FerretQFHandler (.. "botright copen " bottom-height))
(set vim.g.FerretExecutable "rg")
(set vim.g.FerretExecutableArguments
     {:rg (.. " --vimgrep"
              " --no-heading"
              " --smart-case"
              " --sort path"
              " --hidden"
              " --glob=!.git")})
(set vim.g.FerretMap false)
(nmap :<Leader>* "<Plug>(FerretAckWord)")
(vnoremap :<Leader>* "y:Ack <C-r>\"<CR>")
(nmap :<Leader>/ "<Plug>(FerretAck)")
(vnoremap :<Leader>/ "y:Ack <C-r>\"")
; (nmap :<Leader>r "<Plug>(FerretAcks)")

(set vim.opt.path
     [ "." ; current file
      "**" ; children subdirectories 'starstar'
      ])


;; Comments
(Comment.setup {})

(lightspeed.setup
  {:ignore_case true})


;; Files
(oil.setup
  {:columns [{1 :permissions :highlight :NonText}
             {1 :size        :highlight :String}
             {1 :ctime       :highlight :Number :format "%Y-%m-%d %H:%M"}]
   :view_options {:show_hidden true}
   :keymaps {"g?"    "actions.show_help"
             "<CR>"  "actions.select"
             "<C-s>" "actions.select_vsplit"
             "<C-r>" "actions.refresh"
             "<C-p>" "actions.preview"
             "<C-c>" "actions.close"
             "-"     "actions.parent"
             "_"     "actions.open_cwd"
             "g."    "actions.toggle_hidden"
             "."     "actions.open_cmdline"
             ","     "actions.open_cmdline_dir"
             "gy"    "actions.copy_entry_path"}
   :use_default_keymaps false})
(nmap :- oil.open)

;; Git
; If this many milliseconds nothing is typed the swap file will be written to disk speedsup gitgutter
(set vim.opt.updatetime 100)
(vim.opt.diffopt:append [:indent-heuristic :internal "algorithm:histogram" "linematch:60"])

(set vim.g.gitgutter_map_keys false)
(nnoremap :silent :<Leader>gd "<Cmd>Gdiffsplit<CR>")
(nnoremap :silent :<Leader>gs "<Cmd>Git|only<CR>")
(nnoremap :silent :<Leader>gl "<Cmd>Gclog<CR>")
(nmap :<Leader>hp "<Plug>(GitGutterPreviewHunk)")
(nmap :<Leader>hs "<Plug>(GitGutterStageHunk)")
(nmap :<Leader>hu "<Plug>(GitGutterUndoHunk)")
(nmap "[h" "<Plug>(GitGutterPrevHunk)")
(nmap "]h" "<Plug>(GitGutterNextHunk)")
(omap :ih "<Plug>(GitGutterTextObjectInnerPending)")
(xmap :ih "<Plug>(GitGutterTextObjectInnerVisual)")
(omap :ah "<Plug>(GitGutterTextObjectOuterPending)")
(xmap :ah "<Plug>(GitGutterTextObjectOuterVisual)")
(nnoremap :yoh "<Cmd>GitGutterSignsToggle<CR>")
(nnoremap :<Leader>dw
   #(if (vim.tbl_contains (vim.opt.diffopt:get) "iwhite")
      (do (vim.opt.diffopt:remove "iwhite") (vim.notify "noiwhite"))
      (do (vim.opt.diffopt:append "iwhite") (vim.notify "iwhite"))))
(au gitcommit :FileType :gitcommit
    (set vim.opt_local.spell true))

;; man git-log(1)
;; %ah - author date, human style
;; %d  - ref names, like the --decorate
;; %s  - subject
(set vim.g.fugitive_summary_format "%ah %d %s")

;; Wiki
(set vim.g.wiki_root "~/Notes")
(set vim.g.wiki_mappings_global
     {"<Plug>(wiki-open)" "<Leader>we"})
(set vim.g.wiki_mappings_local
     {"<Plug>(wiki-journal-copy-tonext)" ""
      "<Plug>(wiki-link-next)" ""
      "<Plug>(wiki-link-return)" ""
      "<Plug>(wiki-link-toggle)" ""
      "<Plug>(wiki-page-toc)" ""})

(nnoremap :<Leader>wn #(tel.find_files {:cwd vim.g.wiki_root}))
(nnoremap :<Leader>wf #(tel.live_grep {:cwd vim.g.wiki_root}))




;; LSP
(null-ls.setup
  {:sources
   [null-ls.builtins.code_actions.statix
    (null-ls.builtins.diagnostics.vale.with
      {:filetypes ["markdown" "gitcommit"]})
    null-ls.builtins.diagnostics.statix
    null-ls.builtins.diagnostics.shellcheck
    null-ls.builtins.diagnostics.hadolint
    null-ls.builtins.diagnostics.codespell
    (null-ls.builtins.diagnostics.yamllint.with
      {:extra_args ["--config-data" (.. "{ extends: default,"
                                          "rules: { line-length: {max: 120},"
                                                   "document-start: {present: false}}}")]})
    null-ls.builtins.formatting.zprint
    null-ls.builtins.formatting.fixjson
    null-ls.builtins.formatting.prettier
    null-ls.builtins.formatting.nixpkgs_fmt
    null-ls.builtins.formatting.xmllint
    (null-ls.builtins.formatting.trim_whitespace.with
      {:filetypes ["yaml" "docker" "fennel"]})
    (null-ls.builtins.formatting.clang_format.with
      {:filetypes ["glsl"]})
    (null-ls.builtins.formatting.shfmt.with
      {:extra_args ["-i" "2" "-sr"]})
    (null-ls.builtins.formatting.pg_format.with
      {:extra_args ["--spaces" "2" ; indentation, default 4 spaces
                    "--comma-break" ; in insert statement, add a newline after each comma
                    "--function-case" "2" ; uppercase function name
                    "--placeholder" "\\?[a-zA-Z]+\\?" ; regex for code that must not be changed `?IN?`
                    "-"]})]})

(fn enabled-formatting? [client]
  (let [disabled-formatters [:tsserver :clojure_lsp]]
    (not (vim.tbl_contains disabled-formatters (. client :name)))))

(nnoremap :<Leader>lf #(vim.lsp.buf.format {:timeout_ms 5000 ; default 2000, zprint is slow
                                            :filter enabled-formatting?}))
(nnoremap :<Leader>la vim.lsp.buf.code_action)
(fn lsp-buffer-mappings []
  (nnoremap :buffer :gd         vim.lsp.buf.definition)
  (nnoremap :buffer :<Leader>lt vim.lsp.buf.type_definition)
  (nnoremap :buffer "}"         vim.lsp.buf.references)
  (nnoremap :buffer :<Leader>lr vim.lsp.buf.rename)
  (nnoremap :buffer :K          vim.lsp.buf.hover))

(vim.diagnostic.config
  {:virtual_text false
   :underline true
   :float {:show_header false}
   :severity_sort true
   :signs true})
(nnoremap :L #(vim.diagnostic.open_float nil {:scope :line :border :single}))
(nnoremap :yol #(do
                  (if (vim.diagnostic.is_disabled)
                    (vim.diagnostic.enable)
                    (vim.diagnostic.disable))
                  (vim.notify (.. "diagnostic disabled? " (tostring (vim.diagnostic.is_disabled))))))
(nnoremap "]d" vim.diagnostic.goto_next)
(nnoremap "[d" vim.diagnostic.goto_prev)

(tset vim.lsp.handlers "textDocument/hover"
      (vim.lsp.with vim.lsp.handlers.hover {:border :single}))
(tset vim.lsp.handlers "textDocument/signatureHelp"
      (vim.lsp.with vim.lsp.handlers.singature_help {:border :single}))

;; lsp progress widget
(fidget.setup {})

;; Conjure
(set vim.g.conjure#eval#result_register :e)
(set vim.g.conjure#log#botright true)
(au conjure-log :BufNewFile "conjure-log-*"
    (vim.diagnostic.disable 0))
(set vim.g.conjure#filetypes [:clojure :fennel :python])
(set vim.g.conjure#eval#gsubs {:do-comment ["^%(comment[%s%c]" "(do "]}) ; eval comment as do
(set vim.g.conjure#mapping#doc_word :k)


;; Python
(au python :FileType :python
    (lsp-buffer-mappings))
(lspconfig.pylsp.setup {:capabilities lsp-capabilities})


;; JavaScript/TypeScript
(au typescript :FileType [:typescript :javascript :typescriptreact :javascriptreact]
    (lsp-buffer-mappings))
(lspconfig.tsserver.setup
  {:capabilities lsp-capabilities
   ;; https://github.com/typescript-language-server/typescript-language-server/issues/411#issuecomment-1065943942
   :cmd [:typescript-language-server :--stdio :--tsserver-path
         (let [[tsserver-bin] (vim.fn.systemlist "realpath `which tsserver`")
               (tsserver-path) (string.gsub tsserver-bin "bin/tsserver" "lib")]
           tsserver-path)]})

;; Rust
(au rust :FileType :rust
    (lsp-buffer-mappings))
(lspconfig.rust_analyzer.setup {:capabilities lsp-capabilities})


;; C
(au c :FileType [:c :cpp]
    (lsp-buffer-mappings)

    (set vim.opt_local.tabstop 2)
    (set vim.opt_local.softtabstop 2)
    (set vim.opt_local.shiftwidth 2)
    (set vim.opt_local.expandtab true))
(lspconfig.ccls.setup {:capabilities lsp-capabilities})


;; Sexp
(set vim.g.sexp_filetypes "clojure,scheme,lisp,fennel")
(au sexp :FileType [:clojure :scheme :lisp :fennel]
    ;; emulate text object for pair of elements
    ;; i.e. key/value binding/expr test/expr

    ;; pair forward
    (xmap :buffer :ip "<Plug>(sexp_inner_element)<Plug>(sexp_move_to_next_element_tail)")
    (omap :buffer :ip "<Cmd>normal vip<CR>")

    ;; pair backward
    (xmap :buffer :iP "<Plug>(sexp_inner_element)o<Plug>(sexp_move_to_prev_element_head)")
    (omap :buffer :iP "<Cmd>normal viP<CR>")

    ;; swap pair
    (nmap :buffer :>p "vip>eo<Esc>")
    (nmap :buffer :<p "vip<eo<Esc>")

    (xmap :buffer :>e "<Plug>(sexp_swap_element_forward)")
    (xmap :buffer :<e "<Plug>(sexp_swap_element_backward)")
    (xmap :buffer :>f "<Plug>(sexp_swap_list_forward)")
    (xmap :buffer :<f "<Plug>(sexp_swap_list_backward)"))
(set vim.g.sexp_enable_insert_mode_mappings false) ; use autopairs instead

(autopairs.setup
  {:enable_check_bracket_line false ; always add closing bracket, event when next char is closing bracket
   :disable_in_visualblock true})


;; Clojure
(fn clj_ignore []
  (vim.cmd "normal `[") ; navigate to beginnign of a text object
  (vim.cmd "normal i#_") ; prepend reader macro
)

(fn do-clj-ignore [form]
  (set vim.opt.operatorfunc (.. "v:lua.require'dotfiles'.clj_ignore"))
  (vim.api.nvim_feedkeys (.. "g@" (or form "")) :m false))

(fn conjure-eval [form]
  (vim.cmd.ConjureEval form))

(au clojure :FileType :clojure
    (lsp-buffer-mappings)

    (xnoremap :buffer :<Leader>cc do-clj-ignore)
    (nnoremap :buffer :<Leader>cc do-clj-ignore)
    (nnoremap :buffer :<Leader>cu "<Cmd>let s=@/<CR>l?\\v(#_)+<CR>dgn:let @/=s<CR>")

    (nnoremap :buffer :<Leader>lm
              #(vim.lsp.buf.execute_command {:command   :move-form
                                             :arguments [(.. "file://" (vim.fn.expand "%:p"))
                                                         (- (vim.fn.line ".") 1)
                                                         (- (vim.fn.col ".") 1)
                                                         (vim.fn.input "File: " (vim.fn.expand "%:p:h") "file")]}))

    ;; https://github.com/djblue/portal/blob/master/doc/editors/emacs.md
    (nnoremap :buffer :<LocalLeader>po #(conjure-eval "((requiring-resolve 'portal.api/open))"))
    (nnoremap :buffer :<LocalLeader>pc #(conjure-eval "((requiring-resolve 'portal.api/close))"))
    (nnoremap :buffer :<LocalLeader>pr #(conjure-eval "((requiring-resolve 'portal.api/clear))"))

    (set vim.opt_local.tabstop 2)
    (set vim.opt_local.softtabstop 2)
    (set vim.opt_local.shiftwidth 2)
    (set vim.opt_local.expandtab true)

    ;; converts package names into file names; useful for "gf"
    (set vim.opt_local.includeexpr "substitute(substitute(v:fname,'\\.','/','g'),'-','_','g')")
    (set vim.opt_local.suffixesadd ".clj"))

(set vim.g.conjure#client#clojure#nrepl#test#runner :clojure)
;; (set vim.g.conjure#client#clojure#nrepl#test#runner :kaocha)
;; see https://github.com/lambdaisland/kaocha/blob/main/doc/03_configuration.md
;; (set vim.g.conjure#client#clojure#nrepl#test#call_suffix
;;     "{:kaocha/color? false
;;       :capture-output? true
;;       :kaocha/fail-fast? false
;;       :reporter kaocha.report/documentation
;;       :tests [{:kaocha.testable/skip-add-classpath? true}]}")
(set vim.g.conjure#client#clojure#nrepl#eval#raw_out true)

(lspconfig.clojure_lsp.setup {:capabilities lsp-capabilities})


;; Fennel
(au fennel :FileType :fennel
    (lsp-buffer-mappings))
(lspconfig.fennel_ls.setup
  {:capabilities lsp-capabilities})


;; Slime
(set vim.g.slime_target :tmux)
(set vim.g.slime_dont_ask_default true)
(set vim.g.slime_default_config {:socket_name :default
                                 :target_pane "{right-of}"})
(set vim.g.slime_no_mappings true)
(xmap :<Leader>s "<Plug>SlimeRegionSend")
(nmap :<Leader>s "<Plug>SlimeMotionSend")
(nmap :<Leader>ss "<Plug>SlimeLineSend")
(nmap :<Leader>sc "<Plug>SlimeConfig")
(xnoremap :<Leader>sy "\"sy")
(nnoremap :<Leader>sp "<Cmd>SlimeSend1 <C-R>s<CR>")

;; Scheme
(fn scm_ignore []
  (vim.cmd "normal `[") ; navigate to beginnign of a text object
  (vim.cmd "normal i#;") ; prepend sexp comment
)

(fn do-scm-ignore [form]
  (set vim.opt.operatorfunc (.. "v:lua.require'dotfiles'.scm_ignore"))
  (vim.api.nvim_feedkeys (.. "g@" (or form "")) :m false))

(au scheme :FileType :scheme
    (xnoremap :buffer :<Leader>c do-scm-ignore)
    (nnoremap :buffer :<Leader>cc #(do-scm-ignore "aF"))
    (nmap :buffer :<Leader>cu "<Cmd>let s=@/<CR>l?\v(#;)+<CR>dgn:let @/=s<CR>")
    (nmap :buffer :<Leader>pp "<Plug>SlimeMotionSend<Plug>(sexp_outer_top_list)``")
    (nnoremap :buffer :K "<Cmd>SlimeSend1 (pp <C-R><C-W>)<CR>")
    (nmap :buffer :<Leader>lf "ggvG=``"))

;; Curl / Vim Rest Client
(set vim.g.vrc_curl_opts
     {:--connect-timeout 10
      :--include ""
      :--location ""
      :--max-time 60
      :--show-error ""
      :--silent ""})
(set vim.g.vrc_auto_format_response_patterns
     {:json "jq"
      :xml (.. "grep \"\\S\" | xmllint --format --nonet --recover -")})

(au rest :FileType :rest
    (nnoremap :buffer :<Leader>cd
              #(do
                 (set vim.b.vrc_debug (not vim.b.vrc_debug))
                 (set vim.b.vrc_show_command vim.b.vrc_debug)
                 (vim.notify (if vim.b.vrc_debug "debug" "nodebug"))))
    (nnoremap :buffer :<Leader>cb
              #(do
                 (set vim.b.vrc_allow_get_request_body (not vim.b.vrc_allow_get_request_body))
                 (vim.notify (if vim.b.vrc_allow_get_request_body "allow body" "disallow body"))))
    (nnoremap :buffer :<Leader>cs
              #(do
                 (set vim.b.vrc_split_request_body (not vim.b.vrc_split_request_body))
                 (vim.notify (if vim.b.vrc_split_request_body "split" "nosplit"))))
    (nnoremap :buffer :<Leader>cc
              #(do
                 (set vim.b.vrc_output_buffer_name
                      (.. "[" (vim.fn.expand "%:t") "@" (vim.fn.strftime "%H:%M:%S") "]"
                          (string.gsub (vim.api.nvim_get_current_line) "\""  "\\\"")))
                 (vim.fn.VrcQuery))))



;; Markdown
(au markdown :FileType :markdown
    (vnoremap :buffer :<Leader>tj ":!pandoc -f gfm -t jira<CR>"))
(set vim.g.markdown_syntax_conceal false)
(set vim.g.markdown_folding 1)


;; glsl
(au glsl-detect [:BufNewFile :BufRead] [:*.glsl :*.vert :*.geom :*.frag]
    (set vim.opt_local.filetype :glsl))

;; Alternative file
(nnoremap :<Leader>aa "<Cmd>Other<CR>")
(nnoremap :<Leader>av "<Cmd>OtherVSplit<CR>")
(other.setup
  {:mappings
   [{:pattern "(.*)/src/(.*).clj"
     :target "%1/test/%2_test.clj"}
    {:pattern "(.*)/test/(.*)_test.clj"
     :target "%1/src/%2.clj"}]})


;; Terminal
(tnoremap :<Esc> "<C-\\><C-n>") ; use Esc to exit terminal mode
(tnoremap :<C-v><Esc> "<Esc>") ; press Esc in terminal mode
(au terminal-open :TermOpen :*
    (set vim.opt_local.winbar "%{b:term_title}")
    (set vim.opt_local.bufhidden "hide"))
(au terminal-leave :TermLeave :*
    (when (and vim.b.terminal_job_pid vim.b.term_title)
      (vim.cmd.file (.. "term:" vim.b.terminal_job_pid ":" vim.b.term_title))))

;; Open terminal in a split near current file or at specified path
(vim.api.nvim_create_user_command
  :Term
  (fn [{:args path}]
    (let [path (if (= path "") "%:h" path)]
      (-> [:vsplit (.. "lcd " path) :terminal] (table.concat "|") vim.cmd)
      (vim.api.nvim_feedkeys :i :n false)))
  {:nargs "?"
   :desc "Open terminal"})

;; Scratch - open file in temp folder with specified suffix
(vim.api.nvim_create_user_command
  :Scratch
  (fn [{:args suffix}] (vim.cmd.edit (.. (vim.fn.tempname) "_" suffix)))
  {:nargs "?"
   :desc "New temporary file"})

;; Auto write and read file
(au autosave [:FocusLost :BufLeave :CursorHold] [:*] (vim.cmd "silent! update"))
(au autoread [:FocusGained :BufEnter :CursorHold] [:*] (vim.cmd "silent! checktime"))
(au jump-to-last-postion :BufReadPost :*
    ; https://github.com/vim/vim/blob/eaf35241197fc6b9ee9af993095bf5e6f35c8f1a/runtime/defaults.vim#L108-L117
    (let [[line col] (vim.api.nvim_buf_get_mark 0 "\"")
          line-count (vim.api.nvim_buf_line_count 0)]
      (when (and (<= 1 line line-count)
                 (not= (vim.opt.ft:get) :commit))
        (vim.api.nvim_win_set_cursor 0 [line col]))))

;; EasyAlign
(nmap :ga "<Plug>(EasyAlign)")
(xmap :ga "<Plug>(EasyAlign)")

{: clj_ignore
 : scm_ignore}
