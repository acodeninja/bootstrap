;;; use-modules imports, and it takes a list of module names -- SRFI-64 is the
;;; standard testing library, and the second is the module under test. Both are
;;; lists rather than strings, because a module name is a list of symbols.
(use-modules (srfi srfi-64)
             ({{PROJECT_SNAKE}}))

;;; Nothing names this file: `make test` loads every tests/*.scm and SRFI-64
;;; collects what it finds, so a test file is found by existing and deleting one
;;; is safe. Run them with `make test`.
;;;
;;; test-begin opens a named group and test-end closes it, and the two names have
;;; to match -- a mismatch is a runtime error rather than a parse error, so it
;;; surfaces as a confusing failure rather than as a syntax complaint.
(test-begin "{{PROJECT_SLUG}}")

;;; test-equal takes the test name, then the expected value, then the expression
;;; that should produce it. Expected before actual, which is the order most of
;;; SRFI-64 uses.
;;;
;;; The name is a plain string and can be a real sentence, which is what it
;;; should be: it is what a failure prints.
(test-equal "a greeting addresses the name it is given"
  "Hello, world!"
  (greet "world"))

;;; test-end also decides the exit status: SRFI-64 counts the failures and the
;;; runner reads that, which is why a file without this line reports nothing.
(test-end "{{PROJECT_SLUG}}")
