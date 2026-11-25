#lang racket/base

;; module+ declares a submodule and adds to it each time it appears, and the one
;; called `test` is where `raco test` looks. That is the whole discovery story:
;; `make test` runs raco over tests/, raco runs each file's test submodule, and a
;; file with no such submodule is simply skipped -- so a test is found by having
;; one and deleting a test file is safe. Run them with `make test`.
;;
;; The point of putting tests in a submodule rather than at the top level is that
;; requiring this file for any other reason does not run them.
(module+ test
  ;; require is the import form. rackunit is a library by name; the second is a
  ;; path, in quotes, because it is a file of ours -- and the extension is part
  ;; of it, unlike most languages here.
  (require rackunit
           "../src/{{PROJECT_SLUG}}.rkt")

  ;; test-case takes a name and a body. The name is a plain string and can be a
  ;; real sentence, which is what it should be: it is what a failure prints.
  (test-case "a greeting addresses the name it is given"
    ;; define inside a body is a local binding, and it is the same define as at
    ;; the top level -- there is no separate `let` needed for one name.
    (define greeting (greet "world"))

    ;; check-equal? takes actual first and expected second, and the trailing
    ;; question mark is a naming convention for anything that answers a boolean.
    ;; It uses equal?, which compares structurally -- so two strings with the
    ;; same characters match, where eq? would compare identity and fail.
    (check-equal? greeting "Hello, world!")))
