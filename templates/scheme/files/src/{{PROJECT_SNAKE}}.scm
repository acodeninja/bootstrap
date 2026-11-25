;;; Three semicolons for a file header, two for a comment above a form, one for
;;; a trailing comment. A convention rather than a rule, and the one every
;;; Scheme file follows.
;;;
;;; define-module is Guile rather than R7RS -- the standard spells this
;;; define-library, and no two implementations agree on much here. The name is a
;;; list, and it maps to the file path below the load path, so this one carries
;;; the project name.
;;;
;;; #:export is the whole of visibility: a definition not in that list is
;;; private to the module.
(define-module ({{PROJECT_SNAKE}})
  #:export (greet))

;;; define binds a name, and this is the function form: the first element of the
;;; list is the name and the rest are the parameters. Writing it as
;;; (define greet (lambda (who) ...)) means exactly the same thing, which is
;;; worth knowing because it shows a function is an ordinary value here.
;;;
;;; There are no type declarations anywhere, and the last expression in the body
;;; is the return value.
(define (greet who)
  ;; string-append takes any number of strings and returns a new one. There is
  ;; no interpolation in the language; `format` exists in Guile and is not
  ;; portable Scheme.
  (string-append "Hello, " who "!"))
