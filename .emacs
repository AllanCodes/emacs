(require 'package)
(package-initialize)

;; Initialize the 'use package' package.
(unless (package-installed-p 'use-package)
    (package-refresh-contents)
      (package-install 'use-package))

(eval-when-compile
    (require 'use-package))


;; Downloading packages from the package repo go here
;; They take advamtage of the use-package package that
;; was initialized above.

(use-package magit)
(use-package js2-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode)))
(use-package ido-ubiquitous)
(use-package projectile
  :init
  (projectile-mode +1))
(use-package mic-paren)
(use-package auto-complete)
(use-package tern-auto-complete
  :init
  (eval-after-load 'tern
  '(progn
     (require 'tern-auto-complete)
     (tern-ac-setup))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Markdown

;;

;; flymd (Syntax highlighting and html rendering)

;; To render the markdown in html in Firefox:

;;   M-x flymd-flyit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package flymd)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Global set keys                                                           ;;
;; We define all of my awesome key bindings here.                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "C-c m")    'magit-status)
(global-set-key (kbd "s-<backspace>")
                (lambda ()
                  (interactive)
                  (kill-line 0)))
(global-set-key (kbd "C-<")      'beginning-of-buffer)
(global-set-key (kbd "C->")      'end-of-buffer)
(global-set-key (kbd "<home>")   'beginning-of-line)
(global-set-key (kbd "<end>")    'end-of-line)
(global-set-key (kbd "C-c p")    'projectile-command-map)
(global-set-key (kbd "S-<f7>")   'flyspell-auto-correct-word)
(global-set-key (kbd "C-c C-c")  'delete-char)
(global-set-key  (kbd "s-/")      'comment-or-uncomment-region)
(global-set-key (kbd "C-y") 'yank-and-indent)

;; Deftheme themes can override the default face.  This means that customizing
;; the default face, as I used to do, accomplishes nothing anyway.  Might as
;; well set the default Latin font explicitly then.
;;
;; This code is from cinsk at https://www.emacswiki.org/emacs/SetFonts.  The
;; default font size is in points * 10, so 140 is a 14pt font.  Fonts may be
;; clipped if the font size is unsupported, so check with your favorite font
;; browser first if you're using an unusual point size.
;;
;;
;;     (set-face-attribute 'default nil :family "Consolas" :height 245)
;;
;; Disabled.  The above code _works_, but it doesn't handle 4K displays very well (a
;; 24.5-point font is livable on a 4K monitor but a bit on the large side at
;; standard 1080P resolution.)  Whereas this solution below, from
;; https://coderwall.com/p/ifgyag/change-font-size-in-emacs-dynamically-based-on-screen-resolution,
;; is resolution-independent.

(defun my-fontify-frame (frame)
 (interactive)
 (if window-system
     (progn
       (if (> (x-display-pixel-width) 1920)
           (set-frame-parameter frame 'font "Consolas 14") ;; Cinema Display
         (set-frame-parameter frame 'font "Consolas 12")))))

;; Fontify current fram
(my-fontify-frame nil)

;; Fontify any future frames
(push 'my-fontify-frame after-make-frame-functions)

;; Define a yank and indent function that will auto indent
;; a block that was yanked and has just been pasted.
(defun yank-and-indent ()
  "Yank and then indent the newly formed region according to mode."
  (interactive)
  (yank)
  (call-interactively 'indent-region))


;; Hooks
(add-hook 'before-save-hook 'whitespace-cleanup)

;; This runs when entering any programming mode.
(defun my-prog-mode-hook ()
  (flyspell-prog-mode)
  ;; Activates mic-paren which highlights matching parens/braces etc.
  (paren-activate))

(add-hook 'prog-mode-hook 'my-prog-mode-hook) ;; Attach the hook my-prog-mode defined above, to the programming mode.

;; Spell checks and abbreviations

(setq-default abbrev-mode t)


;; Themes
;; Desert and Zenburn are good

(load-theme 'zenburn t) ;; VIM - https://github.com/bbatsov/zenburn-emacs



;; Functional, set-theoretic collections library

;; Allow any prompt that requires a "yes" or a "no" to accept "y" or "n"
;; instead.
(fset 'yes-or-no-p 'y-or-n-p)


;; Disable scroll bar.
(toggle-scroll-bar -1)

;; setq

(setq load-path (cons (expand-file-name "~/.emacs.d/elisp") load-path))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#32302F" "#FB4934" "#B8BB26" "#FABD2F" "#83A598" "#D3869B" "#17CCD5" "#EBDBB2"])
 '(ansi-term-color-vector
   [unspecified "#3f3f3f" "#dca3a3" "#5f7f5f" "#e0cf9f" "#7cb8bb" "#dc8cc3" "#7cb8bb" "#dcdccc"] t)
 '(company-quickhelp-color-background "#b0b0b0")
 '(company-quickhelp-color-foreground "#232333")
 '(custom-enabled-themes (quote (zenburn)))
 '(custom-safe-themes
   (quote
    ("25c06a000382b6239999582dfa2b81cc0649f3897b394a75ad5a670329600b45" "b3bcf1b12ef2a7606c7697d71b934ca0bdd495d52f901e73ce008c4c9825a3aa" "1177fe4645eb8db34ee151ce45518e47cc4595c3e72c55dc07df03ab353ad132" "61ae193bf16ef5c18198fbb4516f0c61a88f7b55b693a3b32d261d8501c4a54b" "180adb18379d7720859b39124cb6a79b4225d28cef4bfcf4ae2702b199a274c8" "2d5c40e709543f156d3dee750cd9ac580a20a371f1b1e1e3ecbef2b895cf0cd2" "77515a438dc348e9d32310c070bfdddc5605efc83671a159b223e89044e4c4f1" "da8e6e5b286cbcec4a1a99f273a466de34763eefd0e84a41c71543b16cd2efac" "5c83b15581cb7274085ba9e486933062652091b389f4080e94e4e9661eaab1aa" "ed92c27d2d086496b232617213a4e4a28110bdc0730a9457edf74f81b782c5cf" "09feeb867d1ca5c1a33050d857ad6a5d62ad888f4b9136ec42002d6cdf310235" "d9e811d5a12dec79289c5bacaecd8ae393d168e9a92a659542c2a9bab6102041" "57d7e8b7b7e0a22dc07357f0c30d18b33ffcbb7bcd9013ab2c9f70748cfa4838" "fe349b21bb978bb1f1f2db05bc87b2c6d02f1a7fe3f27584cd7b6fbf8e53391a" "cb39485fd94dabefc5f2b729b963cbd0bac9461000c57eae454131ed4954a8ac" "8e7044bfad5a2e70dfc4671337a4f772ee1b41c5677b8318f17f046faa42b16b" "6c0d748fb584ec4c8a0a1c05ce1ae8cde46faff5587e6de1cc59d3fc6618e164" "2047464bf6781156ebdac9e38a17b97bd2594b39cfeaab561afffcbbe19314e2" "62a6731c3400093b092b3837cff1cb7d727a7f53059133f42fcc57846cfa0350" "d422c7673d74d1e093397288d2e02c799340c5dabf70e87558b8e8faa3f83a6c" "c51e302edfe6d2effca9f7c9a8a8cfc432727efcf86246002a3b45e290306c1f" "b48599e24e6db1ea612061252e71abc2c05c05ac4b6ad532ad99ee085c7961a7" "ff8c6c2eb94e776c9eed9299a49e07e70e1b6a6f926dec429b99cf5d1ddca62a" "1127f29b2e4e4324fe170038cbd5d0d713124588a93941b38e6295a58a48b24f" "deb7ae3a735635a85c984ece4ce70317268df6027286998b0ea3d10f00764c9b" "cdc2a7ba4ecf0910f13ba207cce7080b58d9ed2234032113b8846a4e44597e41" "abd7719fd9255fcd64f631664390e2eb89768a290ee082a9f0520c5f12a660a8" "6383f86cac149fb10fc5a2bac6e0f7985d9af413c4be356cab4bfea3c08f3b42" "617341f1be9e584692e4f01821716a0b6326baaec1749e15d88f6cc11c288ec6" "77c3f5f5acaa5a276ca709ff82cce9b303f49d383415f740ba8bcc76570718b9" "a5956ec25b719bf325e847864e16578c61d8af3e8a3d95f60f9040d02497e408" "cd4d1a0656fee24dc062b997f54d6f9b7da8f6dc8053ac858f15820f9a04a679" "fcecf5757b909acbacc4fea2fa6a5fb9a63776be43cbff1dc0dffc9c02674478" "115d42fa02a5ce6a759e38b27304e833d57a48422c2408d5455f14450eb96554" "b48150eac948d6de3f8103e6e92f105979277b91c96e9687c13f2d80977d381d" "bfdcbf0d33f3376a956707e746d10f3ef2d8d9caa1c214361c9c08f00a1c8409" "ec5f761d75345d1cf96d744c50cf7c928959f075acf3f2631742d5c9fe2153ad" "cc2f32f5ee19cbd7c139fc821ec653804fcab5fcbf140723752156dc23cdb89f" "0f302165235625ca5a827ac2f963c102a635f27879637d9021c04d845a32c568" "ec0c9d1715065a594af90e19e596e737c7b2cdaa18eb1b71baf7ef696adbefb0" "9dc64d345811d74b5cd0dac92e5717e1016573417b23811b2c37bb985da41da2" "5b340b4eb24c3c006972f3bc3aee26b7068f89ba9580d9a4211c1db5d0a70ea2" "dd2346baba899fa7eee2bba4936cfcdf30ca55cdc2df0a1a4c9808320c4d4b22" default)))
 '(delete-selection-mode t)
 '(display-line-numbers t)
 '(electric-pair-delete-adjacent-pairs t)
 '(electric-pair-mode t)
 '(electric-pair-preserve-balance t)
 '(electric-quote-mode t)
 '(ensime-sem-high-faces
   (quote
    ((var :foreground "#000000" :underline
          (:style wave :color "yellow"))
     (val :foreground "#000000")
     (varField :foreground "#600e7a" :slant italic)
     (valField :foreground "#600e7a" :slant italic)
     (functionCall :foreground "#000000" :slant italic)
     (implicitConversion :underline
                         (:color "#c0c0c0"))
     (implicitParams :underline
                     (:color "#c0c0c0"))
     (operator :foreground "#000080")
     (param :foreground "#000000")
     (class :foreground "#20999d")
     (trait :foreground "#20999d" :slant italic)
     (object :foreground "#5974ab" :slant italic)
     (package :foreground "#000000")
     (deprecated :strike-through "#000000"))))
 '(fill-column 80)
 '(flyspell-abbrev-p t)
 '(flyspell-use-global-abbrev-table-p t)
 '(fringe-mode 10 nil (fringe))
 '(global-display-line-numbers-mode t)
 '(ido-enable-flex-matching t)
 '(ido-mode (quote both) nil (ido))
 '(ido-ubiquitous-command-overrides
   (quote
    ((enable exact "execute-extended-command")
     (enable prefix "wl-")
     (enable-old prefix "Info-")
     (enable exact "webjump")
     (enable regexp "\\`\\(find\\|load\\|locate\\)-library\\'")
     (disable prefix "org-")
     (disable prefix "magit-")
     (disable prefix "tmm-"))))
 '(ido-ubiquitous-mode t)
 '(ido-use-virtual-buffers t)
 '(indent-tabs-mode nil)
 '(ispell-program-name "/usr/local/bin/aspell")
 '(jdee-db-active-breakpoint-face-colors (cons "#f0f0f0" "#4078f2"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#f0f0f0" "#50a14f"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#f0f0f0" "#9ca0a4"))
 '(js-indent-level 4)
 '(js-switch-indent-offset 4)
 '(linum-format " %6d ")
 '(main-line-color1 "#222912")
 '(main-line-color2 "#09150F")
 '(package-archives
   (quote
    (("gnu" . "https://elpa.gnu.org/packages/")
     ("marmalade" . "https://marmalade-repo.org/packages/")
     ("melpa-stable" . "http://stable.melpa.org/packages/")
     ("melpa" . "https://melpa.org/packages/"))))
 '(package-selected-packages
   (quote
    (markdown-mode flymd tern-auto-complete auto-complete skewer-mode tern company-tern company zenburn-theme mic-paren projectile ido-ubiquitous abyss-theme alect-themes ample-theme ample-zen-theme anti-zenburn-theme assemblage-theme badwolf-theme base16-theme bubbleberry-theme clues-theme color-theme-modern creamsody-theme cyberpunk-theme darcula-theme darktooth-theme doom-themes dracula-theme flatui-dark-theme gandalf-theme gotham-theme grandshell-theme gruvbox-theme intellij-theme ir-black-theme use-package)))
 '(pos-tip-background-color "#36473A")
 '(pos-tip-foreground-color "#FFFFC8")
 '(powerline-color1 "#222912")
 '(powerline-color2 "#09150F")
 '(recentf-max-saved-items 1000)
 '(recentf-mode t)
 '(use-package-always-ensure t)
 '(winner-mode t)
 '(winner-ring-size 1000))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
