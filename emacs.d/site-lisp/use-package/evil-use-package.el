;;; evil-use-package.el --- Declarative evil configuration for use-package -*- lexical-binding: t; -*-

;;; Commentary:


;;; Code:

(require 'use-package)
(require 'dash)

(defun evil-use-package-wrap-weal (file list)
  `(with-eval-after-load ',file ,@list))

(defun evil-use-package-quote-symbols (list)
  (--map-when (symbolp it) `(quote ,it) list))

(defun evil-use-package-kbd-strings (list)
  (--map-when (stringp it) (kbd it) list))

(defun evil-use-package-wrap-when-car (pred var)
  (if (and (consp var) (funcall pred (car var)))
      (list var)
    var))

(defun evil-use-package-evil-state (mode-states)
  (->> mode-states
       (evil-use-package-wrap-when-car #'symbolp)
       (-map (-lambda ((mode . state))
               `(evil-set-initial-state ',mode ',state)))
       (evil-use-package-wrap-weal 'evil)))

(defun evil-use-package-evil-bind (args)
  (->> args
       (evil-use-package-wrap-when-car #'symbolp)
       (-non-nil)
       (-map (-lambda ((state . bindings))
               (let* ((global (= (% (length bindings) 2) 0))
                      (keymap (if global 'global-map (car bindings)))
                      (binds (if global bindings (cdr bindings))))
                 `(evil-define-key ',state ,keymap
                    ,@(-> binds
                          evil-use-package-quote-symbols
                          evil-use-package-kbd-strings)))))
       (evil-use-package-wrap-weal 'evil)))

(defun evil-use-package-evil-leader (args)
  (->> args
       (evil-use-package-wrap-when-car #'stringp) ; TODO
       (-non-nil)
       (--map (cons (if (symbolp (car it))
                        'evil-leader/set-key-for-mode
                      'evil-leader/set-key)
                    (evil-use-package-quote-symbols it)))
       (evil-use-package-wrap-weal 'evil-leader)))

(defun evil-use-package-rewrite-args (args rewriters)
  (--reduce-from
   (-if-let (index (-elem-index (car it) acc))
       (let ((elem (nth (1+ index) acc))
             (config-body (plist-get acc :config))
             (clean-args (-remove-at-indices `(,index ,(1+ index)) acc)))
         (plist-put clean-args :config
                    `(progn ,config-body
                            ,(funcall (cdr it) elem))))
     acc)
   args
   rewriters))

(defadvice use-package (before evil-use-package-advice (name &rest args) activate)
  (setq args (evil-use-package-rewrite-args
              args
              '((:evil-state  . evil-use-package-evil-state)
                (:evil-bind   . evil-use-package-evil-bind)
                (:evil-leader . evil-use-package-evil-leader)))))

(provide 'evil-use-package)
