
;;; set Color-Theme as zenburn
;(load-theme 'zenburn t)

;(setq tramp-default-method "ssh")
;(require 'tramp)


;;; yasnippets
(require 'yasnippet)
(defun my-yas/prompt (prompt choices &optional display-fn)
  (let* ((names (loop for choice in choices
                      collect (or (and display-fn (funcall display-fn choice))
                                  coice)))
         (selected (anything-other-buffer
                    `(((name . ,(format "%s" prompt))
                       (candidates . names)
                       (action . (("Insert snippet" . (lambda (arg) arg))))))
                    "*anything yas/prompt*")))
    (if selected
        (let ((n (position selected names :test 'equal)))
          (nth n choices))
      (signal 'quit "user quit!"))))
(custom-set-variables '(yas/prompt-functions '(my-yas/prompt)))

(yas/load-directory "~/.emacs.d/config/packages/yasnippet/snippets")


(require 'auto-complete)
(require 'auto-complete-config)    ; 必須ではないですが一応
(global-auto-complete-mode t)

;;; auto-complete
;(ac-config-default)
;(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict/")

;; ac-my-completion for auto-complete
;; (defun ac-my-completion-list-in-files (files &optional keywords-variable)
;;   "create completion list for auto-complete"
;;   (let ((ksymbol keywords-variable) keywords)
;;     (cond
;;      ((stringp files)
;;       (setq files (list files)))
;;      ((stringp keywords-variable)
;;       (setq ksymbol (intern keywords-variable))))
;;     (if (not (boundp ksymbol))
;;         (progn
;;           (dolist (file files)
;;             (let ((buffer (find-file-noselect file)) filename)
;;               (setq filename (file-name-nondirectory file))
;;               (with-current-buffer buffer
;;                 (rename-buffer
;;                  (concat " *" filename "*") t)
;;                 (if (< (buffer-size) 131072) ; 128Kb
;;                     (save-excursion
;;                       (goto-char (point-min))
;;                       (while (re-search-forward "^[^;]\\(\\s_\\|\\sw\\)+\\b$" nil t)
;;                         (let ((candidate (match-string-no-properties 0)))
;;                           (if (not (member candidate keywords))
;;                               (push candidate keywords))))
;;                       (setq keywords (nreverse keywords)))))))
;;           ;; (sort keywords #'(lambda (a b) (> (length a) (length b))))
;;           (if ksymbol
;;               (set-default ksymbol keywords))
;;           (message (concat "Building ac-source keywords(" (symbol-name ksymbol) ")...done."))
;;           keywords))))

;; (defun ac-my-completion-files (files mode-name &optional set-hook)
;;   "set completion list to mode-variable for auto-complete"
;;   (lexical-let
;;       ((--ac-source (intern (concat "ac-source-" mode-name)))
;;        (--ac-source-keywords (intern (concat "ac-source-" mode-name "-keywords")))
;;        (--mode-hook (intern (concat mode-name "-mode-hook")))
;;        (--files files))
;;     (set-default --ac-source
;;                  (list (cons 'candidates
;;                              (lambda ()
;;                                (all-completions ac-prefix (symbol-value --ac-source-keywords))))))
;;     (if set-hook
;;         (add-hook --mode-hook
;;                   (lambda()
;;                     (ac-my-completion-list-in-files --files --ac-source-keywords)
;;                     (make-local-variable 'ac-sources)
;;                     (setq ac-sources (append ac-sources (list --ac-source)))))
;;       (ac-my-completion-list-in-files --files --ac-source-keywords))))


;; 以下をモード毎に設定
;;(ac-my-completion-files "~/.emacs.d/etc/completions/javascript+DOM" "javascript" t)
;;(ac-my-completion-files "~/.emacs.d/etc/completions/javascript+DOM" "js2" t)

;;; js

;;; js-doc
;(require 'js-doc)

;;; js2-mode myhook
(defun my-js2-indent-function ()
  (interactive)
  (save-restriction
    (widen)
    (let* ((inhibit-point-motion-hooks t)
           (parse-status (save-excursion (syntax-ppss (point-at-bol))))
           (offset (- (current-column) (current-indentation)))
           (indentation (js--proper-indentation parse-status))
           node)

      (save-excursion

        ;; I like to indent case and labels to half of the tab width
        ;(back-to-indentation)
        ;(if (looking-at "case\\s-")
        ;    (setq indentation (+ indentation (/ js-indent-level 2))))
		;(if (looking-at "case\\s-")
        ;   (setq indentation (+ 4 indentation)))

        ;; consecutive declarations in a var statement are nice if
        ;; properly aligned, i.e:
        ;;
        ;; var foo = "bar",
        ;;     bar = "foo";
        (setq node (js2-node-at-point))
        (when (and node
                   (= js2-NAME (js2-node-type node))
                   (= js2-VAR (js2-node-type (js2-node-parent node))))
          (setq indentation (+ 4 indentation))))

      (indent-line-to indentation)
      (when (> offset 0) (forward-char offset)))))

(defun my-indent-sexp ()
  (interactive)
  (save-restriction
    (save-excursion
      (widen)
      (let* ((inhibit-point-motion-hooks t)
             (parse-status (syntax-ppss (point)))
             (beg (nth 1 parse-status))
             (end-marker (make-marker))
             (end (progn (goto-char beg) (forward-list) (point)))
             (ovl (make-overlay beg end)))
        (set-marker end-marker end)
        (overlay-put ovl 'face 'highlight)
        (goto-char beg)
        (while (< (point) (marker-position end-marker))
          ;; don't reindent blank lines so we don't set the "buffer
          ;; modified" property for nothing
          (beginning-of-line)
          (unless (looking-at "\\s-*$")
            (indent-according-to-mode))
          (forward-line))
        (run-with-timer 0.5 nil '(lambda(ovl)
                                   (delete-overlay ovl)) ovl)))))

(defun my-js2-mode-hook ()
  (require 'js)
  (setq js-indent-level 4
        indent-tabs-mode t
        c-basic-offset 4)
;  (setq js-indent-level 2
;        indent-tabs-mode nil
;        c-basic-offset 2)
  (c-toggle-auto-state 0)
  (c-toggle-hungry-state 1)
  (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
  ; (define-key js2-mode-map [(meta control |)] 'cperl-lineup)
  (define-key js2-mode-map "\C-\M-\\"
    '(lambda()
       (interactive)
       (insert "/* -----[ ")
       (save-excursion
         (insert " ]----- */"))
       ))
  ; (define-key js2-mode-map [(backspace)] 'c-electric-backspace)
  ; (define-key js2-mode-map [(control d)] 'c-electric-delete-forward)
  (define-key js2-mode-map "\C-\M-q" 'my-indent-sexp)
  (if (featurep 'js2-highlight-vars)
      (js2-highlight-vars-mode))
  (message "My JS2 hook"))

(add-hook 'js2-mode-hook 'my-js2-mode-hook)

;;; js2-mode hook
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js" . js2-mode))


;;; markdown-mode.el
(setq auto-mode-alist   (cons '("\\.md" . markdown-mode) auto-mode-alist))

;;; jade-mode
(add-to-list 'auto-mode-alist '("\\.jade$" . jade-mode))
(add-to-list 'auto-mode-alist '("\\.styl$" . stylus-mode))

;;; css-mode
(setq auto-mode-alist
(cons '("\\.css\\'" . css-mode) auto-mode-alist))
(setq cssm-indent-function #'cssm-c-style-indenter)

;;; handlebars
(require 'handlebars-mode)
(add-to-list 'auto-mode-alist '("\\.hbs$" . handlebars-mode))


;;;Add the following custom-set-variables to use 'lazy' modes
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(js3-lazy-commas t)
 '(js3-lazy-operators t)
 '(js3-lazy-dots t)
 '(js3-expr-indent-offset 2)
 '(js3-paren-indent-offset 2)
 '(js3-square-indent-offset 2)
 '(js3-curly-indent-offset 2)
)

(defun my-js3-mode-hook ()
  (require 'js)
  (setq js-indent-level 4
        indent-tabs-mode t
        c-basic-offset 4)
  ; (define-key js3-mode-map [(backspace)] 'c-electric-backspace)
  ; (define-key js3-mode-map [(control d)] 'c-electric-delete-forward)
  (message "My JS3 hook"))
(add-hook 'js3-mode-hook 'my-js3-mode-hook)


;;
;; YaTeX
;;
(add-to-list 'load-path "~/.emacs.d/lib/yatex")
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
;(autoload 'yatex-mode "yatex" nil  t)
(setq auto-mode-alist
      (append '(("\\.tex$" . yatex-mode)
                ("\\.ltx$" . yatex-mode)
                ("\\.cls$" . yatex-mode)
                ("\\.sty$" . yatex-mode)
                ("\\.clo$" . yatex-mode)
                ("\\.bbl$" . yatex-mode)) auto-mode-alist))
(setq YaTeX-inhibit-prefix-letter nil)
(setq YaTeX-kanji-code nil)
(setq YaTeX-use-LaTeX2e t)
(setq YaTeX-use-AMS-LaTeX t)
(setq YaTeX-dvipdf-command "/usr/texbin/dvipdfmx")
(setq YaTeX-dvi2-command-ext-alist
      '(("[agx]dvi\\|PictPrinter\\|Mxdvi" . ".dvi")
        ("gv" . ".ps")
        ("Preview\\|TeXShop\\|TeXworks\\|Skim\\|mupdf\\|xpdf\\|Adobe" . ".pdf")))
;(setq tex-command "/usr/texbin/platex -synctex=1 -src-specials")
;(setq tex-command "/usr/texbin/platex")
(setq tex-command "~/Library/TeXShop/bin/platex2pdf-utf8")
;(setq tex-command "/usr/local/bin/platex")
;(setq tex-command "/usr/local/bin/pdfplatex2")
;(setq tex-command "/usr/texbin/uplatex -synctex=1 -src-specials")
;(setq tex-command "/usr/local/bin/pdfuplatex")
;(setq tex-command "/usr/local/bin/pdfuplatex2")
;(setq tex-command "/usr/texbin/pdflatex -synctex=1")
;(setq tex-command "/usr/texbin/lualatex -synctex=1")
;(setq tex-command "/usr/texbin/xelatex -synctex=1")
(setq bibtex-command (cond ((string-match "uplatex" tex-command) "/usr/texbin/upbibtex")
                           ((string-match "platex" tex-command) "/usr/texbin/pbibtex")
                           ((string-match "lualatex\\|xelatex" tex-command) "/usr/texbin/biber")
                           ((string-match "tex" tex-command) "/usr/texbin/bibtex")))
(setq makeindex-command (cond ((string-match "uplatex" tex-command) "/usr/texbin/mendex")
                              ((string-match "platex" tex-command) "/usr/texbin/mendex")
                              ((string-match "lualatex\\|xelatex" tex-command) "/usr/texbin/texindy")
                              ((string-match "tex" tex-command) "/usr/texbin/makeindex")))
(setq dvi2-command (cond ((string-match "platex\\|pdfplatex\\|pdfuplatex\\|pdflatex\\|lualatex\\|xelatex" tex-command) "/usr/bin/open -a Preview")
                         ((string-match "tex" tex-command) "/usr/bin/open -a PictPrinter")))
(setq dviprint-command-format (cond ((string-match "pdfplatex\\|pdfuplatex\\|pdflatex\\|lualatex\\|xelatex" tex-command) "/usr/bin/open -a \"Adobe Reader\" %s")
                                    ((string-match "tex" tex-command) "/usr/bin/open -a \"Adobe Reader\" `echo %s | sed -e \"s/\\.[^.]*$/\\.pdf/\"`")))
(defun skim-forward-search ()
  (interactive)
  (let* ((ctf (buffer-name))
         (mtf)
         (pf)
         (ln (format "%d" (line-number-at-pos)))
         (cmd "/Applications/Skim.app/Contents/SharedSupport/displayline")
         (args))
    (if (YaTeX-main-file-p)
        (setq mtf (buffer-name))
      (progn
        (if (equal YaTeX-parent-file nil)
            (save-excursion
              (YaTeX-visit-main t)))
        (setq mtf YaTeX-parent-file)))
    (setq pf (concat (car (split-string mtf "\\.")) ".pdf"))
    (setq args (concat ln " " pf " " ctf))
    (process-kill-without-query
      (start-process-shell-command "displayline" nil cmd args))))
;; (add-hook 'yatex-mode-hook
;;           '(lambda ()
;;              (define-key YaTeX-mode-map (kbd "C-c s") 'skim-forward-search)))
(defun pxdvi-forward-search ()
  (interactive)
  (let* ((ctf (buffer-name))
         (mtf)
         (df)
         (ln (format "%d" (line-number-at-pos)))
         (cmd "/usr/texbin/pxdvi")
         (args))
    (if (YaTeX-main-file-p)
        (setq mtf (buffer-name))
      (progn
        (if (equal YaTeX-parent-file nil)
            (save-excursion
              (YaTeX-visit-main t)))
        (setq mtf YaTeX-parent-file)))
    (setq df (concat (car (split-string mtf "\\.")) ".dvi"))
    (setq args (concat " -nofork " df " -sourceposition " ln ":" ctf))
    (process-kill-without-query
      (start-process-shell-command "pxdvi" nil cmd args))))
;;(add-hook 'yatex-mode-hook
;;          '(lambda ()
;;             (define-key YaTeX-mode-map (kbd "C-c d") 'pxdvi-forward-search)))
(add-hook 'yatex-mode-hook
          '(lambda ()
             (auto-fill-mode -1)))
;;
;; RefTeX (YaTeX)
;;
;(add-hook 'yatex-mode-hook 'turn-on-reftex)
(add-hook 'yatex-mode-hook
          '(lambda ()
             (reftex-mode 1)
             (define-key reftex-mode-map
               (concat YaTeX-prefix ">") 'YaTeX-comment-region)
             (define-key reftex-mode-map
               (concat YaTeX-prefix "<") 'YaTeX-uncomment-region)))

;; Magit
(global-set-key "\C-xg" 'magit-status)
