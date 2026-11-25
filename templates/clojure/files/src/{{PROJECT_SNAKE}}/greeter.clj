;;;; Four semicolons for a file header, two for a comment above a form, one for
;;;; a trailing comment. A convention rather than a rule, and cljfmt indents by
;;;; it -- there is also #_ to comment out the next form, and (comment ...) for
;;;; a block, both of which are more useful than they look.

;; An `ns` form declares the namespace, and it has to be the first form in the
;; file. The namespace name and the file path have to correspond: dots become
;; directories and hyphens become underscores, which is why this file is at
;; src/<project-with-underscores>/greeter.clj while the namespace below uses
;; hyphens. Get that wrong and the namespace is simply not found.
;;
;; Nothing is exported. Every var in a namespace is public unless defined with
;; defn- , and that trailing hyphen is the whole of visibility.
(ns {{PROJECT_SLUG}}.greeter)

;; defn defines a function: name, then the parameter vector in square brackets,
;; then the body. The vector is not decoration -- a function can have several
;; of them, one per arity, which is how Clojure does overloading.
;;
;; No type declarations, and the last expression in the body is the value.
(defn greet
  [who]
  ;; str concatenates anything, calling toString on each argument, and it is
  ;; what you reach for rather than an interpolation syntax -- there is none.
  ;; format exists and takes a Java format string, which is rarely worth it.
  (str "Hello, " who "!"))
