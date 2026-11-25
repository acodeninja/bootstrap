;; The same path-to-namespace correspondence as the greeter: underscores in the
;; directory, hyphens in the name.
;;
;; :require is the import form, and the two shapes here do different jobs.
;; :refer pulls named vars into this namespace so `deftest` and `is` can be
;; written bare; :as makes an alias, so the greeter is reached as greeter/greet.
;; Preferring :as is the habit worth having -- it keeps the origin of a name
;; visible at the call site.
(ns {{PROJECT_SLUG}}.greeter-test
  (:require [clojure.test :refer [deftest is]]
            [{{PROJECT_SLUG}}.greeter :as greeter]))

;; Nothing names this file. clojure.test has no discovering command, so this
;; project runs a small harness that reads the `ns` form out of every file under
;; test/ and runs it -- which means the ns form above is the registration, and
;; deleting a test file is safe. Run the suite with `make test`.
;;
;; deftest defines a var holding the test, so the name is a symbol: hyphens
;; stand in for spaces, because a symbol cannot contain them. It is what a
;; failure prints.
(deftest a-greeting-addresses-the-name-it-is-given
  ;; let takes a vector of binding pairs -- name, value, name, value -- rather
  ;; than a list of lists. The bindings are immutable and visible only in the
  ;; body.
  (let [greeting (greeter/greet "world")]

    ;; `is` is a macro over an ordinary expression, so a failure prints the form
    ;; it was handed along with both values -- which is why there is no
    ;; assert-equal to learn.
    ;;
    ;; = compares by value and works across types, so there is no equals method
    ;; to remember and no identity comparison to get wrong.
    (is (= "Hello, world!" greeting))))
