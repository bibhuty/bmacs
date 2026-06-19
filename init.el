;; Initialize the package system so Emacs can download tools
(require 'package)
(setq package-archives '(("gnu"    . "http://elpa.gnu.org/packages/")
                         ("nongnu" . "http://elpa.nongnu.org/packages/")
                         ("melpa"  . "http://melpa.org/packages/")))
(package-initialize)

;; Tell Emacs to extract the code from config.org and run it
(org-babel-load-file 
 (expand-file-name "config.org" 
                   (file-name-directory (or load-file-name buffer-file-name))))
