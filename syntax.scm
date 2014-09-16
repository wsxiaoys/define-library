;;;============================================================================

;;; File: "syntax.scm"

;;; Copyright (c) 2000-2014 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; This file implements an unhygienic version of the (syntax-case ...)
;; and (syntax ...) forms.

;;;----------------------------------------------------------------------------

(include "syntaxpattern.scm") ;; needed by expansion of syntax-case and syntax forms
(include "syntaxtemplate.scm")
(include "syntaxcommon.scm")

;;;----------------------------------------------------------------------------

(##define-syntax define-syntax
  (lambda (src)
    (let ((locat (##source-locat src)))
      (##make-source
       (##cons (##make-source '##define-syntax locat)
               (##cdr (##source-code src)))
       locat))))

;;;----------------------------------------------------------------------------

(##define-syntax syntax-case
  (lambda (src)
    (##include "syntaxcasexform.scm")
    (syn#syntax-case-form-transformer src)))

(##define-syntax syntax
  (lambda (src)
    (##include "syntaxxform.scm")
    (syn#syntax-form-transformer src '())))

;;;----------------------------------------------------------------------------

(##define-syntax syntax-rules
  (lambda (src)
    (##include "syntaxrulesxform.scm")
    (syn#syntax-rules-form-transformer src)))

(define (syn#apply-rules crules src)
  (let loop ((crules crules) (failures '()))
    (if (not (pair? crules))

        (error "syntax error" failures)

        (let* ((crule (car crules))
               (cpattern (vector-ref crule 0))
               (ctemplate (vector-ref crule 1))
               (bindings (syn#match-pattern cpattern src)))
          (if (syn#match-success? bindings)
              (syn#expand-template ctemplate bindings)
              (loop (cdr crules)
                    (cons bindings failures)))))))

;;;============================================================================
