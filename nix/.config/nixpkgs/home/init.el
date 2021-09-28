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
  :config (evil-collection-init))

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

;; Git
(use-package magit
  :bind ("C-x g" . magit-status)
  :config (add-hook 'with-editor-mode-hook #'evil-insert-state))

(use-package diff-hl
  :after magit
  :config
  (global-diff-hl-mode)
  (diff-hl-margin-mode)
  (diff-hl-show-hunk-mouse-mode)
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(diff-hl evil-surround flycheck modus-themes use-package monotropic-theme markdown-mode magit evil-commentary evil-collection cider aggressive-indent)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
