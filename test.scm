;; File: test.scm

;; this program should be run with the command
;;
;; gsi -e '(load "define-library")' github.com/feeley/digest/digest test.scm

(define-library (test)

  (import (only (gambit)
                define quote pp ;; required directly in the body
                if not begin) ;; required by expansions of when and unless
          (when-unless))

  (begin

    (when #t
      (pp 123)

      ;; should give "da39a3ee5e6b4b0d3255bfef95601890afd80709"

      ;; should give "a9993e364706816aba3e25717850c26c9cd0d89d"
      )))
