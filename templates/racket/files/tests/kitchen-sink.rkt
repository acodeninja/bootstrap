#lang racket/base
;; Fifteen passing tests: the toolbox for solving a kata in Racket.

(module+ test
  (require racket/list
           racket/set
           racket/string
           rackunit)

  ;; collections

  (test-case "a list keeps what you put in it in order"
    (define items (list "a" "b"))
    (define grown (append items (list "c")))

    (check-equal? grown '("a" "b" "c"))
    (check-equal? (length grown) 3)
    (check-equal? (list-ref grown 1) "b")
    (check-equal? (drop grown 1) '("b" "c")))

  (test-case "a hash lookup for a key that is not there needs a default of its own"
    (define counts (hash "a" 2 "b" 1))

    (check-equal? (hash-ref counts "a") 2)
    (check-equal? (hash-ref counts "z" 0) 0)
    (check-exn exn:fail:contract? (lambda () (hash-ref counts "z"))))

  (test-case "a set discards duplicates and answers membership"
    (define letters (set "a" "b"))
    (define grown (set-add letters "a"))

    (check-equal? (set-count grown) 2)
    (check-true (set-member? grown "a"))
    (check-false (set-member? grown "z")))

  ;; strings

  (test-case "a string splits into parts and joins back up"
    (define words (string-split "one two three"))

    (check-equal? words '("one" "two" "three"))
    (check-equal? (string-join words "-") "one-two-three"))

  (test-case "a substring counts from zero and a character is not a string"
    (define text "abcdef")

    (check-equal? (string-ref text 0) #\a)
    (check-equal? (substring text 0 3) "abc")
    (check-equal? (substring text 4) "ef"))

  (test-case "text is assembled by format and trimmed by string-trim"
    (check-equal? (format "~a x~a" "world" 2) "world x2")
    (check-equal? (apply string-append (make-list 3 "ab")) "ababab")
    (check-equal? (string-trim "  padded  ") "padded"))

  ;; types and branching

  (test-case "a transparent struct compares by value and is copied one field at a time"
    (struct point (x y) #:transparent)
    (define origin (point 1 2))
    (define moved (struct-copy point origin [x 5]))

    (check-equal? moved (point 5 2))
    (check-equal? origin (point 1 2))
    (check-equal? (point-x moved) 5))

  (test-case "a case over symbols needs an else clause of its own"
    ;; Symbols are the fixed set of named states, and nothing checks that a
    ;; case covered them all -- without the else this answers void instead.
    (define (next-state state)
      (case state
        [(locked) 'open]
        [(open) 'locked]
        [else 'unknown]))

    (check-equal? (next-state 'locked) 'open)
    (check-equal? (next-state 'open) 'locked)
    (check-equal? (next-state 'broken) 'unknown))

  (test-case "a cond produces a value instead of setting one"
    (define (describe n)
      (cond
        [(negative? n) "negative"]
        [(zero? n) "zero"]
        [else "positive"]))

    (check-equal? (describe -1) "negative")
    (check-equal? (describe 0) "zero")
    (check-equal? (describe 1) "positive"))

  ;; iteration

  (test-case "a walk can read both the position and the item"
    (define items '("a" "b"))

    (check-equal? (for/list ([(item index) (in-indexed items)])
                    (format "~a:~a" index item))
                  '("0:a" "1:b"))
    (check-equal? (for/first ([(item index) (in-indexed items)]
                              #:when (equal? item "b"))
                    index)
                  1))

  (test-case "two sequences walked side by side stop at the shorter one"
    (define numbers '(1 2 3 4))

    (check-equal? (for/list ([a numbers] [b (cdr numbers)]) (list a b))
                  '((1 2) (2 3) (3 4)))
    (check-equal? (for/list ([a numbers] [b (cdr numbers)]) (+ a b))
                  '(3 5 7)))

  ;; functions

  (test-case "a function can be handed to another function"
    (define (twice n) (* 2 n))

    (check-equal? (map twice '(1 2 3)) '(2 4 6))
    (check-equal? (filter (lambda (n) (> n 1)) '(1 2 3)) '(2 3)))

  (test-case "a list is folded down to one value by for/fold"
    (check-equal? (for/fold ([total 0]) ([n '(1 2 3 4)]) (+ total n))
                  10)
    (check-equal? (for/fold ([counts (hash)]) ([n '(1 1 2)])
                    (hash-update counts n add1 0))
                  (hash 1 2 2 1)))

  ;; errors

  (test-case "an invalid input is refused rather than guessed at"
    (define (parse-percentage input)
      (define value (string->number input))
      (unless (and (exact-integer? value) (<= 0 value 100))
        (raise-argument-error 'parse-percentage
                              "a whole number from 0 to 100"
                              input))
      value)

    (check-equal? (parse-percentage "40") 40)
    (check-exn #rx"parse-percentage" (lambda () (parse-percentage "half")))
    (check-equal? (with-handlers ([exn:fail:contract? (lambda (failure) 'refused)])
                    (parse-percentage "140"))
                  'refused))

  ;; gotchas

  (test-case "dividing two integers gives an exact fraction rather than a decimal"
    (check-equal? (/ 10 4) 5/2)
    (check-equal? (/ 10.0 4) 2.5)
    (check-equal? (+ 1/10 2/10) 3/10)
    (check-false (= (+ 0.1 0.2) 0.3))))
