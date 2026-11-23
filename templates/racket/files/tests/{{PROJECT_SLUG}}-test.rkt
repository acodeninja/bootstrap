#lang racket/base

(module+ test
  (require rackunit
           "../src/{{PROJECT_SLUG}}.rkt")

  (test-case "a greeting addresses the name it is given"
    (define greeting (greet "world"))

    (check-equal? greeting "Hello, world!")))
