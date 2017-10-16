;;; This file bootstraps the configuration, which is divided into
;;; a number of other files.

;;; Without this comment emacs25 adds (package-initialize) here
;; (package-initialize); You may delete these explanatory comments.

(defconst *at_home* t)

(let ((file-name-handler-alist nil))
  (setq gc-cons-threshold (* 128 1024 1024))
  (setq user-full-name "jianglin")
  (setq user-mail-address "lin.jiang@upai.com")
  (setq user-default-theme 'monokai)
  (when *at_home*
    (setq user-mail-address "xiyang0807@gmail.com"))
  (setq inhibit-startup-echo-area-message "jianglin")

  (add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

  (defadvice require (around require activate)
    (let ((start (current-time))
          res delta)
      (setq res ad-do-it)
      (setq delta (float-time (time-since start)))
      (when (> delta 0.1)
        (message "Required %s: %s sec" (ad-get-arg 0) delta))
      res))

  ;;----------------------------------------------------------------------------
  ;; Bootstrap config
  ;;----------------------------------------------------------------------------
  (require 'init-utils)
  (require 'init-elpa)      ;; Machinery for installing required packages
  ;;----------------------------------------------------------------------------
  ;; Load configs for specific features and modes
  ;;----------------------------------------------------------------------------
  ;; (setq force-load-messages t)
  (use-package diminish
    :ensure t
    :defer t) ;;显示状态mode
  (use-package scratch
    :ensure t
    :defer t) ;;缓冲区
  (use-package mwe-log-commands
    :ensure t
    :defer t) ;; 命令行历史

  (defconst *system-is-mac* (eq system-type 'darwin))
  (defconst *system-is-linux* (eq system-type 'gnu/linux))
  (defconst *system-is-mswindows* (eq system-type 'windows-nt))
  (defconst *common* t)
  (defconst *develop* t)
  ;; (defun maple/show-init-time ()
  ;;   (message "Emacs load finished in %.2fms"
  ;;            (* 1000.0 (float-time (time-subtract after-init-time before-init-time)))))

  ;; (add-hook 'after-init-hook 'maple/show-init-time)
  (when *common*
    (require 'init-fonts)
    (require 'init-ui)  ;; modeline,which-key
    (require 'init-gui) ;;ui设置 显示行号

    (require 'init-evil)

    (use-package exec-path-from-shell
      :if *system-is-mac*
      :ensure t
      :init (exec-path-from-shell-initialize))


    (require 'init-editor) ;;自动补全括号等
    (require 'init-whitespace) ;;空白控制
    (require 'init-folding) ;;代码折叠
    (require 'init-auto-insert)  ;;自动插入文件头

    (require 'init-helm)
    (require 'init-dired)   ;;自带文件管理
    (require 'init-file)   ;;文件操作
    (require 'init-buffer)   ;;buffer操作
    (require 'init-windows)  ;;窗口管理C-x 2上下,C-x 3左右
    )

  (when *develop*
    (require 'init-flycheck)
    (require 'init-spelling)
    (require 'init-company)
    ;; (require 'init-rss)

    (require 'init-git)

    (require 'init-shell) ;;shell
    (require 'init-html)
    (require 'init-js)
    (require 'init-python)
    (require 'init-go)
    (require 'init-c)
    (require 'init-sql)
    (require 'init-text) ;; markdown rst
    (require 'init-org)
    (require 'init-tool)
    )

  (require 'init-keybind)

  ;;----------------------------------------------------------------------------
  ;; Variables configured via the interactive 'customize' interface
  ;;----------------------------------------------------------------------------
  (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
  (when (file-exists-p custom-file)
    (load custom-file))
  )

;;----------------------------------------------------------------------------
;; Allow access from emacsclient
;;----------------------------------------------------------------------------
(require 'server)
(unless (server-running-p)
  (server-start))


(provide 'init)  

;; Local Variables:
;; coding: utf-8
;; no-byte-compile: t
;; End:
