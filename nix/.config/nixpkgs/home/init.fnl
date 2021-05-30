(module init
  {autoload {nvim aniseed.nvim}
   require {telescope telescope}})

(set nvim.g.mapleader " ")
(set nvim.g.maplocalleader "	")

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
