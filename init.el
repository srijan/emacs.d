;; Emacs Configuration

;; Prevent the cursor from blinking
(blink-cursor-mode 0)

;; Don't let Emacs hurt your ears
(setq visible-bell t)

;; Remove GUI extras
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

; Add line numbers
; (global-linum-mode 0)

; Hide splash screen and banner
(setq
 initial-scratch-message ""
 inhibit-startup-message t
 inhibit-startup-echo-area-message t)
(define-key global-map (kbd "RET") 'newline-and-indent)

;; full screen
(defun fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen
		       (if (frame-parameter nil 'fullscreen) nil 'fullboth)))
(global-set-key [C-f11] 'fullscreen)

(defun maximize ()
  (interactive)
  (shell-command "wmctrl -r :ACTIVE: -btoggle,maximized_vert,maximized_horz"))
(global-set-key [f11] 'maximize)

;; See http://bzg.fr/emacs-hide-mode-line.html
(defvar-local hidden-mode-line-mode nil)
(defvar-local hide-mode-line nil)

(define-minor-mode hidden-mode-line-mode
  "Minor mode to hide the mode-line in the current buffer."
  :init-value nil
  :global nil
  :variable hidden-mode-line-mode
  :group 'editing-basics
  (if hidden-mode-line-mode
      (setq hide-mode-line mode-line-format
            mode-line-format nil)
    (setq mode-line-format hide-mode-line
          hide-mode-line nil))
  (force-mode-line-update)
  (set-window-buffer nil (current-buffer))
  (when (and (called-interactively-p 'interactive)
             hidden-mode-line-mode)
    (run-with-idle-timer
     0 nil 'message
     (concat "Hidden Mode Line Mode enabled.  "
             "Use M-x hidden-mode-line-mode to make the mode-line appear."))))

;; Activate hidden-mode-line-mode
(hidden-mode-line-mode 1)

;; Command to toggle the display of the mode-line as a header
(defvar-local header-line-format nil)
(defun mode-line-in-header ()
  (interactive)
  (if (not header-line-format)
      (setq header-line-format mode-line-format
            mode-line-format nil)
    (setq mode-line-format header-line-format
          header-line-format nil))
  (set-window-buffer nil (current-buffer)))
(global-set-key (kbd "C-M-SPC") 'mode-line-in-header)

;; Indent size
(setq standard-indent 2)

;; Use spaces for indents
(setq-default indent-tabs-mode nil) 

;; Backup files in ~/tmp/.emacs/backup
(setq make-backup-files t)
(setq version-control t)
(setq backup-directory-alist (quote ((".*" . "~/tmp/.emacs/backup/"))))
(setq delete-old-versions t)
 
;; Jump mouse away when typing
(mouse-avoidance-mode 'jump)

;; Turn on highlight paren mode
(show-paren-mode t)

(defun font-lock-comment-annotations ()
  "Highlight a bunch of well known comment annotations.
This functions should be added to the hooks of major modes for
programming."
  (font-lock-add-keywords
   nil '(("\<\(FIX\(ME\)?\|TODO\|OPTIMIZE\|HACK\|REFACTOR\):"
          1 font-lock-warning-face t))))
(add-hook 'prog-mode-hook 'font-lock-comment-annotations)

;; TRAMP stuff
(set-default 'tramp-default-proxies-alist (quote ((".*" "\\`root\\'" "/ssh:%h:"))))

;; Magit
(autoload 'magit-status "magit" nil t)
(global-set-key (kbd "C-x g") 'magit-status)

;; Elscreen
;(load "elscreen" "ElScreen" t)

;; ; Set up marmalade
;; (require 'package)
;; (add-to-list 'package-archives 
;;     '("marmalade" .
;;       "http://marmalade-repo.org/packages/"))
;; (package-initialize)

;; melpa
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(setq package-list
      '(ag auto-complete autopair csv-mode deferred diff-hl elixir-mode erlang etags-table find-file-in-project flymake-cursor flymake-jshint flymake-json flymake-php flymake-shell flymake-easy git-gutter-fringe+ fringe-helper git-gutter+ goto-last-change helm idomenu jinja2-mode leuven-theme magit git-rebase-mode git-commit-mode markdown-mode monokai-theme multi-term mustang-theme nginx-mode oauth2 org-pomodoro alert php-mode popup popwin projectile pkg-info epl dash rfringe s simple-httpd soft-morning-theme solarized-theme sql-indent sublime-themes twittering-mode w3 w3m web web-mode zenburn-theme evil multiple-cursors mc-extras))

(mapc
 (lambda (package)
   (or (package-installed-p package)
       (if (y-or-n-p (format "Package %s is missing. Install it? " package)) 
           (package-install package))))
 package-list)

;; Evil mode
(require 'evil)
(evil-mode 1)

;; Popwin
(require 'popwin)
(popwin-mode 1)

(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-unset-key (kbd "C-<down-mouse-1>"))
(global-set-key (kbd "C-<mouse-1>") 'mc/add-cursor-on-click)

; Autoload markdown
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

; Conditional settings, depending on graphical mode or terminal
(if (display-graphic-p)
  (progn
    ;; if graphic
    ; Theme
    (load-theme 'solarized-light t)
    ; Make window maximized
    ; (shell-command "wmctrl -r :ACTIVE: -btoggle,maximized_vert,maximized_horz")
    ; Set font
    (set-face-attribute 'default nil :font "Monaco-11")
    :tabnew
    )
  ;; else
  (load-theme 'wombat t)
  )

;; TAGS
(require 'etags-table)
(setq tag-table-alist 
      '(("~/.emacs.d/" . "~/.emacs.d/TAGS")))
(setq etags-table-alist tag-table-alist)
(setq etags-table-search-up-depth 2)

;; Erlang
(setq erlang-root-dir "~/Apps/erlang/default")
(setq exec-path (cons "~/Apps/erlang/default/bin" exec-path))
(setq erlang-man-root-dir "~/Apps/erlang/default/man")
(require 'erlang-start)
(require 'erlang-flymake)
(add-hook 'erlang-mode-hook '(lambda ()
                             (local-set-key (kbd "RET") 'newline-and-indent)))

;; Autocomplete
;(add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")
(require 'auto-complete-config)
(ac-config-default)
(global-auto-complete-mode t)
(add-to-list 'ac-modes 'erlang-mode)

;; ESS
;(require 'ess-site)

;; Key bindings
(global-set-key [(meta ?/)] 'hippie-expand)
(global-set-key [(super ?i)] 'imenu)
(global-set-key (kbd "C-x C-i") 'ido-imenu)
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

(require 'ido)
(ido-mode t)

;; Server auto start
(require 'server)
(unless (server-running-p)
  (server-start))

;; Mail stuff
(add-to-list 'auto-mode-alist '("/mutt" . mail-mode))

;; Settings related to org mode
(add-hook 'org-mode-hook 'turn-on-font-lock)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-log-done 'time)
(setq org-clock-into-drawer t)
(setq org-closed-keep-when-no-todo t)
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)
(setq org-directory "~/.dropbox_srijan/Dropbox/org_mode")
(setq org-agenda-files '("~/.dropbox_srijan/Dropbox/org_mode/Todo.org"))
(setq org-mobile-inbox-for-pull "~/.dropbox_srijan/Dropbox/org_mode/minbox.org")
(setq org-mobile-directory "~/.dropbox_srijan/Dropbox/MobileOrg")

;; Elfeed
(global-set-key (kbd "C-x w") 'elfeed)

;; Web Mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  )
(add-hook 'web-mode-hook 'web-mode-hook)

;; Terminal apps
(defun djcb-term-start-or-switch (prg &optional use-existing)
  "* run program PRG in a terminal buffer. If USE-EXISTING is non-nil "
  " and PRG is already running, switch to that buffer instead of starting"
  " a new instance."
  (interactive)
  (let ((bufname (concat "*" prg "*")))
    (when (not (and use-existing
                    (let ((buf (get-buffer bufname)))
                      (and buf (buffer-name (switch-to-buffer bufname))))))
      (ansi-term prg prg))))

(defmacro djcb-program-shortcut (name key &optional use-existing)
  "* macro to create a key binding KEY to start some terminal program PRG; 
    if USE-EXISTING is true, try to switch to an existing buffer"
  `(global-set-key ,key 
                   '(lambda()
                      (interactive)
                      (djcb-term-start-or-switch ,name ,use-existing))))

;; Twittering Mode
(setq twittering-icon-mode t)

;; Projectile
(projectile-global-mode)
(global-set-key (kbd "C-c h") 'helm-projectile)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("ce79400f46bd76bebeba655465f9eadf60c477bd671cbcd091fe871d58002a88" "146d24de1bb61ddfa64062c29b5ff57065552a7c4019bee5d869e938782dfc2a" "1989847d22966b1403bab8c674354b4a2adf6e03e0ffebe097a6bd8a32be1e19" "c7306fa678d07e5ce463852fac0a07c02f38bc419282999c667db245de795204" "a30d5f217d1a697f6d355817ac344d906bb0aae3e888d7abaa7595d5a4b7e2e3" "e26780280b5248eb9b2d02a237d9941956fc94972443b0f7aeec12b5c15db9f3" "a774c5551bc56d7a9c362dca4d73a374582caedb110c201a09b410c0ebbb5e70" "c7359bd375132044fe993562dfa736ae79efc620f68bab36bd686430c980df1c" "0ebe0307942b6e159ab794f90a074935a18c3c688b526a2035d14db1214cf69c" "33c5a452a4095f7e4f6746b66f322ef6da0e770b76c0ed98a438e76c497040bb" "9bcb8ee9ea34ec21272bb6a2044016902ad18646bd09fdd65abae1264d258d89" "9a217ee1dcefd5e83f78381c61e25e9c4d25c7b80bf032f44d7d62ca68c6a384" "90b5269aefee2c5f4029a6a039fb53803725af6f5c96036dee5dc029ff4dff60" "91b5a381aa9b691429597c97ac56a300db02ca6c7285f24f6fe4ec1aa44a98c3" "8dd5991bf912b39dc4ae77e2d6aa4882949f4441570222eaf25e07ec38c44d50" "8eef22cd6c122530722104b7c82bc8cdbb690a4ccdd95c5ceec4f3efa5d654f5" "99cbc2aaa2b77374c2c06091494bd9d2ebfe6dc5f64c7ccdb36c083aff892f7d" "d293542c9d4be8a9e9ec8afd6938c7304ac3d0d39110344908706614ed5861c9" "7d090d4b15e530c28a35e084700aca464291264aad1fa2f2b6bba33dd2e92fd5" "e16a771a13a202ee6e276d06098bc77f008b73bbac4d526f160faa2d76c1dd0e" "dc46381844ec8fcf9607a319aa6b442244d8c7a734a2625dac6a1f63e34bc4a6" "f220c05492910a305f5d26414ad82bf25a321c35aa05b1565be12f253579dec6" "c9cdbcbe046dcbc205b1b8ba3055ee62287a3663908a38e6e66cd7b27e2ae3b0" "124e34f6ea0bc8a50d3769b9f251f99947d6b4d9422c6d85dc4bcc9c2e51b39c" "978bd4603630ecb1f01793af60beb52cb44734fc14b95c62e7b1a05f89b6c811" "29a4267a4ae1e8b06934fec2ee49472daebd45e1ee6a10d8ff747853f9a3e622" "3ad55e40af9a652de541140ff50d043b7a8c8a3e73e2a649eb808ba077e75792" "ff2f110c788eae35007b9c2274362c5f5a824bf363be4daddad60c717075870e" "fc6e906a0e6ead5747ab2e7c5838166f7350b958d82e410257aeeb2820e8a07a" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(elfeed-feeds (quote ("http://www.daemonology.net/hn-daily/index.rss" "http://emacs-fu.blogspot.com/feeds/posts/default" "http://feeds.feedburner.com/blogspot/vLjkZ" "http://sunalinisinha.blogspot.com/feeds/posts/default" "http://www.srijn.net/atom.xml" "http://thepilanidiaries.blogspot.com/feeds/posts/default" "http://feeds.feedburner.com/SunitsWorld" "http://blog.gauravbits.com/feeds/posts/default" "http://whattheemacsd.com/atom.xml" "http://yanpritzker.com/feed/" "http://blog.cloudflare.com/rss.xml" "http://feeds.feedburner.com/steveklabnik" "https://blog.irccloud.com/feed.xml" "http://johncarlosbaez.wordpress.com/feed/" "http://matt.might.net/articles/feed.rss" "http://blog.tomahawk-player.org/rss" "http://www.scottaaronson.com/blog/?feed=rss2" "http://lucumr.pocoo.org/feed.atom" "http://feeds.feedburner.com/robinsloan" "http://rdist.root.org/feed/" "http://techmeasy.blogspot.com/feeds/posts/default" "https://lwn.net/headlines/rss" "http://blog.cryptographyengineering.com/feeds/posts/default" "http://rsontech.net/rss" "http://basho.com/feed/" "http://joearms.github.com/feed" "http://windytan.blogspot.com/feeds/posts/default" "http://www.pixelastic.com/blog.rss" "http://www.datagenetics.com/feed/rss.xml" "http://ridiculousfish.com/blog/feed/" "http://dilbert.com/blog/entry.feed/" "http://ferd.ca/feed.rss" "http://kchandrasekaran.wordpress.com/feed/" "http://www.metabrew.com/rss.xml" "http://slatestarcodex.com/feed/" "https://planet.archlinux.org/atom.xml" "http://atinangrish.posterous.com/rss.xml" "http://feeds.feedburner.com/spencerfry" "http://www.erlang.org/rss/news" "http://www.joelonsoftware.com/rss.xml" "http://sebastianmarshall.com/community/rss/" "http://feeds.feedburner.com/SickillNet" "http://blog.bitbucket.org/feed/" "http://feeds.feedburner.com/metasploit/blog" "http://www.digininja.org/rss.xml" "http://www.ethicalhacker.net/index2.php?option=com_rss&feed=RSS2.0&no_html=1" "http://www.pauldotcom.com/atom.xml" "http://feeds.feedburner.com/darknethackers" "http://www.irongeek.com/irongeek.rss" "http://feeds.security-database.com/security-database-news" "http://feeds.feedburner.com/Room362com" "http://packetstormsecurity.org/headlines.xml" "http://carnal0wnage.attackresearch.com/feeds/posts/default" "http://feeds2.feedburner.com/PenTestIT" "http://www.loper-os.org/?feed=rss2" "http://whatif.xkcd.com/feed.atom" "http://feeds.feedburner.com/thechangelog" "http://gauravbits575.blogspot.com/feeds/posts/default" "http://feeds.cyberciti.biz/Nixcraft-LinuxFreebsdSolarisTipsTricks" "http://ozkatz.github.com/feeds/all.atom.xml" "http://engineersunit.blogspot.com/feeds/posts/default" "http://feeds.feedburner.com/smbc-comics/PvLb" "http://rationallyspeaking.blogspot.com/feeds/posts/default" "http://thecodelesscode.com/rss" "http://www.xkcd.com/rss.xml" "http://lifeiscrazy-supriya.blogspot.com/feeds/posts/default" "http://feeds.feedburner.com/StyleGirlfriend" "http://onethingwell.org/rss?bac99e00" "http://feeds.feedburner.com/linuxjournalcom?format=xml" "https://www.archlinux.org/feeds/news/" "http://lasyajagirdhar.blogspot.com/feeds/posts/default" "http://radioaktiv.posterous.com/rss.xml" "http://www.aaronsw.com/2002/feeds/pgessays.rss" "http://lesswrong.com/.rss" "http://0x10c.com/feed/atom/" "http://www.lowendbox.com/feed/" "http://googleblog.blogspot.com/feeds/posts/default" "http://musicforprogramming.net/rss.php")))
 '(term-unbind-key-list (quote ("C-z" "C-x" "C-c" "C-h" "C-y" "<ESC>" "C-p" "C-n")))
 '(wakatime-api-key "d27893e5-0a6b-4c3f-b47f-3dbacae81f0f")
 '(wakatime-cli-path "/home/srijan/scripts/wakatime/wakatime-cli.py"))
       ;; foreground color (yellow)

;; Terminal apps shortcuts
(djcb-program-shortcut "zsh"  (kbd "<S-f1>") t)   ; the ubershell
(djcb-program-shortcut "mutt"  (kbd "<S-f2>") t)  ; mail client


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
