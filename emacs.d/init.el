;;; Add load path
;(setq load-path
;    (append '("~/.emacs.d/lib") load-path))
(add-to-list 'load-path "~/.emacs.d")

;;; global map
(define-key global-map "\C-z" 'undo) ; undo

;;; backspace -> \C-h
(global-set-key "\C-h" 'backward-delete-char)

;;; number line
(global-set-key "\M-n" 'linum-mode)
;;(global-linum-mode t)

;; 起動時のメッセージを非表示
(setq inhibit-startup-message t)

;; 改行コードを表示
(setq eol-mnemonic-dos "(CRLF)")
(setq eol-mnemonic-mac "(CR)")
(setq eol-mnemonic-unix "(LF)")

;; command <-> option
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

;; command key as meta
(setq mac-command-key-is-meta t)


;; C-x bでミニバッファにバッファ候補を表示
(define-key global-map (kbd "C-x b") 'anything-for-files)



;; Command-Key and Option-Key
;(setq ns-command-modifier (quote meta))
;(setq ns-alternate-modifier (quote super))

;; beepを消す
(defun my-bell-function ()
  (unless (memq this-command
                '(isearch-abort abort-recursive-edit exit-minibuffer
                                keyboard-quit mwheel-scroll down up next-line previous-line
                                backward-char forward-char))
    (ding)))
(setq ring-bell-function 'my-bell-function)
;(setq ring-bell-function 'ignore)
;(setq visible-bell t)

;;; 対応する括弧を光らせる。
(show-paren-mode 1)
;;; バックアップファイルを作らない
(setq backup-inhibited t)
;;; 終了時にオートセーブファイルを消す
(setq delete-auto-save-files t)
;;; 補完時に大文字小文字を区別しない
(setq completion-ignore-case t)

;;; カーソルの点滅を止める
(blink-cursor-mode 0)

;;; カーソルの位置が何文字目かを表示する
(column-number-mode t)

;;; カーソルの位置が何行目かを表示する
(line-number-mode t)
;;; 行の先頭でC-kを一回押すだけで行全体を消去する
(setq kill-whole-line t)

;;; 圧縮されたファイルも編集できるようにする
(auto-compression-mode t)
;;; タイトルバーにファイル名を表示する
(setq frame-title-format (format "emacs@%s : %%f" (system-name)))
;;; dabbrev
;;;(global-set-key "\C-o" 'dabbrev-expand)`
(global-set-key "\C-o" 'dabbrev-expand)

;;; 範囲選択色付け
(setq transient-mark-mode t)

;;; バックスペースを h に割り当て
(global-set-key "\C-h" 'delete-backward-char)
;; character
;;(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;;; カーソル行のborder-bottom
(defface hlline-face
  '((((class color)
      (background dark))
     (:background "dark slate gray"))
    (((class color)
      (background light))
     (:background "ForestGreen"))
    (t
     ()))
  "*Face used by hl-line.")
;;(setq hl-line-face 'hlline-face)
(setq hl-line-face 'underline)
(global-hl-line-mode)

;;; 変なスペースに色をつける
;;(defface my-face-r-1 '((t (:background "gray15"))) nil)
(defface my-face-b-1 '((t (:foreground "Red" :underline t))) nil)
(defface my-face-b-2 '((t (:background "Yellow"))) nil)
(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
;;(defvar my-face-r-1 'my-face-r-1)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)

;; (defadvice font-lock-mode (before my-font-lock-mode ())
;;   (font-lock-add-keywords
;;    major-mode
;;    '(("\t" 0 my-face-b-2 append)
;;      ("　" 0 my-face-b-1 append)
;;      ("[ \t]+$" 0 my-face-u-1 append)
;;      ;;("[\r]*\n" 0 my-face-r-1 append)
;;      )))
;; (ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
;; (ad-activate 'font-lock-mode)

;; tab
(setq-default indent-tabs-mode t)
(setq-default tab-width 4 indent-tabs-mode t)
;;(setq-default tab-width 2 indent-tabs-mode nil)

;; 行末の空白を保存前に削除。
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; ------------------------------------------------------------------------
;; @ uniquify.el

;; 同名バッファを分りやすくする
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")



;;; package installer setting
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)


(load "config/packages")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("4c9ba94db23a0a3dea88ee80f41d9478c151b07cb6640b33bfc38be7c2415cc4" "34543312860bbc58b2fcf4d24a9bdc5c114347f16903ac9d7ae70f3c44616a9e" "3d6b08cd1b1def3cc0bc6a3909f67475e5612dba9fa98f8b842433d827af5d30" default)))
 '(js3-curly-indent-offset 2)
 '(js3-expr-indent-offset 2)
 '(js3-lazy-commas t)
 '(js3-lazy-dots t)
 '(js3-lazy-operators t)
 '(js3-paren-indent-offset 2)
 '(js3-square-indent-offset 2)
 '(yas/prompt-functions (quote (my-yas/prompt))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; markdown preview by using Marked
(defun markdown-preview-file ()
  "run Marked on the current file and revert the buffer"
  (interactive)
  (shell-command
   (format "open -a /Applications/Marked.app %s"
       (shell-quote-argument (buffer-file-name))))
)
(global-set-key "\C-cm" 'markdown-preview-file)
