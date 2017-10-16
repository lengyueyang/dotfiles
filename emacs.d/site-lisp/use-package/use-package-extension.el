;;; use-package-extension.el --- aa
;;; Commentary:

;;; Code:
(defalias 'use-package-normalize/:evil-bind 'use-package-normalize-forms)
(defalias 'use-package-normalize/:evil-leader 'use-package-normalize-forms)

(defun use-package-handler/:evil-bind (name keyword arg rest state)
  (let* ((body (use-package-process-keywords name rest state))
         (name-symbol (use-package-as-symbol name))
         (config-body
          (use-package-concat
           (use-package-hook-injector (symbol-name name-symbol)
                                      :config `((after-load 'evil
                                                  (evil-define-key ',(caar arg) ,@(cdar arg)))))
           body
           (list t))))
    config-body))

(defun use-package-handler/:evil-leader (name keyword arg rest state)
  (let* ((body (use-package-process-keywords name rest state))
         (name-symbol (use-package-as-symbol name))
         (config-body
          (use-package-concat
           (use-package-hook-injector (symbol-name name-symbol)
                                      :config `((after-load 'evil-leader
                                                  (evil-leader/set-key ,@(cdar arg)))))
           body
           (list t))))
    config-body))

(add-to-list 'use-package-keywords :evil-bind t)
(add-to-list 'use-package-keywords :evil-leader t)

(provide 'use-package-extension)
;;; use-package-extension.el ends here
