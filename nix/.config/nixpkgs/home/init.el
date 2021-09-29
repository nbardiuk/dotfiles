;; Setup use-package
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

;; Remove custom-set configuration
(use-package cus-edit
  :ensure nil
  :config
  (setq custom-file (concat user-emacs-directory "trash.el")))

;; Show matching parentheses
(use-package paren
  :ensure nil
  :init (setq show-paren-delay 0)
  :config (show-paren-mode +1))

;; Auto-close matching parens and quotes
(use-package elec-pair
  :ensure nil
  :hook (prog-mode . electric-pair-mode))

;; Auto-indent while typing
(use-package aggressive-indent
  :config (global-aggressive-indent-mode +1))

;; Unclutter UI
(use-package emacs
  :config
  (setq inhibit-startup-screen t)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1))

;; Theme
(use-package modus-themes
  :init (modus-themes-load-themes)
  :config
  (setq custom-safe-themes t) ; a workaround to disable prompt at startup
  (modus-themes-load-operandi))

;; Font
(use-package frame
  :ensure nil
  :config (set-face-attribute 'default nil
			      :weight 'normal
			      :height 135
			      :family "Iosevka"))

(use-package files
  :ensure nil
  :config (setq create-lockfiles nil
		make-backup-files nil))

;; Slowdown mouse scroll
(use-package mwheel
  :ensure nil
  :config (setq mouse-wheel-scroll-amount '(2 ((shift) . 1))
                mouse-wheel-progressive-speed nil))

;; Vi
(use-package evil
  :init (setq evil-want-C-u-scroll t
	      evil-want-keybinding nil)
  :hook (after-init . evil-mode))

(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-company-use-tng nil)
  (evil-collection-init))

(use-package evil-commentary
  :after evil
  :diminish
  :config (evil-commentary-mode 1))

(use-package evil-surround
  :config (global-evil-surround-mode 1))

;; Dired
(use-package dired
  :ensure nil
  :after evil
  :config (evil-global-set-key 'normal (kbd "-") 'dired-jump))

;; Completion commands
(use-package vertico
  :init (vertico-mode)
  (setq vertico-resize t)
  (setq vertico-cycle t))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init (savehist-mode))

;; Consult
(use-package consult
  :after evil
  :config
  (recentf-mode) ; enable tracking of recent files
  (evil-global-set-key 'normal (kbd "SPC e") 'consult-buffer))

;; Completion annotations
(use-package marginalia
  :init (marginalia-mode))

;; Less strict filtering
(use-package orderless
  :custom (completion-styles '(orderless)))

;; Git
(use-package magit
  :after evil
  :config
  (add-hook 'with-editor-mode-hook #'evil-insert-state)
  (evil-global-set-key 'normal (kbd "SPC g s") 'magit-status)
  (evil-global-set-key 'normal (kbd "SPC g l") 'magit-log-all))

(use-package diff-hl
  :after magit
  :config
  (global-diff-hl-mode)
  (diff-hl-margin-mode)
  (diff-hl-show-hunk-mouse-mode) ; make margin clickable
  (diff-hl-flydiff-mode) ; show diffs without saving
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (evil-global-set-key 'normal (kbd "SPC h u") 'diff-hl-revert-hunk)
  (evil-global-set-key 'normal (kbd "SPC h d") 'diff-hl-show-hunk))

;; Project
(use-package projectile
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
  :init (global-flycheck-mode))

;; Clojure
(use-package clojure-mode)
(use-package cider)

;; Markdown
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . gfm-mode)))
