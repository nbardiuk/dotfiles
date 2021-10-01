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

;; Auto-indent while typing
(use-package aggressive-indent
  :diminish aggressive-indent-mode
  :config (global-aggressive-indent-mode +1))

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
  (modus-themes-load-operandi))

;; Modeline
(use-package smart-mode-line
  :config
  (setq sml/theme 'light)
  (add-hook 'after-init-hook 'sml/setup))

;; Font
(use-package frame
  :straight nil
  :config (set-face-attribute 'default nil
			      :weight 'normal
			      :height 135
			      :family "Iosevka"))

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
  (add-to-list 'super-save-hook-triggers 'evil-normal-state-entry-hook) ; autosave when back to normal mode
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

;; Vi
(use-package evil
  :init (setq evil-want-C-u-scroll t
              evil-want-keybinding nil
              evil-undo-system 'undo-fu)
  :hook (after-init . evil-mode))

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
;; fix PATH
(use-package emacs
  :straight nil
  :config
  (setq exec-path (cons "~/.nix-profile/bin" exec-path)))

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
  (evil-global-set-key 'normal (kbd "SPC f") 'consult-ripgrep)
  (evil-global-set-key 'normal (kbd "SPC n") 'consult-find)
  (evil-global-set-key 'normal (kbd "SPC k") 'consult-apropos))

(use-package consult-flycheck
  :after evil
  :config
  (evil-global-set-key 'normal (kbd "SPC l e") 'consult-flycheck))

;; Completion annotations
(use-package marginalia
  :init (marginalia-mode))

;; Less strict filtering of completions
(use-package orderless
  :custom (completion-styles '(orderless)))

;; Completions actions
(use-package embark
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

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

(use-package diff-hl
  :after magit
  :config
  (global-diff-hl-mode)
  (diff-hl-show-hunk-mouse-mode) ; make highlight clickable
  (diff-hl-flydiff-mode) ; show diffs without saving
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (evil-global-set-key 'normal (kbd "SPC h u") 'diff-hl-revert-hunk)
  (evil-global-set-key 'normal (kbd "SPC h d") 'diff-hl-show-hunk))

;; Project
(use-package projectile
  :diminish projectile-mode
  :init (projectile-mode +1)
  :config
  (setq projectile-sort-order 'access-time)
  (setq projectile-project-search-path '("~/src/" "~/dev/"))
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
  :config
  (define-clojure-indent
    (Given 1)
    (When 1)
    (Then 1)
    (And 1)))
(use-package cider)

;; Markdown
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . gfm-mode)))

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
