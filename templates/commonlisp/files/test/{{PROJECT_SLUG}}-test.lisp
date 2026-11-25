;;;; The test package. It uses both the standard library and FiveAM, which is
;;;; what makes `test` and `is` below available unqualified. It exports nothing,
;;;; because nothing imports a test.

(defpackage #:{{PROJECT_SLUG}}-test
  (:use #:cl #:fiveam))

(in-package #:{{PROJECT_SLUG}}-test)

;;; Nothing names this file. The .asd file lists the test system and `make test`
;;; loads it and runs every test FiveAM has registered -- so a test is found by
;;; being defined, and deleting one is safe. Run them with `make test`.
;;;
;;; `test` is a macro, and the name it takes is a symbol rather than a string:
;;; hyphens stand in for spaces, because a symbol with spaces in it would need
;;; |vertical bars| round it. It is what a failure prints.
(test a-greeting-addresses-the-name-it-is-given
  ;; `let` binds for the duration of its body, and the double parentheses are
  ;; not a typo: the first opens the list of bindings and the second opens this
  ;; binding, because `let` can introduce several at once.
  ;;
  ;; A single colon reaches an exported symbol; a double colon would reach one
  ;; that is not exported.
  (let ((greeting ({{PROJECT_SLUG}}:greet "world")))

    ;; `is` is a macro over an ordinary expression, so a failure prints the form
    ;; it was handed as well as the values -- which is why there is no
    ;; assert-equal here and no expected-first order to remember.
    ;;
    ;; string= rather than eql or equal: eql compares identity, so two strings
    ;; with the same characters are not eql, and that is the default test for a
    ;; hash table too. Comparing text means saying which comparison you mean.
    (is (string= "Hello, world!" greeting))))
