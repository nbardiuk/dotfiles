(module init
  {autoload {telescope telescope
             tel telescope.builtin
             themes telescope.themes
             cmp cmp
             cmp_nvim_lsp cmp_nvim_lsp
             lspkind lspkind
             luasnip luasnip
             nvim aniseed.nvim
             nu aniseed.nvim.util
             core aniseed.core
             lispdocs lispdocs
             lspconfig lspconfig
             tree-conf nvim-treesitter.configs
             hop hop}
   require-macros [macros]})

(tree-conf.setup
  {:ensure_intalled :maintained
   :indent {:enable true}
   :highlight {:enable true
               :custom_captures {"symbol" :Constant ; fix clojure keyword
                                 "punctuation.bracket" :Delimiter ; clojure brackets
                                 }}})

(defn- k [m ...]
  (let [args [...]]
    (vim.schedule #((. vim.keymap m) args))))

(defn- b [m ...]
  (let [args (core.merge [...] {:buffer true :silent true})]
    (vim.schedule #((. vim.keymap m) args))))

(def- ale-linters {})
(def- ale-fixers {:* ["remove_trailing_lines" "trim_whitespace"] })

(set vim.g.mapleader " ")
(set vim.g.maplocalleader "\t")

(telescope.setup
  {:defaults (themes.get_ivy
               {:layout_config {:height 10}
                :preview false})
   :extensions {:fzf {:fuzzy true
                      :override_generic_sorter true
                      :override_file_sorter true
                      :case_mode :smart_case}
                :project {:base_dirs ["~/src" "~/dev" "~/dotfiles" "~/Downloads"]}}})
(telescope.load_extension :fzf)
(telescope.load_extension :project)

(k :nnoremap :<leader>p #(telescope.extensions.project.project {}))
(k :nnoremap :<leader>k tel.help_tags)
(k :nnoremap :<leader><leader> tel.commands)
(k :nnoremap :<leader>la tel.lsp_code_actions)
(k :nnoremap :<leader>n #(tel.find_files {:find_command [:fd :--hidden :--exclude :.git]}))
(k :nnoremap :<leader>e #(tel.buffers {:sort_lastused true
                                       :ignore_current_buffer false}))

(cmp.setup
  {:sources [{:name "nvim_lua"}
             {:name "nvim_lsp"}
             {:name "conjure"}
             {:name "lausnip"}
             {:name "path"}
             {:name "buffer"
              :keyword_length 5
              :opts {:get_bufnrs #(vim.api.nvim_list_bufs)}}
             {:name "spell"
              :keyword_length 5}]
   :formatting {:format (lspkind.cmp_format {:with_text true
                                             :menu {:nvim_lua "[lua]"
                                                    :nvim_lsp "[lsp]"
                                                    :conjure "[conj]"
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

(set vim.opt.completeopt "menu,menuone,noselect")
(vim.opt.complete:remove :t)  ; i don't use tags
(vim.opt.shortmess:append :c) ; turn off completion messages

(vim.opt.shortmess:append :I) ; don't give the intro message
(vim.opt.shortmess:append :W) ; don't give 'written' when writing a file

(set vim.opt.scrolloff 5)       ; minimal number of lines around cursor
(set vim.opt.sidescrolloff 5)   ; minimal number of chars around cursor
(set vim.opt.startofline false) ; keep cursor on the same offset when paging

(set vim.opt.guicursor "a:blinkon0")   ; disable cursor blink in all modes
(set vim.opt.mouse :a)                 ; enable mouse in all modes
(set vim.opt.mousemodel :popup_setpos) ; make mouse behave like in GUI app

(set vim.opt.clipboard :unnamedplus) ; set default copy buffer the same as clipboard

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
(k :nnoremap "]s" ":<C-U>execute ':setlocal spell'| normal! ]s<CR>")
(k :nnoremap "]S" ":<C-U>execute ':setlocal spell'| normal! ]S<CR>")
(k :nnoremap "[s" ":<C-U>execute ':setlocal spell'| normal! [s<CR>")
(k :nnoremap "[S" ":<C-U>execute ':setlocal spell'| normal! [S<CR>")


(set vim.opt.wildmode "list:longest,full") ; commands completion
(set vim.opt.wildignorecase true)          ; case is ignored when completing file names and directories

(set vim.opt.list true)
(set vim.opt.listchars {:trail "·" :tab "▸ " :nbsp "+"}) ; display tabs and trailing spaces visually
(set vim.opt.showbreak "↳ ")                             ; a soft wrap break symbol

(set vim.opt.shell "/usr/bin/env zsh")


;; Panes
(au autoresize :VimResized "*" ((. nvim.ex "wincmd =")))
(set vim.opt.winwidth 80)     ; minimal width of active window
(set vim.opt.winminwidth 10)  ; minimal width of inactive window
(set vim.opt.winheight 50)    ; minimal height of active window
(set vim.opt.winminheight 10) ; minimal height of inactive window
; focus on new split
(k :nnoremap :<C-w>s :<C-w>s<C-w>w)
(k :nnoremap :<C-w>v :<C-w>v<C-w>w)


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
  (vim.cmd "colorscheme paper")

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
                  :Tag
                  ]]
    (each [_ highlight (pairs to-clear)]
      (vim.cmd (.. "highlight clear " highlight))))

  (let [to-link {:Comment :Directory
                 :Constant :Regexp
                 }]
    (each [a b (pairs to-link)]
      (vim.cmd (.. "highlight clear " a))
      (vim.cmd (.. "highlight link " a " " b)))))

(set vim.opt.ruler false)      ; line and column number of the cursor position
(set vim.opt.laststatus 2)     ; 2 - allways show status line
(set vim.opt.showmode false)   ; dissable mode message
(set vim.opt.title true)       ; update window title
(set vim.opt.titlestring "%f") ; file name in title

;; Folding
(set vim.opt.foldmethod :expr)
(set vim.opt.foldexpr "nvim_treesitter#foldexpr()")
(set vim.opt.foldenable true)    ; enable folding
(set vim.opt.foldlevelstart 999) ; all folds are open
(set vim.opt.fillchars "fold:‧")
(set vim.g.crease_foldtext {:default "%{repeat(\"  \", v:foldlevel - 1)}%t %= %l lines %f%f"})
(k :nnoremap :<BS> :za) ; toggle current fold

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
(k :nnoremap :n :nzz)
(k :nnoremap :N :Nzz)

;; search in current buffer with selected text
(k :vnoremap :/ "y/\\V<c-r>\"<cr>")
(k :nnoremap :/ "/\\v")

;; search in project files
(k :nnoremap :<leader>f tel.live_grep)
(k :nnoremap :<leader>q tel.quickfix)

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
(k :nmap :<leader>* "<Plug>(FerretAckWord)")
(k :vnoremap :<leader>* "y:Ack <c-r>\"<cr>")
(k :nmap :<leader>/ "<Plug>(FerretAck)")
(k :vnoremap :<leader>/ "y:Ack <c-r>\"")
(k :nmap :<leader>r "<Plug>(FerretAcks)")

(set vim.opt.path
     [ "." ; current file
      "**" ; children subdirectories 'starstar'
      ])


;; Hop
(hop.setup
  {:teasing false
   :jump_on_sole_occurrence true})
(k :nnoremap "<leader>'" hop.hint_char1) ; to any char in buffer


;; Git
; If this many milliseconds nothing is typed the swap file will be written to disk speedsup gitgutter
(set vim.opt.updatetime 100)
(vim.opt.diffopt:append "indent-heuristic,internal,algorithm:histogram")

(set vim.g.gitgutter_map_keys false)
(k :nnoremap :<leader>gd ":Gdiffsplit<CR>")
(k :nnoremap :<leader>gs ":Git<CR><C-w>o")
(k :nnoremap :<leader>gl ":Gclog<CR>")
(k :nmap :<leader>hp "<Plug>(GitGutterPreviewHunk)")
(k :nmap :<leader>hs "<Plug>(GitGutterStageHunk)")
(k :nmap :<leader>hu "<Plug>(GitGutterUndoHunk)")
(k :nmap "[h" "<Plug>(GitGutterPrevHunk)")
(k :nmap "]h" "<Plug>(GitGutterNextHunk)")
(k :omap :ih "<Plug>(GitGutterTextObjectInnerPending)")
(k :xmap :ih "<Plug>(GitGutterTextObjectInnerVisual)")
(k :omap :ah "<Plug>(GitGutterTextObjectOuterPending)")
(k :xmap :ah "<Plug>(GitGutterTextObjectOuterVisual)")
(k :nnoremap :yoh ":GitGutterSignsToggle<CR>")
(k :nnoremap :<leader>dw
   #(if (core.some #(= "iwhite" $1) (vim.opt.diffopt:get))
      (do (vim.opt.diffopt:remove "iwhite") (core.println "noiwhite"))
      (do (vim.opt.diffopt:append "iwhite") (core.println "iwhite"))))


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
     {"<plug>(wiki-journal)" "<leader>w_disable"
      "<plug>(wiki-open)" "<leader>we"})

(set vim.g.wiki_mappings_local
     {"<plug>(wiki-journal-copy-tonext)" "<leader>w_disable"
      "<plug>(wiki-link-next)" "<leader>w_disable"
      "<plug>(wiki-link-return)" "<leader>w_disable"
      "<plug>(wiki-link-toggle)" "<leader>w_disable"
      "<plug>(wiki-page-toc)" "<leader>w_disable"})

(k :nnoremap :<leader>wn #(tel.find_files {:find_command [:fd
                                                          :--exclude :.stversions
                                                          :--exclude :.stfoldre]
                                           :cwd vim.g.wiki_root}))




;; LSP
(tset vim.lsp.handlers :textDocument/publishDiagnostics
      (vim.lsp.with vim.lsp.diagnostic.on_publish_diagnostics
                    {:underline false
                     :virtual_text false
                     :signs false
                     :update_in_insert false}))


;; Conjure
(set vim.g.conjure#eval#result_register :e)
(set vim.g.conjure#log#botright true)
(set vim.g.conjure#filetypes [:clojure :fennel])


;; JSON
(au json :FileType "json"
    (b :nnoremap :<leader>lf ":ALEFix<CR>"))
(set vim.g.ale_json_jq_options "--monochrome-output --indent 2")
(set ale-fixers.json ["jq"])


;; Yaml
(au yaml :FileType "yaml"
    (b :nnoremap :<leader>lf ":ALEFix<CR>"))
(set vim.g.ale_yaml_yamllint_options
     (.. "-d \"{"
         "  extends: default,"
         "  rules: {"
         "    line-length: {max: 120},"
         "    document-start: {present: false}}}\""))
(set ale-linters.yaml ["yamllint"])


;; Terraform
(au terraform :FileType "terraform,hcl"
    (b :nnoremap :<leader>lf ":ALEFix<CR>"))
(set ale-fixers.hcl ["terraform"])
(set ale-fixers.terraform ["terraform"])
(set ale-linters.terraform ["terraform"])


;; XML
(au xml :FileType "xml"
    (b :nnoremap :<leader>lf ":ALEFix<CR>"))
(set vim.g.ale_xml_xmllint_options "--format --nonet --recover -")
(set ale-fixers.xml ["xmllint"])
(set ale-linters.xml ["xmllint"])


;; SQL
(au sql :FileType "sql"
    (b :nnoremap :<leader>lf ":ALEFix<CR>"))
(set vim.g.ale_sql_pgformatter_options "--spaces 4 --comma-break")
(set ale-fixers.sql ["pgformatter"])
(set ale-linters.sql ["sqlint"])


;; CSS
(au css :FileType "css,scss"
    (b :nnoremap :<leader>lf ":ALEFix<CR>"))
(set ale-fixers.css ["prettier" "stylelint"])
(set ale-fixers.scss ["prettier" "stylelint"])
(set ale-linters.css ["stylelint"])
(set ale-linters.scss ["stylelint"])


;; Nix
(au nix :FileType "nix"
    (b :nnoremap :<leader>lf ":ALEFix<CR>"))
(set ale-fixers.nix ["nixpkgs-fmt"])
(set ale-linters.nix ["nix"])


;; Shell
(au shell :FileType "sh"
    (b :nnoremap :<leader>lf ":ALEFix<CR>"))
(set vim.g.ale_sh_shfmt_options "-i=2 -sr")
(set ale-fixers.sh ["shfmt"])
(set ale-linters.sh ["shellcheck"])


;; Docker
(set ale-linters.dockerfile ["hadolint"])


;; Python
(au python :FileType "python"
    (b :nnoremap :<leader>lf vim.lsp.buf.formatting)
    (b :nnoremap :gd vim.lsp.buf.definition)
    (b :nnoremap :<leader>lr vim.lsp.buf.rename)
    (b :nnoremap "}" vim.lsp.buf.references)
    (b :nnoremap :K vim.lsp.buf.hover))
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
    (b :nnoremap :<leader>lf ":ALEFix<CR>")
    (b :nnoremap :gd vim.lsp.buf.definition)
    (b :nnoremap :<leader>lr vim.lsp.buf.rename)
    (b :nnoremap :<leader>lt vim.lsp.buf.type_definition)
    (b :nnoremap "}" vim.lsp.buf.references)
    (b :nnoremap :K vim.lsp.buf.hover))
(lspconfig.tsserver.setup {:capabilities cmp-capabilities})
(set ale-fixers.javascript ["eslint" "prettier"])
(set ale-fixers.typescriptreact ["prettier"])
(set ale-fixers.typescript ["prettier"])
(set ale-linters.javascript ["eslint"])
(set ale-linters.typescript ["tsserver" "tslint"])


;; Rust
(au rust :FileType "rust"
    (b :nnoremap :<leader>lf ":ALEFix<CR>")
    (b :nnoremap :gd vim.lsp.buf.definition)
    (b :nnoremap :<leader>lr vim.lsp.buf.rename)
    (b :nnoremap "}" vim.lsp.buf.references)
    (b :nnoremap :K vim.lsp.buf.hover))
(lspconfig.rls.setup {:capabilities cmp-capabilities})
(set vim.g.ale_rust_cargo_use_clippy true)
(set vim.g.ale_rust_cargo_check_all_targets true)
(set ale-fixers.rust ["rustfmt"])
(set ale-linters.rust ["cargo"])


;; Haskell
(au haskell :FileType "haskell"
    (b :nnoremap :<leader>lf ":ALEFix<CR>")
    (b :nnoremap :gd vim.lsp.buf.definition)
    (b :nnoremap :K vim.lsp.buf.hover))
(lspconfig.ghcide.setup {:capabilities cmp-capabilities})
(set ale-fixers.haskell ["hindent"])


;; C
(au c :FileType "c,cpp"
    (b :nnoremap :<leader>lf ":ALEFix<CR>")
    (b :vnoremap "=" vim.lsp.buf.range_formatting)
    (b :nnoremap :gd vim.lsp.buf.definition)
    (b :nnoremap :<leader>lr vim.lsp.buf.rename)
    (b :nnoremap "}" vim.lsp.buf.references)
    (b :nnoremap :K vim.lsp.buf.hover)
    (set vim.opt_local.tabstop 2)
    (set vim.opt_local.softtabstop 2)
    (set vim.opt_local.shiftwidth 2)
    (set vim.opt_local.expandtab true))
(lspconfig.ccls.setup {:capabilities cmp-capabilities})
(set ale-fixers.c ["clang-format" "clangtidy"])
(set ale-fixers.cpp ["clang-format" "clangtidy"])
(set ale-linters.c ["clang"])
(set ale-linters.cpp ["clang"])


;; Sexp
(set vim.g.sexp_filetypes "clojure,scheme,lisp,fennel")
(au sexp :FileType "clojure,scheme,lisp,fennel"
    (b :nmap :doe "<Plug>(sexp_raise_element)")
    (b :nmap :dof "<Plug>(sexp_raise_list)")

    ;; emulate text object for pair of elements
    ;; i.e. key/value binding/expr test/expr

    ;; pair forward
    (b :xmap :ip "<Plug>(sexp_inner_element)<Plug>(sexp_move_to_next_element_tail)")
    (b :omap :ip ":<C-U>normal vip<CR>")

    ;; pair backward
    (b :xmap :iP "<Plug>(sexp_inner_element)o<Plug>(sexp_move_to_prev_element_head)")
    (b :omap :iP ":<C-U>normal viP<CR>")

    ;; swap pair
    (b :nmap :>p "vip>eo<Esc>")
    (b :nmap :<p "vip<eo<Esc>")

    (b :xmap :>e "<Plug>(sexp_swap_element_forward)")
    (b :xmap :<e "<Plug>(sexp_swap_element_backward)")
    (b :xmap :>f "<Plug>(sexp_swap_list_forward)")
    (b :xmap :<f "<Plug>(sexp_swap_list_backward)"))


;; Clojure

(defn clj-ignore []
  ; navigate to beginnign of a text object
  (nu.normal "`[")
  ; prepend reader macro
  (nu.normal "i#_"))
(nu.fn-bridge :Clj_ignore :init :clj-ignore)

(defn do-clj-ignore [form]
  (set vim.opt.operatorfunc :Clj_ignore)
  (vim.api.nvim_feedkeys (.. "g@" (or form "")) :m false))

(au clojure :FileType "clojure"
    (b :nnoremap :<leader>lf ":ALEFix<CR>")
    (b :nnoremap :<leader>K lispdocs.split)
    (b :nmap :K "<localleader>K")
    (b :nmap :gd "<localleader>gd")

    (b :nnoremap :<leader>cc #(do-clj-ignore "aF"))
    (b :xnoremap :<leader>c do-clj-ignore)
    (b :nnoremap :<leader>cu ":let s=@/<CR>l?\\v(#_)+<CR>dgn:let @/=s<CR>")

    (set vim.opt_local.tabstop 2)
    (set vim.opt_local.softtabstop 2)
    (set vim.opt_local.shiftwidth 2)
    (set vim.opt_local.expandtab true)

    ;; converts package names into file names; useful for "gf"
    (set vim.opt_local.includeexpr "substitute(substitute(v:fname,'\\.','/','g'),'-','_','g')")
    (set vim.opt_local.suffixesadd ".clj"))
(set ale-fixers.clojure [:Cljfmt])
(set ale-linters.clojure [:clj-kondo])
(set vim.g.lispdocs_mappings false)
(set vim.g.clojure_fuzzy_indent true) ; use clojure syntax for indentation
(set vim.g.clojure_fuzzy_indent_patterns ["^with" "^def" "^let" "^Given" "^When" "^Then" "^And"])
(set vim.g.conjure#client#clojure#nrepl#test#current_form_names [:deftest :def-integration-test])
(set vim.g.conjure#client#clojure#nrepl#test#runner :kaocha)
(lspconfig.clojure_lsp.setup {:capabilities cmp-capabilities})

(defn cljfmt []
  {:read_temporary_file 1
   :command (.. "cljfmt fix %t"
                " --indents ~/.config/cljfmt/indentation.edn"
                " --remove-surrounding-whitespace"
                " --remove-trailing-whitespace"
                " --remove-consecutive-blank-lines"
                " --insert-missing-whitespace")})
(nu.fn-bridge :Cljfmt :init :cljfmt)



;; Slime
(set vim.g.slime_target :tmux)
(set vim.g.slime_dont_ask_default true)
(set vim.g.slime_default_config {:socket_name :default
                                 :target_pane "{right-of}"})
(set vim.g.slime_no_mappings true)
(k :xmap :<leader>s "<Plug>SlimeRegionSend")
(k :nmap :<leader>s "<Plug>SlimeMotionSend")
(k :nmap :<leader>ss "<Plug>SlimeLineSend")
(k :nmap :<leader>sc "<Plug>SlimeConfig")
(k :xnoremap :<leader>sy "\"sy")
(k :nnoremap :<leader>sp ":SlimeSend1 <C-R>s<CR>")


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
      :xml (.. "grep \"\\S\" | xmllint " vim.g.ale_xml_xmllint_options)})

(au rest :FileType "rest"
    (b :nnoremap :<leader>cd
       #(do
          (set vim.b.vrc_debug (not vim.b.vrc_debug))
          (set vim.b.vrc_show_command vim.b.vrc_debug)
          (core.println (if vim.b.vrc_debug "debug" "nodebug"))))
    (b :nnoremap :<leader>cs
       #(do
          (set vim.b.vrc_split_request_body (not vim.b.vrc_split_request_body))
          (core.println (if vim.b.vrc_split_request_body "split" "nosplit"))))
    (b :nnoremap :<leader>cc
       #(do
          (set vim.b.vrc_output_buffer_name
               (.. "[" (nvim.fn.expand "%:t") "@" (nvim.fn.strftime "%H:%M:%S") "]"
                   (string.gsub (nvim.get_current_line) "\""  "\\\"")))
          (nvim.fn.VrcQuery))))


;; Markdown
(set vim.g.markdown_syntax_conceal false)
(set vim.g.vim_markdown_folding_style_pythonic true)
(set vim.g.vim_markdown_override_foldtext false)


;; ALE
(set vim.g.ale_linters_explicit 1)
(set vim.g.ale_linters ale-linters)
(set vim.g.ale_fixers ale-fixers)
(k :nnoremap :L ":ALEDetail<CR>")
(k :nnoremap :yol ":ALEToggleBuffer<CR>")


;; Projectionist
(k :nnoremap :<leader>aa ":A<CR>")
(set vim.g.projectionist_heuristics
     {"project.clj|deps.edn" {"dev/*.clj" {:type "source"}
                              "src/*.clj" {:alternate "test/{}_test.clj"
                                           :type "source"}
                              "test/*_test.clj" {:alternate "src/{}.clj" :type "test"}}})


;; Terminal
(k :tnoremap :<Esc> "<C-\\><C-n>") ; use Esc to exit terminal mode
(k :tnoremap :<C-v><Esc> "<Esc>") ; press Esc in terminal mode
(au terminal-open :TermOpen "*"
    (set vim.opt_local.statusline "%{b:term_title}")
    (set vim.opt_local.bufhidden "hide"))
(au terminal-leave :TermLeave "*"
    (when (and vim.b.terminal_job_pid vim.b.term_title)
      (vim.cmd (.. "file term:" vim.b.terminal_job_pid ":" vim.b.term_title))))
