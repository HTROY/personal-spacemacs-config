;; 参考http://doc.norang.ca/org-mode.html
(defun htroy/hide-other()
(interactive)
(save-excursion
  (org-back-to-heading 'invisible-p)
  (hide-other)
  (org-cycle)
  (org-cycle)
  (org-cycle)))

(defun htroy/set-truncate-lines()
  "Toggle value of truncate-lines and refresh window display."
  (interactive)
  (setq truncate-lines (not truncate-lines))
  ;;now refresh window display (an idiom from simple.el):
  (save-excursion
	(set-window-start (select-window)
					  (window-start (select-window)))))

(defun htroy/make-org-scrath()
  (interactive)
  (find-file "~/tmp/publish/scratch.org")
  (gnus-make-directory "~/tmp/publish"))

(defun htroy/switch-to-scratch()
  (interactive)
  (switch-to-buffer "*scratch*"))

(defun htroy/remove-empty-drawer-on-clock-out ()
  (interactive)
  (save-excursion
	(beginning-of-line 0)
	(org-remove-empty-drawer-at "LOGBOOK" (point))))

(add-hook 'org-clock-out-hook 'htroy/remove-empty-drawer-on-clock-out 'append)
