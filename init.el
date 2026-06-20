;; Initialize the package system so Emacs can download tools
(require 'package)
(setq package-archives '(("gnu"    . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/packages/")
                         ("melpa"  . "https://melpa.org/packages/")))
(package-initialize)

;; Tell Emacs to extract the code from config.org and run it
(org-babel-load-file 
 (expand-file-name "Config.org" 
                   (file-name-directory (or load-file-name buffer-file-name))))
