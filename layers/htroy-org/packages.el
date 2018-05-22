;;; packages.el --- htroy-org layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author:  <htroy@HUANGCHENG-WORK>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `htroy-org-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `htroy-org/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `htroy-org/pre-init-PACKAGE' and/or
;;   `htroy-org/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst htroy-org-packages
  '(
	(org :location built-in)
	(org-agenda :location built-in)
	blog-admin

		)
  )

(defun htroy-org/post-init-org()

  (spacemacs|disable-company org-mode)
  (setq org-export-with-sub-superscripts '{})
  (setq org-directory "~/emacs/org") ;;

  ;; define the refile targets
  (setq org-agenda-file-note (expand-file-name "notes.org" org-agenda-dir))
  (setq org-agenda-file-gtd (expand-file-name "gtd.org" org-agenda-dir))
  (setq org-agenda-file-journal (expand-file-name "journal.org" org-agenda-dir))
  (setq org-agenda-file-code-snippet (expand-file-name "snippet.org" org-agenda-dir))
  (setq org-default-notes-file (expand-file-name "gtd.org" org-agenda-dir))
  (setq org-agenda-files (list org-agenda-dir))

  ;;set org to keywords
  (setq org-todo-keywords
		(quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
				(sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))

  (setq org-todo-keyword-faces
		(quote (("TODO" :foreground "red" :weight bold)
                ("NEXT" :foreground "blue" :weight bold)
                ("DONE" :foreground "forest green" :weight bold)
                ("WAITING" :foreground "orange" :weight bold)
                ("HOLD" :foreground "magenta" :weight bold)
                ("CANCELED" :foreground "forest green" :weight bold)
                ("MEETING" :foreground "forest green" :weight bold)
                ("PHONE" :foreground "forest green" :weight bold))))

  (setq org-todo-state-tags-triggers
        (quote (("CANCELED" ("CANCELED" . t))
                ("WAITING" ("WAITING" . t))
                ("HOLD" ("WAITING") ("HOLD" . t))
                (done ("WAITING") ("HOLD"))
                ("TODO" ("WAITING") ("CANCELED") ("HOLD"))
                ("NEXT" ("WAITING") ("CANCELED") ("HOLD"))
                ("DONE" ("WAITING") ("CANCELED") ("HOLD")))))

  (setq org-tag-alist '((:startgroup . nil)
						("@Office" . ?o)
						("@Home" . ?h)
						("@Computer". ?c)
						("@Call" . ?C)
						("@Way" . ?w)
						("@Lunchtime" . ?l)))

	;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
  (setq org-capture-templates
		(quote (("t" "todo" entry (file "~/emacs/org/refile.org")
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "respond" entry (file "~/emacs/org/refile.org")
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file "~/emacs/org/refile.org")
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree "~/emacs/org/diary.org")
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file "~/emacs/org/refile.org")
               "* TODO Review %c\n%U\n" :immediate-finish t)
              ("m" "Meeting" entry (file "~/emacs/org/refile.org")
               "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
              ("p" "Phone call" entry (file "~/emacs/org/refile.org")
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file "~/emacs/org/refile.org")
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))


	;; Setting for org refile

	)

(defun htroy-org/init-blog-admin()
  "Initialize blog-admin"
  (use-package blog-admin
    :defer t
    :commands blog-admin-start
    :init
    ;; Keybinding
    (spacemacs/set-leader-keys "ab" 'blog-admin-start)
    :config
	(progn
      ;; Open post after create new post
      (add-hook 'blog-admin-backend-after-new-post-hook 'find-file)
      ;; Hexo
      (setq blog-admin-backend-path "G:/github/hexo")
      (setq blog-admin-backend-type 'hexo)
      ;; create new post in drafts by default
      (setq blog-admin-backend-new-post-in-drafts t)
      ;; create same-name directory with new post
      (setq blog-admin-backend-new-post-with-same-name-dir t)
      ;; default assumes _config.yml
      (setq blog-admin-backend-hexo-config-file "_config.yml"))
    )
  )

(defun htroy-org/post-init-org-agenda()

  (setq org-agenda-files (quote ("~/emacs/org"
                                 "~/emacs/org/client1"
                                 "~/emacs/org/client2")))

  ;; Do not dim blocked tasks
  (setq org-agenda-dim-blocked-tasks nil)

  ;; Compact the block agenda view
  (setq org-agenda-compact-blocks t)

  ;; Custom agenda command definitions
  (setq org-agenda-custom-commands
      (quote (("N" "Notes" tags "NOTE"
               ((org-agenda-overriding-header "Notes")
                (org-tags-match-list-sublevels t)))
              ("h" "Habits" tags-todo "STYLE=\"habit\""
               ((org-agenda-overriding-header "Habits")
                (org-agenda-sorting-strategy
                 '(todo-state-down effort-up category-keep))))
              (" " "Agenda"
               ((agenda "" nil)
                (tags "REFILE"
                      ((org-agenda-overriding-header "Tasks to Refile")
                       (org-tags-match-list-sublevels nil)))
                (tags-todo "-CANCELED/!"
                           ((org-agenda-overriding-header "Stuck Projects")
                            (org-agenda-skip-function 'htroy/skip-non-stuck-projects)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-HOLD-CANCELED/!"
                           ((org-agenda-overriding-header "Projects")
                            (org-agenda-skip-function 'htroy/skip-non-projects)
                            (org-tags-match-list-sublevels 'indented)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-CANCELED/!NEXT"
                           ((org-agenda-overriding-header (concat "Project Next Tasks"
                                                                  (if htroy/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'htroy/skip-projects-and-habits-and-single-tasks)
                            (org-tags-match-list-sublevels t)
                            (org-agenda-todo-ignore-scheduled htroy/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines htroy/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date htroy/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                             '(todo-state-down effort-up category-keep))))
                (tags-todo "-REFILE-CANCELED-WAITING-HOLD/!"
                           ((org-agenda-overriding-header (concat "Project Subtasks"
                                                                  (if htroy/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'htroy/skip-non-project-tasks)
                            (org-agenda-todo-ignore-scheduled htroy/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines htroy/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date htroy/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-REFILE-CANCELED-WAITING-HOLD/!"
                           ((org-agenda-overriding-header (concat "Standalone Tasks"
                                                                  (if htroy/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'htroy/skip-project-tasks)
                            (org-agenda-todo-ignore-scheduled htroy/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines htroy/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date htroy/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-CANCELED+WAITING|HOLD/!"
                           ((org-agenda-overriding-header (concat "Waiting and Postponed Tasks"
                                                                  (if htroy/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
                            (org-agenda-skip-function 'htroy/skip-non-tasks)
                            (org-tags-match-list-sublevels nil)
                            (org-agenda-todo-ignore-scheduled htroy/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines htroy/hide-scheduled-and-waiting-next-tasks)))
                (tags "-REFILE/"
                      ((org-agenda-overriding-header "Tasks to Archive")
                       (org-agenda-skip-function 'htroy/skip-non-archivable-tasks)
                       (org-tags-match-list-sublevels nil))))
               nil))))

  )

;;; packages.el ends here
