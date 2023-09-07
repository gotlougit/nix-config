(startup-redirect-eln-cache "~/.cache/magit/eln-cache")
(setq indent-tabs-mode          nil
      inhibit-startup-message   t
      make-backup-files         nil
      create-lockfiles          nil
      auto-save-default         nil
      user-emacs-directory      "~/.cache/magit/user-dir/")

(setq temporary-file-directory "~/.cache/magit/")
(setq auto-save-file-name-transforms
  `((".*" ,temporary-file-directory t)))

(setq-default mode-line-format nil)
(fset 'yes-or-no-p 'y-or-n-p)
(global-auto-revert-mode t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(xterm-mouse-mode 1)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq evil-want-keybinding nil)
(require 'evil)
(require 'evil-collection)
(evil-mode 1)
(evil-collection-init)

(require 'ediff)
(setq ediff-diff-options "-w") ; ignore whitespace

(require 'ivy)
(ivy-mode 1)

(require 'magit)
(magit)
(delete-other-windows)
