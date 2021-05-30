(module init
  {autoload {telescope telescope
             compe compe
             nvim aniseed.nvim}})

(set vim.g.mapleader " ")
(set vim.g.maplocalleader "\t")

(telescope.setup
  {:defaults {:prompt_position :top
              :sorting_strategy :ascending}})

(nvim.set_keymap
  :n :<leader>k
  (.. ":lua require('telescope.builtin').help_tags{"
      "  previewer = false,"
      "  prompt_prefix = 'Help> ',"
      "}<cr>")
  {:noremap true
   :silent true})

(nvim.set_keymap
  :n :<leader><leader>
  (.. ":lua require('telescope.builtin').commands{"
      "  previewer = false,"
      "  prompt_prefix = 'Commands> ',"
      "}<cr>")
  {:noremap true
   :silent true})

(nvim.set_keymap :n :<leader>la ":lua require('telescope.builtin').lsp_code_actions()<cr>" {:noremap true :silent true})

(nvim.set_keymap
  :n :<leader>n
  (.. ":lua require('telescope.builtin').find_files{"
      "  previewer = false,"
      "  find_command = {"
      "    'fd',"
      "    '--no-ignore',"
      "    '--hidden',"
      "    '--exclude', '.git',"
      "    '--exclude', 'target',"
      "    '--exclude', 'node_modules',"
      "    '--exclude', 'build',"
      "    '--exclude', '.clj-kondo',"
      "    '--exclude', '.cpcache',"
      "    '--exclude', '.venv'"
      "  },"
      "  prompt_prefix = 'Files> '"
      "}<CR>")
  {:noremap true
   :silent true})

(nvim.set_keymap
  :n :<leader>e
  (.. ":lua require('telescope.builtin').buffers{"
      "  previewer = false,"
      "  sort_lastused = true,"
      "  ignore_current_buffer = true,"
      "  prompt_prefix = 'Buf> '"
      "}<CR>")
  {:noremap true
   :silent true})

(nvim.set_keymap
  :n :<leader>wn
  (.. ":lua require('telescope.builtin').find_files{"
      "  previewer = false,"
      "  find_command = {"
      "    'fd',"
      "    '--exclude', '.stversions',"
      "    '--exclude', '.stfoldre',"
      "  },"
      "  cwd = '" nvim.g.wiki_root"',"
      "  prompt_prefix = 'Wiki> '"
      "}<CR>")
  {:noremap true
   :silent true})


(compe.setup
  {:enabled true
   :autocomplete false
   :debug false
   :min_length 1
   :preselect :enable
   :throttle_time 80
   :source_timeout 200
   :incomplete_delay 400
   :max_abbr_width 100
   :max_kind_width 100
   :max_menu_width 100
   :documentation true
   :source {:path true
            :buffer true
            :nvim_lsp true
            :omni true
            :conjure true}})

(nvim.ex.inoremap "<silent><expr> <C-N> compe#complete()")

(set vim.opt.completeopt "menuone,noselect")
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

(set vim.g.loaded_python_provider 0) ; disable python 2 support

(set vim.opt.spelllang :en_us)     ; spell check
(set vim.opt.spell false)          ; disabled by default
(vim.opt.spellsuggest:append "10") ; limit spell suggestions list

(set vim.opt.wildmode "list:longest,full") ; commands completion
(set vim.opt.wildignorecase true)          ; case is ignored when completing file names and directories

(set vim.opt.list true)
(set vim.opt.listchars {:trail "·" :tab "▸ " :nbsp "+"}) ; display tabs and trailing spaces visually
(set vim.opt.showbreak "↳ ")                             ; a soft wrap break symbol

(set vim.opt.shell "/home/nazarii/.nix-profile/bin/zsh")

(set vim.opt.winwidth 80)     ; minimal width of active window
(set vim.opt.winminwidth 10)  ; minimal width of inactive window
(set vim.opt.winheight 50)    ; minimal height of active window
(set vim.opt.winminheight 10) ; minimal height of inactive window


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
(vim.cmd "colorscheme mycolors")

(set vim.g.fzf_colors
     {:bg ["bg" "Normal"]
      :bg+ ["bg" "Normal"]
      :border ["fg" "Ignore"]
      :fg ["fg" "Normal"]
      :fg+ ["fg" "Normal"]
      :header ["fg" "Comment"]
      :hl ["fg" "Comment"]
      :hl+ ["fg" "Statement"]
      :info ["fg" "PreProc"]
      :marker ["fg" "Keyword"]
      :pointer ["fg" "Exception"]
      :prompt ["fg" "Conditional"]
      :spinner ["fg" "Label"]})

(set vim.env.FZF_DEFAULT_OPTS "--reverse")
(set vim.g.fzf_layout {:window {:border "top" :height 1 :width 0.6}})
(set vim.g.fzf_preview_window "")

(set vim.opt.ruler false)      ; line and column number of the cursor position
(set vim.opt.laststatus 2)     ; 2 - allways show status line
(set vim.opt.showmode false)   ; dissable mode message
(set vim.opt.title true)       ; update window title
(set vim.opt.titlestring "%f") ; file name in title

(set vim.opt.foldmethod :syntax)
(set vim.opt.foldenable true)    ; enable folding
(set vim.opt.foldlevelstart 999) ; all folds are open
(set vim.opt.fillchars "fold:‧")
(set vim.g.crease_foldtext {:default "%{repeat(\"  \", v:foldlevel - 1)}%t %= %l lines %f%f"})

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

(set vim.opt.gdefault true)   ; use global substitution
(set vim.opt.ignorecase true) ; Ignore case when searching...
(set vim.opt.smartcase true)  ; ...unless we type a capital

(set vim.g.FerretExecutable "rg")
(set vim.g.FerretExecutableArguments
     {:rg (.. "--vimgrep"
              " --no-heading"
              " --smart-case"
              " --sort path"
              " --no-ignore"
              " --hidden"
              " --glob=!.git"
              " --glob=!target"
              " --glob=!node_modules"
              " --glob=!build"
              " --glob=!.clj-kondo"
              " --glob=!.cpcache")})


(set vim.opt.path
     [ "." ; current file
      "**" ; children subdirectories 'starstar'
      ])

(set vim.g.loaded_netrw 1)
(set vim.g.loaded_netrwPlugin 1)
(set vim.g.dirvish_mode ":sort ,^.*[\\/],")

; If this many milliseconds nothing is typed the swap file will be written to disk speedsup gitgutter
(set vim.opt.updatetime 100)

(vim.opt.diffopt:append "indent-heuristic,internal,algorithm:histogram")

(set vim.g.ale_fixers
     {:* ["remove_trailing_lines" "trim_whitespace"]
      :c ["clang-format" "clangtidy"]
      :clojure ["cljfmt"]
      :haskell ["hindent"]
      :json ["jq"]
      :nix ["nixpkgs-fmt"]
      :rust ["rustfmt"]
      :css ["prettier" "stylelint"]
      :scss ["prettier" "stylelint"]
      :sh ["shfmt"]
      :sql ["pgformatter"]
      :javascript ["eslint" "prettier"]
      :typescript ["prettier"]
      :typescriptreact ["prettier"]
      :xml ["xmllint"]})

(set vim.g.ale_linters
     {:c ["clang"]
      :clojure ["clj-kondo"]
      :css ["stylelint"]
      :scss ["stylelint"]
      :nix ["nix"]
      :rust ["cargo"]
      :sh ["shellcheck"]
      :sql ["sqlint"]
      :javascript ["eslint"]
      :typescript ["tsserver" "tslint"]
      :xml ["xmllint"]})

(set vim.g.ale_json_jq_options "--monochrome-output --indent 2")
(set vim.g.ale_xml_xmllint_options "--format --nonet --recover -")
(set vim.g.ale_sql_pgformatter_options "--spaces 4 --comma-break")
(set vim.g.ale_rust_cargo_use_clippy 1)
(set vim.g.ale_rust_cargo_check_all_targets 1)
(set vim.g.ale_sh_shfmt_options "-i=2 -sr")
