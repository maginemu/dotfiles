
;;
;; YaTeX
;;
(add-to-list 'load-path "~/.emacs.d/lib/yatex")
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(setq auto-mode-alist
      (append '(("\\.tex$" . yatex-mode)
                ("\\.ltx$" . yatex-mode)
                ("\\.cls$" . yatex-mode)
                ("\\.sty$" . yatex-mode)
                ("\\.clo$" . yatex-mode)
                ("\\.bbl$" . yatex-mode)) auto-mode-alist))
(setq YaTeX-inhibit-prefix-letter t)
(setq YaTeX-kanji-code nil)
(setq YaTeX-use-LaTeX2e t)
(setq YaTeX-use-AMS-LaTeX t)
(setq YaTeX-dvipdf-command "/usr/texbin/dvipdfmx")
(setq YaTeX-dvi2-command-ext-alist
      '(("[agx]dvi\\|PictPrinter\\|Mxdvi" . ".dvi")
        ("gv" . ".ps")
        ("Preview\\|TeXShop\\|TeXworks\\|Skim\\|mupdf\\|xpdf\\|Adobe" . ".pdf")))
;(setq tex-command "/usr/texbin/platex -synctex=1 -src-specials")
(setq tex-command "/usr/local/bin/platex")
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
(setq dvi2-command (cond ((string-match "pdfplatex\\|pdfuplatex\\|pdflatex\\|lualatex\\|xelatex" tex-command) "/usr/bin/open -a Preview")
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
(add-hook 'yatex-mode-hook
          '(lambda ()
             (define-key YaTeX-mode-map (kbd "C-c s") 'skim-forward-search)))
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
(add-hook 'yatex-mode-hook
          '(lambda ()
             (define-key YaTeX-mode-map (kbd "C-c d") 'pxdvi-forward-search)))
(add-hook 'yatex-mode-hook
          '(lambda ()
             (auto-fill-mode -1)))
;;
;; RefTeX (YaTeX)
;;
;(add-hook 'yatex-mode-hook 'turn-on-reftex)
;(add-hook 'yatex-mode-hook
;          '(lambda ()
;             (reftex-mode 1)
;             (define-key reftex-mode-map
;                         (concat YaTeX-prefix ">") 'YaTeX-comment-region)
;             (define-key reftex-mode-map
;                         (concat YaTeX-prefix "<") 'YaTeX-uncomment-region)))
