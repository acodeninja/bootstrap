#lang racket/base

(provide greet)

(define (greet who)
  (format "Hello, ~a!" who))
