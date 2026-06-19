(setq inhibit-startup-message t)

(scroll-bar-mode -1)           ; Disable visible scrollbar
(tool-bar-mode -1)             ; Disable the toolbar
(tooltip-mode -1)              ; Disable tooltip mode
(windmove-default-keybindings) ; Navigate between split windows using Shift + Arrow keys
(setq visible-bell t)          ; Gives you visible sign in case you hit an edge of a file or the emacs doesn't like something you do


;; Initialize package source
(require 'package)
(setq package-archives '(("gnu"    . "http://elpa.gnu.org/packages/")
                         ("nongnu" . "http://elpa.nongnu.org/packages/")
                         ("melpa"  . "http://melpa.org/packages/")))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

(setq use-package-always-ensure t)

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)
  (evil-set-initial-state 'vterm-mode 'emacs))


(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package doom-themes)
(load-theme 'doom-solarized-light t) ; Load the theme I prefer


;; Required for the :diminish keyword to work properly
(use-package diminish)

;; Your custom which-key configuration
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(set-face-attribute 'default nil :height 140) ;; Set default font size

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-x b" . ivy-switch-buffer))
  :config
  (counsel-mode 1))

;; Required for the icons to display correctly
(use-package all-the-icons)

;; The beautiful status bar
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15))
)

(column-number-mode)

(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                eshell-mode-hook
                vterm-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode -1))))

;; Make line numbers relative
(setq display-line-numbers-type 'relative)

(use-package vterm
  :commands vterm
  :config
  (setq vterm-max-scrollback 10000))

(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))


;; The modern replacement for evil-magit
(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1)
)

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . counsel-minibuffer-history)))

(use-package helpful
  :ensure t
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(global-set-key (kbd "C-s-j") 'counsel-switch-buffer)

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; Tells projectile where to look for your projects!
  (when (file-directory-p "~/Documents/GitHub")
    (setq projectile-project-search-path '("~/Documents/GitHub")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode)) 

(defun my/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package org
  :hook (org-mode . my/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-agenda-files '("~/Documents/GitHub/bmacs/orgFiles/Task.org")))


(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  ;; This is where you define your bullet hierarchy!
  ;; Level 1, Level 2, Level 3, etc...
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;; Replace list hyphen with dot
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(dolist (face '((org-level-1 . 1.2)
                (org-level-2 . 1.1)
                (org-level-3 . 1.05)
                (org-level-4 . 1.0)
                (org-level-5 . 1.1)
                (org-level-6 . 1.1)
                (org-level-7 . 1.1)
                (org-level-8 . 1.1)))
  (set-face-attribute (car face) nil :font "Arial" :weight 'regular :height (cdr face)))

(defun my/org-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-line-mode 1)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . my/org-visual-fill))


(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python     . t)
     (java       . t)
     (js         . t)       ;; This handles JavaScript via Node.js
     (shell      . t)))     ;; This handles Shell, Bash, and Sh

  ;; Stop Emacs from asking "Are you sure?" every time you run code
  (setq org-confirm-babel-evaluate nil)
  (setq org-babel-python-command "python3")) ;; 

(require 'org-tempo)


