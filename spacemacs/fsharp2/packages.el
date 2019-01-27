;;; packages.el --- F# Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq fsharp2-packages
 '(
     fsharp-mode 
     ggtags 
     company
     counsel-gtags 
     helm-gtags
  ))

(defun fsharp2/init-fsharp-mode ()
  (use-package fsharp-mode
    :defer t
    :init
    (progn
      (setq fsharp-doc-idle-delay .2)
      (spacemacs/register-repl 'fsharp-mode 'fsharp-show-subshell "F#")
      (spacemacs//fsharp2-setup-intellisense)
      (spacemacs/add-to-hook 'fsharp-mode-hook 
       '(spacemacs//fsharp2-setup-backend))
    :config
    (progn
      (defun spacemacs/fsharp-load-buffer-file-focus ()
        "Send the current buffer to REPL and switch to the REPL in
 `insert state'."
        (interactive)
        (fsharp-load-buffer-file)
        (switch-to-buffer-other-window inferior-fsharp-buffer-name)
        (evil-insert-state))

      (defun spacemacs/fsharp-eval-phrase-focus ()
        "Send the current phrase to REPL and switch to the REPL in
 `insert state'."
        (interactive)
        (fsharp-eval-phrase)
        (switch-to-buffer-other-window inferior-fsharp-buffer-name)
        (evil-insert-state))

      (defun spacemacs/fsharp-eval-region-focus (start end)
        "Send the current phrase to REPL and switch to the REPL in
 `insert state'."
        (interactive "r")
        (fsharp-eval-region start end)
        (switch-to-buffer-other-window inferior-fsharp-buffer-name)
        (evil-insert-state))

      (spacemacs//fsharp2-setup-bindings)
      (spacemacs/set-leader-keys-for-major-mode 'fsharp-mode
        ;; Compile
        "cc" 'compile

        "fa" 'fsharp-find-alternate-file

        "ht" 'fsharp-ac/show-tooltip-at-point

        "'"  'fsharp-show-subshell
        "sb" 'fsharp-load-buffer-file
        "sB" 'spacemacs/fsharp-load-buffer-file-focus
        "si" 'fsharp-show-subshell
        "sp" 'fsharp-eval-phrase
        "sP" 'spacemacs/fsharp-eval-phrase-focus
        "sr" 'fsharp-eval-region
        "sR" 'spacemacs/fsharp-eval-region-focus
        "ss" 'fsharp-show-subshell

        "xf" 'fsharp-run-executable-file)))))

(defun fsharp2/post-init-ggtags ()
  (add-hook 'fsharp-mode-local-vars-hook #'spacemacs/ggtags-mode-enable))

(defun fsharp2/post-init-counsel-gtags ()
  (spacemacs/counsel-gtags-define-keys-for-mode 'fsharp-mode))

(defun fsharp2/post-init-helm-gtags ()
  (spacemacs/helm-gtags-define-keys-for-mode 'fsharp-mode))

(defun fsharp2/post-init-company () 
 (spacemacs//fsharp2-setup-company))