(use-modules (srfi srfi-64)
             ({{PROJECT_SNAKE}}))

(test-begin "{{PROJECT_SLUG}}")

(test-equal "a greeting addresses the name it is given"
  "Hello, world!"
  (greet "world"))

(test-end "{{PROJECT_SLUG}}")
