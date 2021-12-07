(module dotfiles.init
  {autoload {telescope telescope
             tel telescope.builtin
             themes telescope.themes
             cmp cmp
             pqf pqf
             cmp_nvim_lsp cmp_nvim_lsp
             lspkind lspkind
             luasnip luasnip
             nu aniseed.nvim.util
             lspconfig lspconfig
             tree-conf nvim-treesitter.configs
             hop hop
             null-ls null-ls
             null-ls-methods null-ls.methods
             null-ls-helpers null-ls.helpers}})

(macro au [group event pattern ...]
  `(do
     (defn ,group [] ,...)
     (vim.schedule
       #(vim.cmd
          (.. "augroup " ,(tostring group) "
              autocmd!
              autocmd " ,(tostring event) " " ,(tostring pattern) " lua require('" *module-name* "')['" ,(tostring group) "']()
              augroup END")))))

(tree-conf.setup
  {:ensure_intalled :maintained
   :indent {:enable true}
   :highlight {:enable true}})

(set vim.g.mapleader " ")
(set vim.g.maplocalleader "\t")

(defn- indexed->named [keys tbl]
  (each [index key (ipairs tbl)]
    (match (. keys key)
      value (doto tbl
              (table.remove index)
              (tset key value))))
  tbl)
(vim.cmd "runtime plugin/astronauta.vim") ; defines vim.keymap.*
(defn- keymap [m args]
  (->> args
       (indexed->named {:buffer true :silent true})
       ((. vim.keymap m))))
(defn- nmap [...] (keymap :nmap [...]))
(defn- nnoremap [...] (keymap :nnoremap [...]))
(defn- noremap [...] (keymap :noremap [...]))
(defn- omap [...] (keymap :omap [...]))
(defn- tnoremap [...] (keymap :tnoremap [...]))
(defn- vnoremap [...] (keymap :vnoremap [...]))
(defn- xmap [...] (keymap :xmap [...]))
(defn- xnoremap [...] (keymap :xnoremap [...]))

(telescope.setup
  {:defaults (themes.get_ivy
               {:layout_config {:height 10}
                :preview false})
   :extensions {:fzf {:fuzzy true
                      :override_generic_sorter true
                      :override_file_sorter true
                      :case_mode :smart_case}
                :project {:base_dirs ["~/code" "~/dotfiles" "~/Downloads"]
                          :hidden_files true}}})
(telescope.load_extension :fzf)
(telescope.load_extension :project)

(nnoremap :<Leader>p #(telescope.extensions.project.project {}))
(nnoremap :<Leader>k tel.help_tags)
(nnoremap :<Leader><Leader> tel.commands)
(noremap :<Leader>la tel.lsp_code_actions)
(nnoremap :<Leader>n #(tel.find_files {:find_command [:fd :--hidden :--exclude :.git]}))
(nnoremap :<Leader>e #(tel.buffers {:sort_lastused true
                                    :ignore_current_buffer false}))

(cmp.setup
  {:sources [{:name :nvim_lua}
             {:name :nvim_lsp}
             {:name :conjure}
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
                  {:with_text true
                   :symbol_map (collect [k (pairs lspkind.presets.default)] (values k ""))
                   :menu {:nvim_lua "[lua]"
                          :nvim_lsp "[lsp]"
                          :conjure "[conj]"
                          :vim-dadbod-completion "[db]"
                          :luasnip "[snip]"
                          :path "[path]"
                          :buffer "[buf]"
                          :spell "[spell]"}})}
   :snippet {:expand #(luasnip.lsp_expand (. $1 :body))}
   :mapping {"<C-d>" (cmp.mapping.scroll_docs -4)
             "<C-u>" (cmp.mapping.scroll_docs 4)
             "<C-e>" (cmp.mapping.close)
             "<C-y>" (cmp.mapping.confirm {:behaviour cmp.ConfirmBehavior.Insert
                                           :select true})}})

(def- cmp-capabilities
  (cmp_nvim_lsp.update_capabilities (vim.lsp.protocol.make_client_capabilities)))

(set vim.opt.completeopt [:menu :menuone :noselect])
(vim.opt.complete:remove :t)  ; I don't use tags
(vim.opt.shortmess:append :c) ; turn off completion messages

(vim.opt.shortmess:append :I) ; don't give the intro message
(vim.opt.shortmess:append :W) ; don't give 'written' when writing a file

(set vim.opt.scrolloff 5)       ; minimal number of lines around cursor
(set vim.opt.sidescrolloff 5)   ; minimal number of chars around cursor
(set vim.opt.startofline false) ; keep cursor on the same offset when paging

(set vim.opt.guicursor "a:blinkon0")   ; disable cursor blink in all modes
(set vim.opt.mouse :a)                 ; enable mouse in all modes
(set vim.opt.mousemodel :popup_setpos) ; make mouse behave like in GUI app

(set vim.opt.clipboard :unnamedplus) ; set default copy register the same as clipboard
(au yank :TextYankPost "*" (vim.highlight.on_yank {:higroup :Visual}))

(set vim.opt.virtualedit :block) ; allow virtual editing only in Visual Block mode.

(vim.opt.matchpairs:append "<:>") ; characters that form pairs

(set vim.opt.joinspaces false) ; insert only one space between joined lines

(set vim.opt.signcolumn "yes:1")   ; always show  signcolumn  with width 1
(set vim.opt.number false)         ; no line numbers
(set vim.opt.relativenumber false) ; not even relative
(set vim.opt.colorcolumn [100])    ; visual vertical line


;; Spelling
(set vim.opt.spelllang :en_us)     ; spell check
(set vim.opt.spell false)          ; disabled by default
(vim.opt.spellsuggest:append "10") ; limit spell suggestions list
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
(au autoresize :VimResized "*" (vim.cmd "wincmd ="))
(set vim.opt.winwidth 80)     ; minimal width of active window
(set vim.opt.winminwidth 10)  ; minimal width of inactive window
(set vim.opt.winheight 50)    ; minimal height of active window
(set vim.opt.winminheight 10) ; minimal height of inactive window
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
                  :Keyword
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
                 :Boolean :Yellow}]
    (each [src dest (pairs to-link)]
      (vim.cmd (.. "highlight clear " src))
      (vim.cmd (.. "highlight link " src " " dest)))))

(set vim.opt.ruler false)      ; line and column number of the cursor position
(set vim.opt.laststatus 2)     ; 2 - always show status line
(set vim.opt.showmode false)   ; disable mode message
(set vim.opt.title true)       ; update window title
(set vim.opt.titlestring "%f") ; file name in title

;; Folding
(set vim.opt.foldmethod :expr)
(set vim.opt.foldexpr "nvim_treesitter#foldexpr()")
(set vim.opt.foldenable true)    ; enable folding
(set vim.opt.foldlevelstart 999) ; all folds are open
(set vim.opt.fillchars "fold:‧")
(set vim.g.crease_foldtext {:default "%{repeat(\"  \", v:foldlevel - 1)}%t %= %l lines %f%f"})
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

(set vim.g.FerretMaxResults 1000)
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
(nmap :<Leader>r "<Plug>(FerretAcks)")

(set vim.opt.path
     [ "." ; current file
      "**" ; children subdirectories 'starstar'
      ])


;; Hop
(hop.setup
  {:teasing false
   :jump_on_sole_occurrence true})
(nnoremap "<Leader>'" hop.hint_char1) ; to any char in buffer


;; Git
; If this many milliseconds nothing is typed the swap file will be written to disk speedsup gitgutter
(set vim.opt.updatetime 100)
(vim.opt.diffopt:append [:indent-heuristic :internal "algorithm:histogram"])

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

;; man git-log(1)
;; %ah - author date, human style
;; %d  - ref names, like the --decorate
;; %s  - subject
(set vim.g.fugitive_summary_format "%ah %d %s")

;; Wiki
(set vim.g.wiki_root "~/Notes")
(set vim.g.wiki_filetypes ["md"])
(set vim.g.wiki_link_extension ".md")
(set vim.g.wiki_link_target_type "md")
(set vim.g.wiki_journal
     {:name "diary"
      :frequency "daily"
      :date_format {:daily "%Y-%m-%d"
                    :monthly "%Y_m%m"
                    :weekly "%Y_w%V"}})

(set vim.g.wiki_mappings_global
     {"<Plug>(wiki-journal)" "<Leader>w_disable"
      "<Plug>(wiki-open)" "<Leader>we"})

(set vim.g.wiki_mappings_local
     {"<Plug>(wiki-journal-copy-tonext)" "<Leader>w_disable"
      "<Plug>(wiki-link-next)" "<Leader>w_disable"
      "<Plug>(wiki-link-return)" "<Leader>w_disable"
      "<Plug>(wiki-link-toggle)" "<Leader>w_disable"
      "<Plug>(wiki-page-toc)" "<Leader>w_disable"})

(nnoremap :<Leader>wn #(tel.find_files {:find_command [:fd
                                                       :--exclude :.stversions
                                                       :--exclude :.stfoldre]
                                        :cwd vim.g.wiki_root}))




;; LSP
(null-ls.config
  {:sources
   [null-ls.builtins.code_actions.statix
    null-ls.builtins.diagnostics.statix
    null-ls.builtins.diagnostics.shellcheck
    null-ls.builtins.diagnostics.hadolint
    null-ls.builtins.diagnostics.codespell
    (null-ls.builtins.diagnostics.yamllint.with
      {:extra_args ["--config-data" (.. "{ extends: default,"
                                          "rules: { line-length: {max: 120},"
                                                   "document-start: {present: false}}}")]})

    null-ls.builtins.formatting.fixjson
    null-ls.builtins.formatting.prettier
    (null-ls.builtins.formatting.trim_whitespace.with
      {:filetypes ["yaml" "docker" "fennel"]})
    (null-ls.builtins.formatting.shfmt.with
      {:extra_args ["-i" "2" "-sr"]})
    (null-ls-helpers.make_builtin
      {:factory null-ls-helpers.formatter_factory
       :method null-ls-methods.internal.FORMATTING
       :filetypes [:nix]
       :generator_opts
       {:command :nixpkgs-fmt
        :to_stdin true}})
    (null-ls-helpers.make_builtin
      {:factory null-ls-helpers.formatter_factory
       :method null-ls-methods.internal.FORMATTING
       :filetypes [:sql]
       :generator_opts
       {:command :pg_format
        :args ["--spaces" "4"
               "--comma-break"
               "-"]
        :to_stdin true}})
    (null-ls-helpers.make_builtin
      {:factory null-ls-helpers.formatter_factory
       :method null-ls-methods.internal.FORMATTING
       :filetypes [:xml]
       :generator_opts
       {:command :xmllint
        :args ["--format"
               "--nonet"
               "--recover"
               "-"]
        :to_stdin true}})]})
(lspconfig.null-ls.setup {})
(nnoremap :<Leader>lf vim.lsp.buf.formatting)

(vim.diagnostic.config
  {:virtual_text false
   :underline true
   :float {:show_header false}
   :severity_sort true
   :signs true})
(nnoremap :L #(vim.diagnostic.open_float nil {:scope :line :border :single}))
(nnoremap :yol vim.diagnostic.reset)

(tset vim.lsp.handlers "textDocument/hover"
      (vim.lsp.with vim.lsp.handlers.hover {:border :single}))
(tset vim.lsp.handlers "textDocument/signatureHelp"
      (vim.lsp.with vim.lsp.handlers.singature_help {:border :single}))


;; Conjure
(set vim.g.conjure#eval#result_register :e)
(set vim.g.conjure#log#botright true)
(set vim.g.conjure#filetypes [:clojure :fennel])
(set vim.g.conjure#eval#gsubs {:do-comment ["^%(comment[%s%c]" "(do "]}) ; eval comment as do


;; Terraform
(au terraform :FileType "terraform,hcl"
    (nnoremap :buffer :gd vim.lsp.buf.definition)
    (nnoremap :buffer "}" vim.lsp.buf.references)
    (nnoremap :buffer :K vim.lsp.buf.hover))
(lspconfig.terraformls.setup
  {:capabilities cmp-capabilities
   :filetypes [:terraform :hcl]})


;; Python
(au python :FileType "python"
    (nnoremap :buffer :gd vim.lsp.buf.definition)
    (nnoremap :buffer :<Leader>lr vim.lsp.buf.rename)
    (nnoremap :buffer "}" vim.lsp.buf.references)
    (nnoremap :buffer :K vim.lsp.buf.hover))
(lspconfig.pylsp.setup {:capabilities cmp-capabilities})


;; Vim
(au viml :FileType "vim"
    (set vim.opt_local.foldmethod "marker")
    (set vim.opt_local.foldlevel 0)
    (set vim.opt_local.tabstop 2)
    (set vim.opt_local.softtabstop 2)
    (set vim.opt_local.shiftwidth 2)
    (set vim.opt_local.expandtab true))


;; JavaScript/TypeScript
(au typescript :FileType "typescript,javascript,typescriptreact,javascriptreact"
    (nnoremap :buffer :gd vim.lsp.buf.definition)
    (nnoremap :buffer :<Leader>lr vim.lsp.buf.rename)
    (nnoremap :buffer :<Leader>lt vim.lsp.buf.type_definition)
    (nnoremap :buffer "}" vim.lsp.buf.references)
    (nnoremap :buffer :K vim.lsp.buf.hover))
(lspconfig.tsserver.setup
  {:capabilities cmp-capabilities
   :on_attach
   (lambda [client]
     (tset client.resolved_capabilities :document_formatting false )
     (tset client.resolved_capabilities :document_range_formatting false))})

;; Rust
(au rust :FileType "rust"
    (nnoremap :buffer :gd vim.lsp.buf.definition)
    (nnoremap :buffer :<Leader>lr vim.lsp.buf.rename)
    (nnoremap :buffer "}" vim.lsp.buf.references)
    (nnoremap :buffer :K vim.lsp.buf.hover))
(lspconfig.rust_analyzer.setup {:capabilities cmp-capabilities})


;; C
(au c :FileType "c,cpp"
    (vnoremap :buffer "=" vim.lsp.buf.range_formatting)
    (nnoremap :buffer :gd vim.lsp.buf.definition)
    (nnoremap :buffer :<Leader>lr vim.lsp.buf.rename)
    (nnoremap :buffer "}" vim.lsp.buf.references)
    (nnoremap :buffer :K vim.lsp.buf.hover)
    (set vim.opt_local.tabstop 2)
    (set vim.opt_local.softtabstop 2)
    (set vim.opt_local.shiftwidth 2)
    (set vim.opt_local.expandtab true))
(lspconfig.ccls.setup {:capabilities cmp-capabilities})


;; Sexp
(set vim.g.sexp_filetypes "clojure,scheme,lisp,fennel")
(au sexp :FileType "clojure,scheme,lisp,fennel"
    (nmap :buffer :doe "<Plug>(sexp_raise_element)")
    (nmap :buffer :dof "<Plug>(sexp_raise_list)")

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


;; Clojure
(defn clj_ignore []
  (nu.normal "`[") ; navigate to beginnign of a text object
  (nu.normal "i#_") ; prepend reader macro
)

(defn do-clj-ignore [form]
  (set vim.opt.operatorfunc (.. "v:lua.require'" *module-name* "'.clj_ignore"))
  (vim.api.nvim_feedkeys (.. "g@" (or form "")) :m false))

(au clojure :FileType "clojure"
    (nnoremap :buffer :K vim.lsp.buf.hover)
    (nnoremap :buffer :<Leader>lr vim.lsp.buf.rename)
    (nnoremap :buffer :gd vim.lsp.buf.definition)

    (nnoremap :buffer :<Leader>cc #(do-clj-ignore "aF"))
    (xnoremap :buffer :<Leader>c do-clj-ignore)
    (nnoremap :buffer :<Leader>cu "<Cmd>let s=@/<CR>l?\\v(#_)+<CR>dgn:let @/=s<CR>")

    (set vim.opt_local.tabstop 2)
    (set vim.opt_local.softtabstop 2)
    (set vim.opt_local.shiftwidth 2)
    (set vim.opt_local.expandtab true)

    ;; converts package names into file names; useful for "gf"
    (set vim.opt_local.includeexpr "substitute(substitute(v:fname,'\\.','/','g'),'-','_','g')")
    (set vim.opt_local.suffixesadd ".clj"))
(set vim.g.clojure_fuzzy_indent true) ; use clojure syntax for indentation
(set vim.g.clojure_fuzzy_indent_patterns ["^with" "^def" "^let" "^Given" "^When" "^Then" "^And"])
(set vim.g.conjure#client#clojure#nrepl#test#current_form_names [:deftest :def-integration-test])
(set vim.g.conjure#client#clojure#nrepl#test#runner :clojure)
(set vim.g.conjure#client#clojure#nrepl#eval#raw_out true)
(lspconfig.clojure_lsp.setup {:capabilities cmp-capabilities})


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
(defn scm_ignore []
  (nu.normal "`[") ; navigate to beginnign of a text object
  (nu.normal "i#;") ; prepend sexp comment
)

(defn do-scm-ignore [form]
  (set vim.opt.operatorfunc (.. "v:lua.require'" *module-name* "'.scm_ignore"))
  (vim.api.nvim_feedkeys (.. "g@" (or form "")) :m false))

(au scheme :FileType "scheme"
    (xnoremap :buffer :<Leader>c do-scm-ignore)
    (nnoremap :buffer :<Leader>cc #(do-scm-ignore "aF"))
    (nmap :buffer :<Leader>cu "<Cmd>let s=@/<CR>l?\v(#;)+<CR>dgn:let @/=s<CR>")
    (nmap :buffer :<Leader>pp "<Plug>SlimeMotionSend<Plug>(sexp_outer_top_list)``")
    (nnoremap :buffer :K "<Cmd>SlimeSend1 (pp <C-R><C-W>)<CR>")
    (nmap :buffer :<Leader>lf "ggvG=``"))

;; Curl
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

(au rest :FileType "rest"
    (nnoremap :buffer :<Leader>cd
              #(do
                 (set vim.b.vrc_debug (not vim.b.vrc_debug))
                 (set vim.b.vrc_show_command vim.b.vrc_debug)
                 (vim.notify (if vim.b.vrc_debug "debug" "nodebug"))))
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
(au markdown :FileType "markdown"
    (vnoremap :buffer :<Leader>tj ":!pandoc -f gfm -t jira<CR>"))
(set vim.g.markdown_syntax_conceal false)
(set vim.g.markdown_folding 1)


;; Projectionist
(nnoremap :<Leader>aa "<Cmd>A<CR>")
(set vim.g.projectionist_heuristics
     {"project.clj|deps.edn" {"dev/*.clj" {:type "source"}
                              "src/*.clj" {:alternate "test/{}_test.clj"
                                           :type "source"}
                              "test/*_test.clj" {:alternate "src/{}.clj" :type "test"}}})


;; Terminal
(tnoremap :<Esc> "<C-\\><C-n>") ; use Esc to exit terminal mode
(tnoremap :<C-v><Esc> "<Esc>") ; press Esc in terminal mode
(au terminal-open :TermOpen "*"
    (set vim.opt_local.statusline "%{b:term_title}")
    (set vim.opt_local.bufhidden "hide"))
(au terminal-leave :TermLeave "*"
    (when (and vim.b.terminal_job_pid vim.b.term_title)
      (vim.cmd (.. "file term:" vim.b.terminal_job_pid ":" vim.b.term_title))))

(defn term [path]
  (let [path (if (= path "") "%:h" path)]
    (-> [:vsplit (.. "lcd " path) :terminal] (table.concat "|") vim.cmd)
    (vim.api.nvim_feedkeys :i :n false)))
(vim.cmd (.. "command! -nargs=? Term lua require('" *module-name* "').term(<q-args>)"))

;; Scratch
(defn scratch [suffix]
  (vim.cmd (.. "edit " (vim.fn.tempname) "_" suffix)))
(vim.cmd (.. "command! -nargs=? Scratch lua require('" *module-name* "').scratch(<q-args>)"))

;; Auto write and read file
(au autosave "FocusLost,BufLeave,CursorHold" "*" (vim.cmd "silent! update"))
(au autoread "FocusGained,BufEnter,CursorHold" "*" (vim.cmd "silent! checktime"))
(au jump-to-last-postion :BufReadPost "*"
    ; https://github.com/vim/vim/blob/eaf35241197fc6b9ee9af993095bf5e6f35c8f1a/runtime/defaults.vim#L108-L117
    (let [[line col] (vim.api.nvim_buf_get_mark 0 "\"")
          line-count (vim.api.nvim_buf_line_count 0)]
      (when (and (<= 1 line line-count)
                 (not= (vim.opt.ft:get) :commit))
        (vim.api.nvim_win_set_cursor 0 [line col]))))
