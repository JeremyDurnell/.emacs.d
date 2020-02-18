;; This is an import that ships with emacs.
;; package is Emacs's package manager.
(require 'package)

;; Emacs has an official repository of packages and a more current
;; unofficial one. Melpa is the 'unoffical one' (which in this
;; case translates to more up to date, newer, and by extension,
;; a bit more volatile). The official repo is called org. This
;; repo is slow changing and extremely stable (but doesn't have
;; all the cool/cutting edge packages that are being used).
(push '("melpa" . "http://melpa.org/packages/") package-archives)
(push '("org" . "http://orgmode.org/elpa/") package-archives)
(push '("melpa-stable" . "https://stable.melpa.org/packages/") package-archives)

;; After the repositories have been set, initialize the package
;; manager. If package-initialize fails, call package-refresh-contents and retry
(condition-case nil
    (package-initialize)
    (error (package-refresh-contents)(package-initialize)))

;; define function
(defun jkd-reinstall-packages-core ()  

  ;; Emacs keeps a cache of the package list locally. We'll
  ;; initialize this cache once. If you ever go to install a package
  ;; and it cant be found, just rerun (package-reresh-contents).
  (unless package-archive-contents (package-refresh-contents))

  ;; Here is our big bad package list. Whenever you want to
  ;; install a new package, just add it to this list.
  (setq bootstrap-list
	'(use-package))

  (dolist (package bootstrap-list)
    (unless (package-installed-p package)
      (package-install package))))

(defun jkd-reinstall-packages ()
  (interactive) (jkd-reinstall-packages-core))

(jkd-reinstall-packages-core)

(setq backup-directory-alist `(("." . "~/.saves")))

(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-C-i-jump nil)
  :config

  (evil-mode 1)

  ;; wire up emacs so that I can spam the escape key and
  ;; exit whatever ridiculous window/buffer it has me in.
  (defun minibuffer-keyboard-quit ()
    (interactive)
    (if (and delete-selection-mode transient-mark-mode mark-active)
  	(setq deactivate-mark  t)
      (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
      (abort-recursive-edit)))

  (define-key evil-normal-state-map [escape] 'keyboard-quit)
  (define-key evil-visual-state-map [escape] 'keyboard-quit)
  (define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

  (global-set-key [escape] 'evil-exit-emacs-state)

  ;; In Tmux and iTerm, change the normal/edit mode cursors.
  (defun evil-send-string-to-terminal (string)
    (unless (display-graphic-p) (send-string-to-terminal string)))

  ;;VTE_CURSOR_STYLE_TERMINAL_DEFAULT = 0,
  ;;VTE_CURSOR_STYLE_BLINK_BLOCK      = 1,
  ;;VTE_CURSOR_STYLE_STEADY_BLOCK     = 2,
  ;;VTE_CURSOR_STYLE_BLINK_UNDERLINE  = 3,
  ;;VTE_CURSOR_STYLE_STEADY_UNDERLINE = 4,
  ;;/* *_IBEAM are xterm extensions */
  ;;VTE_CURSOR_STYLE_BLINK_IBEAM      = 5,
  ;;VTE_CURSOR_STYLE_STEADY_IBEAM     = 6
  (defun evil-terminal-cursor-change ()
    (unless (display-graphic-p)
      (add-hook 'evil-insert-state-entry-hook (lambda () (evil-send-string-to-terminal "\033[5 q")))
      (add-hook 'evil-insert-state-exit-hook  (lambda () (evil-send-string-to-terminal "\033[0 q"))))
    (when (and (getenv "TMUX")  (string= (getenv "TERM_PROGRAM") "iTerm.app"))
      (add-hook 'evil-insert-state-entry-hook (lambda () (evil-send-string-to-terminal "\ePtmux;\e\e]50;CursorShape=1\x7\e\\")))
      (add-hook 'evil-insert-state-exit-hook  (lambda () (evil-send-string-to-terminal "\ePtmux;\e\e]50;CursorShape=0\x7\e\\")))))

  (evil-terminal-cursor-change))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package org
  :ensure t
  )

(use-package org-evil
  :after org  
  :ensure t
  )

;;(debug-on-entry 'display-warning)

(use-package ggtags  
  :if (memq window-system '(x))
  :ensure t
  :config
  (add-hook 'c-mode-common-hook
    (lambda ()
      (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
  (add-hook 'dired-mode-hook 'ggtags-mode)
  (ggtags-mode 1)))))

;; replace default buffer list with ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; enable Vi jump-forward (use :jumps to view jump list)
(global-set-key (kbd "C-S-o") 'evil-jump-forward)

;; cycle through buffers with Ctrl-Tab (like Firefox)
(global-set-key (kbd "<C-tab>") 'previous-buffer)
(global-set-key (kbd "<C-S-iso-lefttab>") 'next-buffer)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (ggtags evil-collection evil ##))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

