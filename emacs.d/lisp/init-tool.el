(require-package 'youdao-dictionary)
(require-package 'avy)

(use-package youdao-dictionary
  :defer t
  :config
  (progn
    ;; Enable Cache
    (setq url-automatic-caching t
          ;; Set file path for saving search history
          youdao-dictionary-search-history-file (concat maple-cache-directory "youdao")
          ;; Enable Chinese word segmentation support
          youdao-dictionary-use-chinese-word-segmentation t))
  )
;; (use-package cal-china-x
;;   :config
;;   (progn
;;     (setq mark-holidays-in-calendar t)
;;     (setq cal-china-x-important-holidays cal-china-x-chinese-holidays)
;;     (setq calendar-holidays cal-china-x-important-holidays)
;;     ))

(use-package avy
    :defer t
    :commands (maple/avy-open-url maple/avy-goto-url avy-pop-mark)
    :init
    (progn
      (setq avy-all-windows 'all-frames)
      (setq avy-background t))
    :config
    (progn
      (defun maple/avy-goto-url()
        "Use avy to go to an URL in the buffer."
        (interactive)
        (avy--generic-jump "https?://" nil 'pre))
      (defun maple/avy-open-url ()
        "Use avy to select an URL in the buffer and open it."
        (interactive)
        (save-excursion
          (maple/avy-goto-url)
          (browse-url-at-point)))))

(provide 'init-tool)