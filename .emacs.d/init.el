;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/")
             '("org" . "https://orgmode.org/elpa/"))
(package-initialize)

;; function to add to load-path
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))
;; folders to be added to load-path
(add-to-load-path "elpa" "elisp" "conf" "public_repos")

;; Solarized theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/public_repos/emacs-color-theme-solarized")
(load-theme 'solarized t)
;; Tranpacent background
(set-face-background 'default "unspecified-bg")
(set-face-foreground 'default "green")
(set-face-foreground 'font-lock-comment-face "white")
(set-face-foreground 'font-lock-doc-face "white")
(set-face-foreground 'font-lock-comment-delimiter-face "white")

;; set default charater code
(prefer-coding-system 'utf-8-unix)

;; change default fonts
(set-face-attribute 'default nil
                    :family "Noto Sans JP"
                    :height 130)
(setq face-font-rescale-alist
      '("Noto Sans JP" . 1.0))  

;; display column number, column row in mini buffer 
(column-number-mode t)

;; display column number in left side
(global-linum-mode t)

;; line number format
(setq linum-format "%3d")
;; color for line number
(set-face-foreground 'linum "brightred")
(set-face-background 'linum "unspecified")

;; set default character code UTF-8
(prefer-coding-system 'utf-8)

;; display file path in title bar
(setq frame-title-format "%f")

;;; do not display menu-bar
;; Use "M-x menu-bar-mode" to toggle
(menu-bar-mode -1)

;; auto add linebreak to end of file
(setq require-final-newline t) 

;; highlight current line
(global-hl-line-mode) 

;; set TAB length to 4, auto indent after line break
(setq-default tab-width 3 indent-tabs-mode nil)

;; use C-h for Backspace
(define-key global-map "\C-h" 'delete-backward-char)

;; use C-t to change windows
(define-key global-map (kbd "C-t") 'other-window)
;; highlight current brackets
(show-paren-mode t)

;; do not backup file before editting
(setq make-backup-files nil)

;; do not creat save list for auto-save files
(setq auto-save-list-file-prefix nil)

;; create auto-save file in ~/.emacs.d/backups
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))

;; autosave time
(setq auto-save-timeout 10)   ;; seconds (default 30)
(setq auto-save-interval 50) ;; inputs  (default 300)

;; configure "redo+.el"
(when (require 'redo+ nil t)
  ;; redo with "C-."
  (define-key global-map (kbd "C-.") 'redo))

;; configure "company"
(require 'company)
(global-company-mode) ; 全バッファで有効にする 
(setq company-idle-delay 0) ; デフォルトは0.5
(setq company-minimum-prefix-length 2) ; デフォルトは4
(setq company-selection-wrap-around t) ; 候補の最後の次は先頭に戻る
(setq completion-ignore-case t)
(setq company-dabbrev-downcase nil)
(global-set-key (kbd "C-M-i") 'company-complete)
;; C-n, C-pで補完候補を次/前の候補を選択
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map [tab] 'company-complete-selection) ;; TABで候補を設定
(define-key company-active-map (kbd "C-h") nil) ;; C-hはバックスペース割当のため無効化
(define-key company-active-map (kbd "C-S-h") 'company-show-doc-buffer) ;; ドキュメント表示はC-Shift-h

;; 未選択項目
(set-face-attribute 'company-tooltip nil
                    :foreground "#36c6b0" :background "#244f36")
;; 未選択項目&一致文字
(set-face-attribute 'company-tooltip-common nil
                    :foreground "white" :background "#244f36")
;; 選択項目
(set-face-attribute 'company-tooltip-selection nil
                    :foreground "#a1ffcd" :background "#007771")
;; 選択項目&一致文字
(set-face-attribute 'company-tooltip-common-selection nil
                    :foreground "white" :background "#007771")
;; スクロールバー
(set-face-attribute 'company-scrollbar-fg nil
                    :background "#4cd0c1")
;; スクロールバー背景
(set-face-attribute 'company-scrollbar-bg nil
                    :background "#002b37") 

;; configure "wgrep"
(require 'wgrep nil t)


;; 補完で大文字小文字無視
(setq read-file-name-completion-ignore-case t)

;; configure "undohist"
(when (require 'undohist nil t)
  (undohist-initialize))

;; configure "undo-tree"
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))

;; web mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\|\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(setq web-mode-markup-indent-offset 2)

;; configure "Yatex"
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(setq auto-mode-alist (append
                       '(("\\.tex$" . yatex-mode)
                         ("\\.ltx$" . yatex-mode)
                         ("\\.cls$" . yatex-mode)
                         ("\\.sty$" . yatex-mode)
                         ("\\.clo$" . yatex-mode)
                         ("\\.bbl$" . yatex-mode)) auto-mode-alist))
(setq YaTeX-inhibit-prefix-letter t)    ;; use bind key
(setq YaTeX-latex-message-code 'utf-8)  ;; default encode for document 
(setq YaTeX-use-LaTeX2e t)              ;; use LaTexX2e
(setq YaTeX-use-AMS-LaTeX t)            ;; use AMS-LaTeX
;; 1 = Shift_JIS, 2 = ISO-2022-JP, 3 = EUC-JP, 4 = UTF-8
(setq YaTeX-kanji-code nil)             ;; default kanji code
(setq tex-command "platex")             ;; compile command
(setq dvi2-command "google-chrome")            ;; preview command
(setq YaTeX-nervous nil)                ;; use users dictionary
;; only use C-c b to autocomplete
(setq YaTeX-no-begend-shortcut -1)
;; control auto start new line
(add-hook 'yatex-mode-hook
          '(lambda ()
             (setq auto-fill-mode -1)))
;; load template file when creating new TeX file
(setq YaTeX-template-file "~/.latex/report")
;; remove .dvi, .log after compiling
(setq YaTeX-dvipdf-command "~/.emacs.d/conf/mydvipdfmx.sh")

;; highlight current line number
(require 'linum-highlight-current-line-number)
(setq linum-format 'linum-highlight-current-line-number)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (org atom-one-dark-theme color-theme-sanityinc-solarized auto-correct auto-complete ## wgrep web-mode undo-tree popup multi-term company))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "unspecified-bg" :foreground "blue" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 1 :width normal :foundry "default" :family "default"))))
 '(font-lock-comment-face ((t (:foreground "white" :slant italic)))))
