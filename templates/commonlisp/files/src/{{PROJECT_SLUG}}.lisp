;;;; Four semicolons for a file header, three for a section, two for a comment
;;;; above a form and one for a trailing comment. Nothing enforces that -- it is
;;;; the convention every Lisp file follows, and editors indent by it.

;;; A package is the unit of naming, and it is separate from the file: this file
;;; is named after the project and so is the package, but nothing requires that
;;; and a package may span many files.
;;;
;;; #: makes an uninterned symbol -- a name that is not added to the current
;;; package just by being mentioned here, which is the careful way to write a
;;; package definition.
;;;
;;; :use brings in another package wholesale; #:cl is the standard library, and
;;; leaving it out would mean no defun and no format. :export is the whole of
;;; visibility -- a symbol not in that list is still reachable, with a double
;;; colon rather than a single one, which is the convention for "you are
;;; reaching inside".
(defpackage #:{{PROJECT_SLUG}}
  (:use #:cl)
  (:export #:greet))

;;; Everything after this form is read into that package. It is a statement
;;; about the reader rather than a block, so there is nothing to close -- and
;;; forgetting it puts your definitions somewhere else entirely.
(in-package #:{{PROJECT_SLUG}})

;;; defun defines a function. The parameter list is a list, there are no type
;;; declarations, and the last expression in the body is the return value.
(defun greet (who)
  ;; format with nil as its first argument returns a string; with t it writes
  ;; to standard output, and with a stream it writes there. One function, three
  ;; jobs, chosen by that argument.
  ;;
  ;; ~a is the directive for "print this the way a human wants it" and ~s is
  ;; the machine-readable one -- ~s would put quotes round the name.
  (format nil "Hello, ~a!" who))
