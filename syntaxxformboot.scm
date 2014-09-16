;;;============================================================================

;;; File: "syntaxxformboot.scm"

;;; Copyright (c) 2000-2014 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; This file implements a version of the (syntax ...) form that is
;; used for bootstrapping.

;;;----------------------------------------------------------------------------

(define (syn#syntax-form-transformer src inherited-pvars)

  (include "syntaxtemplate.scm") ;; get definition of syn#compile-template
  (include "syntaxcommon.scm") ;; get definition of syn#pvar-id

  (let ((code (##source-code src)))
    (if (and (= (length code) 4)
             (eq? (##source-code (##sourcify (cadr code) src))
                  '##let-pattern-variables))

        (let* ((pvars
                (##desourcify (caddr code)))
               (expr
                (cadddr code))
               (n
                (length pvars))
               (new-pvars
                (append pvars
                        (map (lambda (x)
                               (let* ((id (car x))
                                      (index (cadr x))
                                      (rank (cddr x)))
                                 (cons id
                                       (cons (+ index n) rank))))
                             inherited-pvars))))
          `(##let ()

             (##define-syntax syntax
               (##lambda (##src)
                 (##include "syntaxxformboot.scm")
                 (syn#syntax-form-transformer ##src ',new-pvars)))

             ,expr))

        (let* ((template
                (cadr code))
               (ctemplate
                (syn#compile-template
                 (##sourcify template src)
                 inherited-pvars)))
          `(syn#expand-template
            ',ctemplate
            (##vector ,@(map syn#pvar-id inherited-pvars)))))))

;;;============================================================================
