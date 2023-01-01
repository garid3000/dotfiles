;;; Startup
(set-face-attribute 'default nil :font "Iosevka SS06" :height 120)
(setq default-frame-alist '((font . "Iosevka SS06")))
; (setq load-prefer-newer t)

;; Package repos GNU
(setq package-archives
    '(("melpa" . "https://melpa.org/packages/")
     ("elpa" . "https://elpa.gnu.org/packages/")))
;; Package non GNU repo
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/"))


;; BOOTSTRAP USE-PACKAGE <= not sure what it does
(package-initialize)
(setq use-package-always-ensure t) (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))
(eval-when-compile (require 'use-package))

;; Vim style undo not needed for emacs 28
(use-package undo-fu)


;; Vim Bindings
(use-package evil
    :demand t
    :bind (
		   ("<escape>" . keyboard-escape-quit)
		   ("M-j" . evil-scroll-line-down)
		   ("M-k" . evil-scroll-line-up) 
		   ("M-d" . evil-scroll-page-down)
		   ("M-u" . evil-scroll-page-up) 
		   )
    :init
    ;; allows for using cgn
    ;; (setq evil-search-module 'evil-search)
    (setq evil-want-keybinding nil)
    (setq evil-want-C-i-jump nil)
    ;; no vim insert bindings
    (setq evil-undo-system 'undo-fu)
    :config
    (evil-mode 1))


;(global-set-key (kbd "M-j") 'evil-scroll-line-down)
;(global-set-key (kbd "M-k") 'evil-scroll-line-up)
;(global-set-key (kbd "M-d") 'evil-scroll-page-down)
;(global-set-key (kbd "M-u") 'evil-scroll-page-up)





;;; Vim Bindings Everywhere else
(use-package evil-collection
    :after evil
    :config
    (setq evil-want-integration t)
    (evil-collection-init))

; (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
; (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)


(use-package ripgrep)
(setq browse-url-browser-function 'browse-url-chromium)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode   -1)        ; Disable the toolbar
(tooltip-mode    -1)        ; Disable tooltips
(set-fringe-mode 15)        ; Give some breathing room
(menu-bar-mode   -1)        ; Disable the menu bar


;; setting line
(use-package display-line-numbers)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)


;; cursor light
;; (use-package beacon)
;; (setq beacon 0.1)
;; (beacon-mode 1)
(global-hl-line-mode 1)


(use-package vertico
  :ensure t
  :bind (:map vertico-map
         ("C-j" . vertico-next)
         ("C-k" . vertico-previous)
         ("C-f" . vertico-exit)
         ("C-g" . vertico-grid-mode) 
         ("C-h" . vertico-grid-left) 
         ("C-l" . vertico-grid-right) 
         ("C-u" . vertico-scroll-up) 
         ("C-d" . vertico-scroll-down) 
         ("C-S-g" . vertico-last) 
         ;:map minibuffer-local-map
	 ;("C-H" . backward-kill-word)
	 ) 
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))


(use-package savehist
  :init
  (savehist-mode))

(use-package marginalia
  :after vertico
  :ensure t
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(use-package consult
  :bind (
		 ("M-f"  . consult-line)
		 )

  )
;(global-set-key (kbd "M-f") 'consult-line)

; this makes consult-line works like swiper
; this also (could've) made field seperate - to spc in M-x
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))


;; org babel languages
;; this added for compiling openscad using
;; following link https://emacs.stackexchange.com/questions/61439/how-to-write-a-basic-org-babel-execute-function-for-a-new-language
; (use-package hide-lines) <- not sure
; (autoload 'hide-lines "hide-lines" "Hide lines based on a regexp" t)
; (global-set-key "\C-ch" 'hide-lines)

;; copied from
;; https://github.com/daviwil/emacs-from-scratch/blob/master/show-notes/Emacs-05.org
(defun dw/org-mode-setup ()
  (org-indent-mode) ;;;;;this for lag
  ;(variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil)

  ;#+header_inclu
  (setq org-latex-active-timestamp-format "\\textcolor{orange}{\\texttt{%s}}")
  (setq org-latex-inactive-timestamp-format "\\textcolor{blue}{\\texttt{%s}}")


  (setq org-latex-active-timestamp-format "\\textcolor{orange}{%s}")
  (setq org-latex-inactive-timestamp-format "\\textcolor{blue}{%s}")
  )

(defun my-org-latex-format-headline-function
    (todo todo-type priority text tags _info)
  "Default format function for a headline.
See `org-latex-format-headline-function' for details."
  (concat
   (and todo (format "{\\framebox{\\bfseries\\rfamily\\color{%s} %s}} "
                     (pcase todo-type
                       ('todo "olive")
                       ('done "teal"))
                     todo))
   (and priority (format "\\framebox{\\#%c} " priority))
   text
   (and tags
    (format "\\hfill{}\\textsc{%s}"
        (mapconcat #'org-latex--protect-text tags ":")))))




(use-package org
	:bind (:map org-mode-map
				("C-S-j" . org-next-visible-heading)
				("C-S-k" . org-previous-visible-heading)
			)
    :hook (org-mode . dw/org-mode-setup)
    :config
    (setq org-ellipsis "▼ "
          org-hide-emphasis-markers t)



    ;(define-key org-agenda-mode-map (kbd "j") 'org-agenda-next-line)
    ;(define-key org-agenda-mode-map (kbd "k") 'org-agenda-previous-line)

    (setq org-log-done t)
    (setq org-image-actual-width '(800)) ; sets images size

    (setq org-file-apps
	'((auto-mode . emacs)
	    ;("\\.x?html?\\'" . "firefox %s")
	    ;("\\.pdf\\(::[0-9]+\\)?\\'" . whatacold/org-pdf-app)
	    ("\\.gif\\'"  . "mpv \"%s\"")
	    ("\\.mp4\\'"  . "mpv \"%s\"")
	    ("\\.png\\'"  . "sxiv \"%s\"")
	    ("\\.jpeg\\'" . "sxiv \"%s\"")
	    ("\\.jpg\\'"  . "sxiv \"%s\"")
	    ;("\\.pdf\\'"  . "zathura \"%s\"")
	    ("\\.pdf\\'"  . "sioyek \"%s\"")
	    ("\\.mkv\\'"  . "mpv \"%s\"")))



    ;; latex listing (for source code coloring)
    (setq org-latex-listings t)
    (add-to-list 'org-latex-packages-alist '("" "listings"))
    (add-to-list 'org-latex-packages-alist '("" "color"))


    ;;latex export (for sourc ecode coloring)
    (setq org-latex-listings 'minted
	org-latex-packages-alist '(("" "minted"))
	org-latex-pdf-process
	'("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
	    "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))


    (setq org-src-tab-acts-natively t)

    (setq org-latex-format-headline-function 'my-org-latex-format-headline-function)
  )



;; org mode src <-s-tab
(with-eval-after-load 'org
  ;; This is needed as of Org 9.2
    (require 'org-tempo)
    (add-to-list 'org-structure-template-alist '("el"   . "src emacs-lisp"))
    (add-to-list 'org-structure-template-alist '("she"  . "src shell"))
    (add-to-list 'org-structure-template-alist '("te"   . "src text" ))
    (add-to-list 'org-structure-template-alist '("tm"   . "src tmux" ))
    (add-to-list 'org-structure-template-alist '("dot"  . "src dot" ))
    (add-to-list 'org-structure-template-alist '("dotf" . "src dot :file /home/garid/orgfiles/... :exports results :tangle no :eval never-export" ))
    (add-to-list 'org-structure-template-alist '("tmf"  . "src tmux :session hello :eval never-export" ))
    ; (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
    (add-to-list 'org-structure-template-alist '("py" . "src python"))
    (add-to-list 'org-structure-template-alist '("pys" . "src python :session mysess :results output"))
    (add-to-list 'org-structure-template-alist '("sq" . "sqlite"))
    (add-to-list 'org-structure-template-alist '("js" . "src js"))

    ; (add-to-list 'org-structure-template-alist '("py0" . "src python :tangle /home/garid/gimbal/0_raw_compiler.py   :noweb tangle"))
    ; (add-to-list 'org-structure-template-alist '("py1" . "src python :tangle no :noweb tangle"))
    ; (add-to-list 'org-structure-template-alist '("py2" . "src python :tangle /home/garid/gimbal/2_pyqt3d_rgb.py     :noweb tangle"))
    ; (add-to-list 'org-structure-template-alist '("py3" . "src python :tangle /home/garid/gimbal/4_kdtree_indicer.py :noweb tangle"))
    ; (add-to-list 'org-structure-template-alist '("py4" . "src python :tangle /home/garid/gimbal/6_plane_graph.py    :noweb tangle"))

    (add-to-list 'org-structure-template-alist '("mk" . "src makefile :tangle yes"))
    (add-to-list 'org-structure-template-alist '("cl" . "src C"))

    ;(setq org-agenda-files  '("~/orgfiles/Task.org" "~/roamnotes/20220912112852-todo.org" ))
    (setq org-agenda-files  '("~/orgfiles/Task.org" "~/roamnotes/daily/" ))
    (setq org-agenda-start-with-log-mode t)
    (setq org-default-notes-file  "~/roamnotes/20220920023604-captures.org")

  )


(org-babel-do-load-languages
    'org-babel-load-languages
	'((python    . t)  (emacs-lisp . t)
	 (lisp       . t)  (latex      . t)
	 (shell      . t)  (C          . t)
	 (dot        . t)  (makefile   . t)
	 (sqlite     . t)  (js         . t)
	 ;(jupyter   . t) 
	 ;(rust      . t) ;(scad       . t)
	 ;(scheme    . t) ;(C          . t)
	) )



(use-package org-tree-slide)
(with-eval-after-load "org-tree-slide"
    (defvar my-hide-org-meta-line-p nil)
    (defun my-hide-org-meta-line ()
	(interactive)
	(setq my-hide-org-meta-line-p t)
	(set-face-attribute 'org-meta-line nil
					    :foreground (face-attribute 'default :background)))
    (defun my-show-org-meta-line ()
	(interactive)
	(setq my-hide-org-meta-line-p nil)
	(set-face-attribute 'org-meta-line nil :foreground nil))

    (defun my-toggle-org-meta-line ()
	(interactive)
	(if my-hide-org-meta-line-p
		(my-show-org-meta-line) (my-hide-org-meta-line)))
    (add-hook 'org-tree-slide-play-hook #'my-hide-org-meta-line)
    (add-hook 'org-tree-slide-stop-hook #'my-show-org-meta-line))




(use-package org-bullets
    :after org
    :hook (org-mode . org-bullets-mode)
    :custom
    (org-bullets-bullet-list '("◉ " "○ " "● " "○ " "● " "○ " "● ")))

;; Replace list hyphen with dot
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                          (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
(require 'org-indent)

(use-package org-roam
    :ensure t
    :init
    (setq org-roam-v2-ack t)
    :custom
    (org-roam-directory "~/roamnotes")
    (org-roam-completion-everywhere t)
    (org-roam-dailies-capture-templates
	'(("d" "default" entry "* %<%I:%M %p>: %?"
	    :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n#+auto_tangle: nil\n#+STARTUP: show2levels\n"))))
    (org-roam-capture-templates
    '(("d" "default" plain
	"%?"
	:if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+author: Garid Z.\n#+date: %U\n#+auto_tangle: nil\n")
	:unnarrowed t)
	("l" "programming language" plain
	"* Characteristics\n\n- Family: %?\n- Inspired by: \n\n* Reference:\n\n"
	:if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
	:unnarrowed t)
	("b" "book notes" plain
	"\n* Source\n\nAuthor: %^{Author}\nTitle: ${title}\nYear: %^{Year}\nDOI: %^{DOI}\n\n* Summary\n\n%?"
	:if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
	:unnarrowed t)
	("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
	:if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Project\n#+auto_tangle: nil")

	:unnarrowed t)
	))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         :map org-mode-map
         ("C-M-i" . completion-at-point))
  :bind-keymap
	 ("C-c n d" . org-roam-dailies-map)

  :config
  (org-roam-setup)
    (require 'org-roam-dailies) ;; Ensure the keymap is available
  (org-roam-db-autosync-mode))



;(use-package ob-rust)
;(use-package ox-hugo
;  :ensure t
;  :pin melpa
;  :after ox)


;;;;;ox-hugo
;;;(use-package pdf-tools
;;;    :ensure t   ;Auto-install the package from Melpa
;;;    :config
;;;	(pdf-tools-install))
;;;;
;;;  ;; fix https://github.com/weirdNox/org-noter/pull/93/commits/f8349ae7575e599f375de1be6be2d0d5de4e6cbf
;;;  (defun org-noter-set-start-location (&optional arg)
;;;    "When opening a session with this document, go to the current location. With a prefix ARG, remove start location."
;;;    (interactive "P")
;;;    (org-noter--with-valid-session
;;;     (let ((inhibit-read-only t)
;;;           (ast (org-noter--parse-root))
;;;           (location (org-noter--doc-approx-location (when (called-interactively-p 'any) 'interactive))))
;;;       (with-current-buffer (org-noter--session-notes-buffer session)
;;;         (org-with-wide-buffer
;;;          (goto-char (org-element-property :begin ast))
;;;          (if arg
;;;              (org-entry-delete nil org-noter-property-note-location)
;;;            (org-entry-put nil org-noter-property-note-location
;;;                           (org-noter--pretty-print-location location))))))))
;;;  (with-eval-after-load 'pdf-annot
;;;    (add-hook 'pdf-annot-activate-handler-functions #'org-noter-pdftools-jump-to-note)))







;; tmux
(use-package ob-tmux
  ;; Install package automatically (optional)
  :ensure t
  :custom
  (org-babel-default-header-args:tmux
   '((:results . "silent")	;
     (:session . "default")	; The default tmux session to send code to
     (:socket  . nil)))		; The default tmux socket to communicate with
  ;; The tmux sessions are prefixed with the following string.
  ;; You can customize this if you like.
  (org-babel-tmux-session-prefix "ob-")
  ;; The terminal that will be used.
  ;; You can also customize the options passed to the terminal.
  ;; The default terminal is "gnome-terminal" with options "--".
  (org-babel-tmux-terminal "st")
  (org-babel-tmux-terminal-opts '("-T" "ob-tmux" "-e"))
  ;; Finally, if your tmux is not in your $PATH for whatever reason, you
  ;; may set the path to the tmux binary as follows:
  (org-babel-tmux-location "/usr/bin/tmux"))


(defun +private/treemacs-back-and-forth ()
  (interactive)
  (if (treemacs-is-treemacs-window-selected?)
      (aw-flip-window)
    (treemacs-select-window)))
;(setq treemacs-text-scale -3)
;(setq treemacs-text-scale 0)
(treemacs-resize-icons 18)




;;; general
(use-package general
    :config
    (general-evil-setup t)

    (general-create-definer rune/leader-keys
	:keymaps '(normal insert visual emacs)
	:prefix "SPC"
	:global-prefix "C-SPC")) ; appperently works on places not working

(rune/leader-keys
    "SPC" '(execute-extended-command          :which-key "M-x")
    "d"   '(dired-jump                        :which-key "afs")
    ;; "d"   '(dired                             :which-key "afs")
    "f"   '(find-file                         :which-key "afs")
    "Fw"  '(find-file-other-window            :which-key "afs")
    "Ff"  '(find-file-other-frame             :which-key "afs")

    "N"   '(treemacs                         :which-key "afs")
    "n"   '(+private/treemacs-back-and-forth :which-key "afs")

    "qq"  '(kill-emacs                       :which-key "afs")
    "B"  '(switch-to-buffer                  :which-key "afs")
    "bl"  '(consult-buffer                   :which-key "afs")
    "l"   '(consult-buffer                   :which-key "afs")
    "L"   '(consult-buffer-other-frame       :which-key "afs")
    "bw"  '(consult-buffer-other-window      :which-key "afs")
    "bf"  '(consult-buffer-other-frame       :which-key "afs")
    "bL"  '(consult-buffer-other-frame       :which-key "afs")
    "ib"  '(ibuffer                          :which-key "afs")
    "bi"  '(ibuffer                          :which-key "afs")
    "br"  '(revert-buffer-quick              :which-key "afs")
	;;"cc"  '(consult-flymake                  :which-key "adf")
	"cc"  '(lsp-bridge-diagnostic-jump-next  :which-key "adf")
	"co"  '(consult-org-heading              :which-key "adf")

    "bn"  '(rename-buffer                    :which-key "afs")
    "bm"  '(consult-bookmark                 :which-key "afs")
    "bs"  '(bookmark-set                     :which-key "afs")
    "bd"  '(bookmark-delete                  :which-key "afs")
    "bD"  '(bookmark-delete-all              :which-key "afs")

    "mg"   '((lambda () (interactive) (magit-status)) :which-key "afs")

    "T"   '((lambda () (interactive) (gry/open-term-at)) :which-key "afs")
    ;"bk"  '(kill-buffer                             :which-key "afs")
    ;"bK"  '(kill-buffer-delete-auto-save-files      :which-key "afs")
    ;"br"  '(revert-buffer                           :which-key "afs")
    ;"bR"  '(revert-buffer-quick                     :which-key "afs")
    "ww"   '((lambda () (interactive) (eww-open-in-new-buffer)) :which-key "afs")
    "ws"   '((lambda () (interactive) (eww-search-words)) :which-key "afs")
    "wi"   '((lambda () (interactive) (evil-insert)) :which-key "afs")

    "p"   '(switch-to-prev-buffer            :which-key "afs")
    "P"   '(switch-to-next-buffer            :which-key "afs")
    "e"   '(eshell                           :which-key "afs")
    "scl"  '((lambda () (interactive) (command-log-mode )(global-command-log-mode)
	    (clm/open-command-log-buffer) (edwina-arrange)) :which-key "afs")
    "vt"  '(vterm :which-key "afs")

    "oo"  '((lambda () (interactive) (find-file "~/orgfiles/Task.org")) :which-key "afs")
    "oP"  '((lambda () (interactive) (gry/org-open-pdf)) :which-key "afs")
    "oe"  '((lambda () (interactive) (find-file "~/.config/emacs/init.el")) :which-key "afs")
    "oE"  '((lambda () (interactive) (find-file-other-frame "~/.config/emacs/init.el")) :which-key "afs")

    "om"  '((lambda () (interactive) (org-refile)) :which-key "afs")
    ","   '((lambda () (interactive) (org-ctrl-c-ctrl-c)) :which-key "afs")
    "<"   '((lambda () (interactive) (recompile)) :which-key "afs")

    "ott"  '(org-todo        :which-key "toggles")
    "ots"  '(org-schedule    :which-key "toggles")
    "ota"  '(org-agenda      :which-key "toggles")
    "otd"  '((lambda () (interactive) (org-deadline "")) :which-key "afs")

    "ost"  '((lambda () (interactive)
		(org-set-tags-command) ; sets images size
		) :which-key "afs")

    "olp" '(org-latex-preview            :which-key "toggles")
    "old" '(org-toggle-link-display      :which-key "toggles")
    "oii" '((lambda () (interactive)
		(org-insert-link "")
		) :which-key "afs")
    "op"  '(org-download-clipboard       :which-key "toggles")
    "oit"  '(org-toggle-inline-images    :which-key "toggles")
    "oic"  '((lambda () (interactive)
		(evil-open-above "")
		(insert "#+ATTR_LATEX: :placement [H]\n#+caption:     \n#+name:     ")
		;(evil-force-normal-state "") (evil-previous-line "")
		) :which-key "afs")

    "oisn"  '((lambda () (interactive)
		(setq org-image-actual-width '(800)) ; sets images size
		) :which-key "afs")

    "oisb"  '((lambda () (interactive)
		(setq org-image-actual-width '(1500)) ; sets images size
		) :which-key "afs")

    "oiss"  '((lambda () (interactive)
		(setq org-image-actual-width '(400)) ; sets images size
		) :which-key "afs")

    "oc"  '((lambda () (interactive)
		(org-capture) ; sets images size
		) :which-key "afs")

    ;;orgroams
    "orl"  '(org-roam-buffer-toggle      :which-key "toggles")
    "orf"  '(org-roam-node-find          :which-key "toggles")
    "ori"  '(org-roam-node-insert        :which-key "toggles")
    "oro"  '((lambda () (interactive)
		(org-open-at-point) ; sets images size
		;(edwina-swap-previous-window)
		) :which-key "afs")


    "ora"  '((lambda () (interactive)
		(org-id-get-create)
		(lambda () (interactive)
		(org-roam-alias-add))
		) :which-key "afs")


    ;;org-roam-dailies
    "odn" '(org-roam-dailies-capture-today      :which-key "")
    "odt" '(org-roam-dailies-goto-today         :which-key "")
    "odT" '(org-roam-dailies-goto-tomorrow      :which-key "")
    "ody" '(org-roam-dailies-goto-yesterday     :which-key "")
    "odd" '(org-roam-dailies-capture-date       :which-key "")
    "odD" '(org-roam-dailies-goto-date          :which-key "")
    "od>" '(org-roam-dailies-goto-next-note     :which-key "")
    "od<" '(org-roam-dailies-goto-previous-note :which-key "")

    ;; org code movement
    "j"   '(org-next-block     :which-key "")
    "k"   '(org-previous-block :which-key "")
    "J"   '(org-next-link      :which-key "")
    "K"   '(org-previous-link  :which-key "")


    "RET" '((lambda () (interactive)
		(evil-open-below "")
		(org-insert-todo-heading "")
		(org-insert "")) :which-key "ads")
    "ss"  '((lambda () (interactive)
		(shell-command "flameshot gui")
		) :which-key "afs")

    "h"   '(describe-symbol :which-key "Describe-Sym")
    "H"   '(describe-key    :which-key "Describe-Key")


    "sp"  '(comint-dynamic-complete-filename    :which-key "Describe-Key")

    "sfb" '((lambda () (interactive)
	    (set-face-attribute 'default nil :font "Iosevka SS06" :height 200)
	    ) :which-key "ads")

    "sfn" '((lambda () (interactive)
	    (set-face-attribute 'default nil :font "Iosevka SS06" :height 120)
	    ) :which-key "ads")

    "sl4" '((lambda () (interactive)
	    (setq display-line-numbers-width 4)
	    ) :which-key "ads")

    "sl3" '((lambda () (interactive)
	    (setq display-line-numbers-width )
	    ) :which-key "ads")

    "srf" '((lambda () (interactive)
		(recentf-open-files)
	    ) :which-key "ads")

    "gd" '((lambda () (interactive)
			 (lsp-bridge-find-def)
	    ) :which-key "ads")
)




;; Defining mongolian input method
(quail-define-package
    "Mongolian-trans" "Mg-trans" "S>" t
    "Input method for Mongolian transcription."
    nil t nil nil nil nil nil nil nil nil t)

(quail-define-rules
    ;; keys (without shift)
    ("q" ?ф) ("w" ?ц) ("e" ?у) ("r" ?ж) ("t" ?э) ("y" ?н) ("u" ?г)
    ("i" ?ш) ("o" ?ү) ("p" ?з) ("[" ?к) ("]" ?ъ) ("a" ?й) ("s" ?ы)
    ("d" ?б) ("f" ?ө) ("g" ?а) ("h" ?х) ("j" ?р) ("k" ?о) ("l" ?л)
    (";" ?д) ("'" ?п) ("z" ?я) ("x" ?ч) ("c" ?ё) ("v" ?с) ("b" ?м)
    ("n" ?и) ("m" ?т) ("," ?ь) ("." ?в) ("/" ?ю)

    ;; keys (with shift)
    ("Q" ?ф) ("W" ?Ц)  ("E" ?У) ("R" ?Ж) ("T" ?Э) ("Y" ?Н) ("U" ?Г)
    ("I" ?Ш) ("O" ?Ү)  ("P" ?З) ("{" ?К) ("}" ?Ъ) ("A" ?Й) ("S" ?Ы)
    ("D" ?Б) ("F" ?Ө)  ("G" ?А) ("H" ?Х) ("J" ?Р) ("K" ?О) ("L" ?Л)
    (":" ?Д) ("\"" ?П) ("Z" ?Я) ("X" ?Ч) ("C" ?Ё) ("V" ?С) ("B" ?М)
    ("N" ?И) ("M" ?Т)  ("<" ?Ь) (">" ?В) ("?" ?Ю)


    ;; numbers keys (without shift)
    ("1" ?№) ("2" ?-) ("3" ?\") ("4" ?₮) ("5" ?:) ("6" ?.)
    ("7" ?_) ("8" ?,) ("9" ?%)  ("0" ??) ("-" ?е) ("=" ?щ)


    ;; numbers keys (with shift)
    ("!" ?1) ("@" ?2) ("#" ?3) ("$" ?4) ("%" ?5) ("^" ?6)
    ("&" ?7) ("*" ?8) ("(" ?9) (")" ?0) ("_" ?Е) ("+" ?Щ)
)


(global-set-key (kbd "M-q") 'delete-window)
;(global-set-key (kbd "M-J") '(other-window 1))
;(global-set-key (kbd "M-K") '(other-window -1))
(global-set-key (kbd "M-Q") 'kill-current-buffer)
(global-set-key (kbd "M-w") 'ace-window)
(global-set-key (kbd "M-J") 'other-window)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
(global-set-key (kbd "M-W") 'evil-window-vnew)
(global-set-key (kbd "M-E") 'evil-window-vsplit)

;(global-set-key (kbd "M-RET") 'make-frame)


(add-to-list 'load-path "/home/garid/.config/emacs/writegood-mode")
(require 'writegood-mode)



(require 'org-download)
(add-hook 'dired-mode-hook 'org-download-enable)
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)



(use-package dired
    :ensure nil
    :commands (dired dired-jump)
    ;:bind (("C-x C-j" . dired-jump))
    :custom ((dired-listing-switches "-agho --group-directories-first"))
    :config
    (evil-collection-define-key 'normal 'dired-mode-map
	"h" 'dired-single-up-directory
	"l" 'dired-single-buffer))
(use-package dired-single)


; (message buffer-file-name)

(eshell-git-prompt-use-theme 'powerline)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "dim gray" :foreground "white"))))
 '(mode-line-inactive ((t (:background nil)))))

;(defun highlight-selected-window ()
;    "Highlight selected window with a different background color."
;    (walk-windows (lambda (w)
;                  (unless (eq w (selected-window))
;                    (with-current-buffer (window-buffer w)
;                      (buffer-face-set '(:background "#223"))))))
;  (buffer-face-set 'default))
;
;(when (display-graphic-p)
;    (add-hook 'buffer-list-update-hook 'highlight-selected-window))

;(when (display-graphic-p)
(use-package doom-themes
    :init (load-theme 'doom-gruvbox t))

;;;;;;;;;;;email;;;;;;;;;;;;;;;V
(unless (display-graphic-p)
	(require 'evil-terminal-cursor-changer)
	(evil-terminal-cursor-changer-activate) ; or (etcc-on)
	)




(use-package org-auto-tangle
  ;:load-path "site-lisp/org-auto-tangle/"
  ;; this line is necessary only if you cloned the repo in your site-lisp directory
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))



(plist-put org-format-latex-options :scale 1.7)
(global-set-key (kbd "M-S") 'avy-goto-char-2)
(global-set-key (kbd "M-s") 'avy-goto-char)
(global-set-key (kbd "C-/") 'comment-line)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ; corfu related														    ;;
;; (use-package corfu													    ;;
;;   ;; Optional customizations											    ;;
;;   :custom															    ;;
;;   (corfu-cycle t)                 ; Allows cycling through candidates    ;;
;;   (corfu-auto  t)                  ; Enable auto completion			    ;;
;;   (corfu-auto-prefix 2)												    ;;
;;   (corfu-auto-delay 0.0)												    ;;
;;   (corfu-echo-documentation 0.25) ; Enable documentation for completions ;;
;;   (corfu-preview-current 'insert) ; Do not preview current candidate	    ;;
;;   (corfu-preselect-first nil)										    ;;
;;   (corfu-on-exact-match nil)      ; Don't auto expand tempel snippets    ;;
;; 																		    ;;
;;   ;; Optionally use TAB for cycling, default is `corfu-complete'.	    ;;
;;   :bind (:map corfu-map												    ;;
;;               ("M-SPC" . corfu-insert-separator)						    ;;
;;               ("TAB"     . corfu-next)								    ;;
;;               ([tab]     . corfu-next)								    ;;
;;               ("S-TAB"   . corfu-previous)							    ;;
;;               ([backtab] . corfu-previous)							    ;;
;;               ("S-<return>" . corfu-insert)							    ;;
;;               ("RET"     . nil) ;; leave my enter alone!				    ;;
;;               )														    ;;
;; 																		    ;;
;;   :init																    ;;
;;   (global-corfu-mode)												    ;;
;;   (corfu-history-mode)												    ;;
;;   :config															    ;;
;;   (setq tab-always-indent 'complete)									    ;;
;;   (add-hook 'eshell-mode-hook										    ;;
;;             (lambda () (setq-local corfu-quit-at-boundary t			    ;;
;;                               corfu-quit-no-match t					    ;;
;;                               corfu-auto nil)						    ;;
;;               (corfu-mode))))										    ;;
;; 																		    ;;
;; (add-to-list 'load-path "/home/garid/otherGit/emacs-corfu-doc-terminal") ;;
;; (require 'corfu-doc-terminal)										    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package kind-icon															    ;;
;;   :ensure t																		    ;;
;;   :after corfu																	    ;;
;;   :custom																		    ;;
;;   (kind-icon-default-face 'corfu-default) ; to compute blended backgrounds correctly ;;
;;   :config																		    ;;
;;   (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))			    ;;
;; 																					    ;;
;; 																					    ;;
;; 																					    ;;
;; (add-to-list 'tramp-remote-path 'tramp-own-remote-path)							    ;;
;; (require 'eglot)																	    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


 
;; org in babel
;;; Make sure rustic gets activated in the org-src block and add the original file's source code.
;;; https://www.reddit.com/r/emacs/comments/w4f4u3/using_rustic_eglot_and_orgbabel_for_literate/
;(defun org-babel-edit-prep:python (babel-info)
;        ;; This gets the second item in the "babel-info" list, which holds the code in the original src block
;
;	(message "gry entered python edit prepo")
;        (setq-local src-code (nth 1 babel-info))
;        (setq-local buffer-file-name (expand-file-name (->> babel-info caddr (alist-get :tangle))))
;        (setq-local buffer-src-code (replace-regexp-in-string src-code "" (my-read-file-to-string (buffer-file-name))))
;        (goto-char (point-max))
;        (insert buffer-src-code)
;        (narrow-to-region (point-min) (+ (point-min) (length src-code)))
;        (python-mode)
;        (org-src-mode)
;	)
;    
;(defun my-delete-hidden-text ()
;    "Remove all text that would be revealed by a call to `widen'"
;    (message "gry my-deletehiden")
;    (-let [p-start (point-max)]
;    (widen)
;    (delete-region p-start (point-max))))
;
;(define-advice org-edit-src-exit
;    (:before (&rest _args) remove-src-block)
;    (message "gry org edit src exit")
;    (when (eq major-mode 'python-mode)
;    (my-delete-hidden-text)))
;
;(define-advice org-edit-src-save
;    (:before (&rest _args) remove-src-block)
;    (message "gry org edit src save")
;    (when (eq major-mode 'python-mode)
;    (my-delete-hidden-text)))


(defun replace-in-string (what with in)
  (replace-regexp-in-string (regexp-quote what) with in nil 'literal))


(defun gry/org-open-pdf ()
  (interactive)
  (shell-command
   (concat "zathura "
	   (replace-in-string ".org" ".pdf" buffer-file-name)
	" &"
)))


(defun gry/open-html-in-browser ()
  (interactive)
  (shell-command
   (concat "chromium "
	    buffer-file-name)))


(defun gry/open-term-at ()
  (interactive)
  (shell-command
   (concat "term-at "
	    buffer-file-name
	" &"
)))


;(defun gry/socket-2-file ()
;  (interactive)
;  (shell-command
;   (concat
;	"echo "
;	server-socket-dir
;	   " > /tmp/mysocket")
;   )
;)

;(gry/socket-2-file)

(use-package scad-mode)
(setq-default c-basic-offset 4)


(setq
	browse-url-browser-function 'eww-browse-url ; Use eww as the default browser
	shr-use-fonts  nil                          ; No special fonts
	shr-use-colors nil                          ; No colours
	shr-indentation 2                           ; Left-side margin
	shr-width 85                                ; Fold text to 85 columns
	eww-search-prefix "https://lite.duckduckgo.com/lite/?q=")    ; Use another engine for searching

;(server-start)

(use-package mastodon
	:ensure t
	:config
	(mastodon-discover))
(setq mastodon-instance-url "https://emacs.ch"
		mastodon-active-user "garid3000")

(recentf-mode 1)
(setq recentf-max-menu-items 30)
(setq recentf-max-saved-items 30)


;; trying out the lsp-bridge
(add-to-list 'load-path "/home/garid/otherGit/lsp-bridge/")
; (add-to-list 'load-path "/home/garid/otherGit/lsp-bridge/")
(require 'yasnippet)
(yas-global-mode 1)
(require 'lsp-bridge)
;; (global-lsp-bridge-mode)
(bind-key "C-j" #'acm-select-next lsp-bridge-mode-map)
(bind-key "C-k" #'acm-select-prev lsp-bridge-mode-map)
(setq lsp-bridge-python-lsp-server "pylsp")

;; (unless (display-graphic-p)
;;   (add-to-list 'load-path "/home/garid/otherGit/acm-terminal")
;;   (with-eval-after-load 'acm
;;     (require 'acm-terminal)))

;(require 'flycheck-aspell)
;(flycheck-aspell-define-checker "org"
;  "Org" ("--add-filter" "url")
;  (org-mode))
;(add-to-list 'flycheck-checkers 'org-aspell-dynamic)
;
;;(setq ispell-dictionary "your_default_dictionary")
;(setq ispell-program-name "aspell")
;(setq ispell-silently-savep t)
;
;(advice-add #'ispell-pdict-save :after #'flycheck-maybe-recheck)
;(defun flycheck-maybe-recheck (_)
;  (when (bound-and-true-p flycheck-mode)
;   (flycheck-buffer)))
;
;(require 'flycheck-aspell)
;(add-hook 'text-mode-hook #'flymake-aspell-setup)
;(setq ispell-program-name "aspell")
;(setq ispell-silently-savep t)







(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(command-log-mode-window-font-size 1)
 '(helm-minibuffer-history-key "M-p")
 '(org-agenda-files '("/home/garid/orgfiles/Task.org"))
 '(package-selected-packages
   '(dired-sidebar neotree restart-emacs flycheck-aspell mastodon sqlite format-all scad-mode emacs-everywhere org-contrib csv-mode corfu-doc kind-icon corfu-terminal lsp-pyright arduino-mode org-pomodoro yasnippet-snippets org-fragtog evil-tex auctex orderless consult marginalia mew treemacs-evil treemacs-magit treemacs-icons-dired treemacs-projectile flymake-python-pyflakes eglot corfu elfeed org-sidebar org-modern org-noter-pdftools popper evil-terminal-cursor-changer multi-term org-link-edit org-roam org-auto-tangle which-key vterm visual-fill-column vertico use-package undo-fu typescript-mode tree-sitter-langs toc-org sudo-utils sly selectric-mode rustic ripgrep rainbow-delimiters pyvenv python-bar python-mode ox-hugo org-web-tools org-tree-slide org-present org-pdftools org-download org-bullets ob-tmux ob-rust no-littering macrostep lsp-ui jupyter hide-lines helpful helm-xref helm-lsp gruvbox-theme grammarly general geiser-mit forge flyspell-lazy flycheck evil-nerd-commenter evil-collection eterm-256color eshell-git-prompt edwina doom-themes doom-modeline dired-single dired-open dired-hide-dotfiles desktop-environment darkroom dap-mode company-box command-log-mode beacon auto-package-update all-the-icons-dired 2048-game))
 '(tab-width 4))









