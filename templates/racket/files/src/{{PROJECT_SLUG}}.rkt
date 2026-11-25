#lang racket/base

;; That first line has to be the first line, which is why this comment is below
;; it rather than above. #lang chooses the language the rest of the file is read
;; in -- racket/base is the small one, plain `racket` is the batteries-included
;; one, and typed/racket is a different language again. Racket is a tower of
;; languages rather than one language, and #lang is how you pick.
;;
;; Semicolons are the comment form: two for a comment above a form, one for a
;; trailing one. There is also #| |# for a block and #; which comments out the
;; next whole expression, which is the one worth remembering.

;; provide is the whole of visibility: a definition not provided is private to
;; the module, and a module is a file. There is no in-package form to forget,
;; and (provide (all-defined-out)) is the broad brush to avoid.
(provide greet)

;; define with a list as its first argument is the function form. Written as
;; (define greet (lambda (who) ...)) it means exactly the same thing, which is
;; the clearest sign that a function here is an ordinary value.
(define (greet who)
  ;; format returns a string. ~a prints a value the way a human wants it and ~s
  ;; the way the reader wants it -- ~s would put quotes round the name. printf
  ;; is the same directives written to output instead.
  (format "Hello, ~a!" who))
