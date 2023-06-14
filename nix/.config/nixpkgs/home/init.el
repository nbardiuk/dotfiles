;; TODO move to early init 
(setq package-enable-at-startup nil)

;; Setup straight
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Setup use-package
(straight-use-package 'use-package)
(eval-and-compile
  (setq straight-use-package-by-default t
        use-package-expand-minimally t))

;; Remove custom-set configuration
(use-package cus-edit
  :straight nil
  :config
  (setq custom-file (concat user-emacs-directory "trash.el")))

;; hide minor modes
(use-package diminish
  :demand t)

;; Show matching parentheses
(use-package paren
  :straight nil
  :init (setq show-paren-delay 0)
  :config (show-paren-mode +1))

;; Auto-close matching parens and quotes
(use-package elec-pair
  :straight nil
  :hook (prog-mode . electric-pair-mode))

;; Navigate trees of parens
(use-package symex
  :diminish (symex-mode symex-editing-mode)
  :after evil
  :config
  (setq symex--user-evil-keyspec
        '(("j" . symex-go-up)
          ("k" . symex-go-down)
          ("C-j" . symex-climb-branch)
          ("C-k" . symex-descend-branch)
          ("M-j" . symex-goto-highest)
          ("M-k" . symex-goto-lowest)))
  (symex-initialize)
  (evil-global-set-key 'normal (kbd "SPC s") 'symex-mode-interface)
  :custom
  (symex-modal-backend 'evil))

;; Indent
(use-package emacs
  :straight nil
  :config
  (setq-default indent-tabs-mode nil)
  (setq tab-width 2))

;; Unclutter UI
(use-package emacs
  :config
  (setq inhibit-startup-screen t)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (blink-cursor-mode -1))

;; Theme
(use-package modus-themes
  :init (modus-themes-load-themes)
  :config
  (setq custom-safe-themes t) ; a workaround to disable prompt at startup
  (setq modus-themes-diffs 'desaturated)
  (setq modus-themes-syntax '(faint))
  (add-hook 'modus-themes-after-load-theme-hook
            (lambda ()
              (modus-themes-with-colors
                (custom-set-faces
                 `(term-color-black ((,class :background "gray80" :foreground "gray80")))))))
  (modus-themes-load-operandi))

;; Modeline
(use-package smart-mode-line
  :config
  (setq sml/theme 'light)
  (add-hook 'after-init-hook 'sml/setup))

;; Font
(use-package frame
  :straight nil
  :config
  (set-face-attribute 'default nil :height 120 :family "Iosevka")
  (set-face-attribute 'variable-pitch nil :height 120 :family "Source Sans Pro"))

(use-package mixed-pitch
  :hook
  (gfm-mode . mixed-pitch-mode)
  (org-mode . mixed-pitch-mode))

(use-package files
  :straight nil
  :config
  (setq create-lockfiles nil
        make-backup-files nil
        auto-save-default nil)
  (setq backup-directory-alist `((".*" . ,temporary-file-directory)))
  (setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t))))

(use-package super-save
  :diminish super-save-mode
  :config
  (setq super-save-auto-save-when-idle t)
  (add-to-list 'super-save-hook-triggers 'evil-normal-state-entry-hook) ; auto-save when back to normal mode
  (super-save-mode +1))

;; Remember cursor position in buffer
(use-package saveplace
  :config
  (save-place-mode +1))

;; Slowdown mouse scroll
(use-package mwheel
  :straight nil
  :config (setq mouse-wheel-scroll-amount '(2 ((shift) . 1))
                mouse-wheel-progressive-speed nil))


;; nice scrolling
(use-package emacs
  :straight nil
  :config
  (setq scroll-margin 0
        scroll-conservatively 100000
        scroll-preserve-screen-position 1))


;; Undo
(use-package undo-fu)
(use-package undo-fu-session
  :config
  (setq undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))
  (global-undo-fu-session-mode))


;; Vi
(use-package evil
  :init (setq evil-want-C-u-scroll t
              evil-want-keybinding nil
              evil-undo-system 'undo-fu)
  :hook (after-init . evil-mode)
  :config
  (evil-global-set-key 'visual "/"
                       (lambda ()
                         (interactive)
                         (let ((input (buffer-substring-no-properties (region-beginning) (region-end))))
                           (evil-exit-visual-state)
                           (evil-search input t t)))))

(use-package evil-collection
  :diminish evil-collection-unimpaired-mode
  :after evil
  :config
  (evil-collection-init))

(use-package evil-commentary
  :after evil
  :diminish
  :config (evil-commentary-mode 1))

(use-package evil-surround
  :config (global-evil-surround-mode 1))

(use-package evil-indent-plus
  :config (evil-indent-plus-default-bindings))

;; Dired
(use-package dired
  :straight nil
  :after evil
  :config
  (evil-global-set-key 'normal (kbd "-") 'dired-jump)
  (setq dired-listing-switches "-l --group-directories-first --no-group --human-readable --almost-all")
  (setq dired-recursive-deletes 'always)
  (setq dired-recursive-copies 'always))

;; Shell
(use-package emacs
  :straight nil
  :config
  (setq shell-file-name "~/.nix-profile/bin/zsh")
  (setq exec-path (cons "~/.nix-profile/bin" exec-path)))

(use-package direnv
  :config
  (direnv-mode))

;; Completion menu
(use-package vertico
  :init (vertico-mode)
  (setq vertico-resize t)
  (setq vertico-cycle t))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init (savehist-mode))

;; Completion commands
(use-package consult
  :after evil
  :config
  (recentf-mode) ; enable tracking of recent files
  (setq consult-project-root-function #'projectile-project-root)
  (setq consult-find-args "find .")
  (evil-global-set-key 'normal (kbd "SPC e") 'consult-buffer)
  (evil-global-set-key 'normal (kbd "SPC n") 'consult-find)
  (evil-global-set-key 'normal (kbd "SPC k") 'consult-apropos)
  (evil-global-set-key 'normal (kbd "SPC f") 'consult-ripgrep)
  (evil-global-set-key 'visual (kbd "SPC f")
                       (lambda ()
                         (interactive)
                         (let ((input (buffer-substring-no-properties (region-beginning) (region-end))))
                           (evil-exit-visual-state)
                           (isearch-update-ring input t) ; allow to use n to search next
                           (consult-ripgrep nil input)))))

(use-package consult-flycheck
  :after evil
  :config
  (evil-global-set-key 'normal (kbd "SPC a e") 'consult-flycheck))

;; Completion annotations
(use-package marginalia
  :init (marginalia-mode))

;; Less strict filtering of completions
(use-package orderless
  :custom (completion-styles '(orderless)))

;; Completions actions
(use-package embark
  :bind (("M-," . embark-act)) 

  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; Replace in search results
(use-package wgrep)

;; Git
(use-package magit
  :after evil
  :config
  (evil-global-set-key 'normal (kbd "SPC g s") 'magit-status)
  (evil-global-set-key 'normal (kbd "SPC g l") 'magit-log-all))

(use-package git-gutter
  :diminish git-gutter-mode
  :custom
  (git-gutter:modified-sign " ")
  (git-gutter:added-sign " ")
  (git-gutter:deleted-sign " ")
  (git-gutter:visual-line t)
  :config
  (global-git-gutter-mode +1)
  (evil-global-set-key 'normal (kbd "SPC h u") 'git-gutter:revert-hunk)
  (evil-global-set-key 'normal (kbd "SPC h s") 'git-gutter:stage-hunk)
  (evil-global-set-key 'normal (kbd "SPC h d") 'git-gutter:popup-hunk))

(use-package browse-at-remote
  :config
  (setq browse-at-remote-add-line-number-if-no-region-selected nil))

;; Project
(use-package projectile
  :diminish projectile-mode
  :init (projectile-mode +1)
  :config
  (setq projectile-sort-order 'access-time)
  (setq projectile-project-search-path '("~/code/"))
  (evil-global-set-key 'normal (kbd "SPC p") 'projectile-command-map))

;; Autocomplete
(use-package company
  :diminish company-mode
  :hook (prog-mode . company-mode)
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.1
        company-selection-wrap-around t
        company-tooltip-align-annotations t
        company-frontends '(company-pseudo-tooltip-frontend ; show tooltip even for single candidate
                            company-echo-metadata-frontend))
  (evil-global-set-key 'insert (kbd "C-n") 'company-complete)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous))

;; Linting
(use-package flycheck
  :diminish flycheck-mode
  :init (global-flycheck-mode))

;; Formatting
(use-package format-all)

;; Clojure
(use-package clojure-mode
  :hook ((clojure-mode . lsp)))

(use-package cider
  :config
  (setq cider-repl-display-help-banner nil) )

;; Markdown
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . gfm-mode))
  :custom
  (markdown-header-scaling t)
  (markdown-fontify-code-blocks-natively t))

;; Text
(use-package text-mode
  :straight nil
  :config (add-hook 'text-mode-hook 'visual-line-mode)
  (evil-global-set-key 'normal (kbd "SPC t w") 'visual-line-mode))

;; Nix
(use-package nix-mode
  :mode ("\\.nix\\'" "\\.nix.in\\'"))
(use-package nix-drv-mode
  :straight nil
  :after nix-mode
  :mode "\\.drv\\'")

;; Yaml
(use-package yaml-mode
  :mode ("\\.yml\\'" "\\.yaml\\'"))

;; Time
(use-package time
  :straight nil
  :custom
  (display-time-24hr-format t)
  (display-time-world-time-format " %H:%M  %d %b  %Z")
  (display-time-world-list '(("America/Los_Angeles" "US Pacific")
                             ("America/Denver"      "US Mountain")
                             ("America/Chicago"     "US Center")
                             ("America/New_York"    "US East")
                             ("UTC"                 "UTC")
                             ("Europe/Lisbon"       "EU West")
                             ("Europe/Paris"        "EU Center")
                             ("Europe/Bucharest"    "EU East")
                             ("Asia/Calcutta"       "India")
                             ("Asia/Tokyo"          "Japan"))))

;; Char jump
(use-package avy
  :after evil
  :config
  (evil-global-set-key 'normal (kbd "SPC '") 'avy-goto-char-timer)
  (setq avy-timeout-seconds 0.5))

;; Semantic selection
(use-package expand-region
  :after evil
  :config
  (evil-global-set-key 'visual (kbd "-") 'er/contract-region)
  (evil-global-set-key 'visual (kbd "+") 'er/expand-region)
  (evil-global-set-key 'normal (kbd "+") (lambda ()
                                           (interactive)
                                           (evil-visual-char)
                                           (er/expand-region 1))))

;; Terraform
(use-package terraform-mode
  :custom (terraform-indent-level 2))
(use-package hcl-mode
  :custom (hcl-indent-level 2))

;; Makefiles
(use-package makefile-executor
  :config
  (add-hook 'makefile-mode-hook 'makefile-executor-mode))

;; Thesaurus
(use-package powerthesaurus)

;; Which key
(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode +1)
  (setq which-key-idle-delay 0.2)
  (setq which-key-idle-secondary-delay 0.2))

;; LSP
(use-package lsp-mode
  :hook ((lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :config
  (evil-global-set-key 'normal (kbd "SPC l") lsp-command-map)
  (setq lsp-enable-symbol-highlighting nil))

;; Javascrip
(use-package js2-mode
  :hook ((js-mode . lsp))
  :commands js2-minor-mode
  :init (add-hook 'js-mode-hook 'js2-minor-mode))

(use-package typescript-mode
  :hook ((typescript-mode . lsp))
  :config
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))
  (setq typescript-indent-level 2))

(use-package json-mode
  :config
  (setq json-reformat:indent-width 2))

;; Python
(use-package python-mode
  :straight nil
  :hook ((python-mode . lsp)))

;; Fennel
(use-package fennel-mode)

;; Line numbers
(use-package display-line-numbers
  :straight nil
  :config
  (evil-global-set-key 'normal (kbd "SPC t n") 'display-line-numbers-mode)
  (evil-global-set-key 'normal (kbd "SPC t N") 'global-display-line-numbers-mode))

;; Spelling
(use-package ispell
  :straight nil
  :custom
  (ispell-program-name "aspell"))

(use-package flyspell
  :straight nil
  :config
  (add-hook 'text-mode-hook 'flyspell-mode)
  (add-hook 'prog-mode-hook 'flyspell-prog-mode)
  (evil-global-set-key 'normal (kbd "SPC t s") 'flyspell-mode))

(use-package flyspell-correct
  :after flyspell
  :config
  (evil-global-set-key 'normal (kbd "z =") 'flyspell-correct-at-point))

;; Org
(use-package org
  :straight nil
  :config
  (setq org-indent-indentation-per-level 1)
  (setq org-adapt-indentation nil)
  (setq org-hide-leading-stars t))
