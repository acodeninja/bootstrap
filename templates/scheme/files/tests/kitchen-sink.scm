;;;; Fifteen passing tests: the toolbox for solving a kata in Guile Scheme.

(use-modules (ice-9 format)
             (srfi srfi-1)
             (srfi srfi-9)
             (srfi srfi-64))

(test-begin "kitchen-sink")

;;; collections

(test-equal "consing onto a list leaves the list it was handed alone"
  '(("a" "b" "c") ("b" "c"))
  (let ((items (list "b" "c")))
    (list (cons "a" items) items)))

(test-equal "hash-ref answers with the default it was handed when the key is absent"
  '(2 0)
  (let ((counts (make-hash-table)))
    (hash-set! counts "a" 2)
    (list (hash-ref counts "a" 0)
          (hash-ref counts "z" 0))))

(test-equal "a set is a list plus the srfi-1 procedures that treat one as a set"
  '(("c" "a" "b") ("a" "b"))
  (let ((letters '("a" "b")))
    (list (lset-adjoin string=? letters "c")
          (lset-adjoin string=? letters "a"))))

;;; strings

(test-equal "string-split cuts on a character and string-join puts it back"
  '(("one" "two" "three") "one-two-three")
  (let ((words (string-split "one two three" #\space)))
    (list words (string-join words "-"))))

(test-equal "substring counts from zero and stops before the index it ends on"
  '("abc" #\a "ef")
  (let ((text "abcdef"))
    (list (substring text 0 3)
          (string-ref text 0)
          (substring text (- (string-length text) 2)))))

(test-equal "format returns the string rather than printing it when the port is #f"
  '("world x2" "padded")
  (list (format #f "~a x~a" "world" 2)
        (string-trim-both "  padded  ")))

;;; types and branching

(define-record-type <point>
  (make-point x y)
  point?
  (x point-x)
  (y point-y))

(test-equal "a record is reached through the accessors define-record-type names"
  '(1 2 #t)
  (let ((origin (make-point 1 2)))
    (list (point-x origin) (point-y origin) (point? origin))))

(test-equal "case compares with eqv? and needs an else because nothing checks the keys"
  '(open locked unknown)
  (map (lambda (state)
         (case state
           ((locked) 'open)
           ((open) 'locked)
           (else 'unknown)))
       '(locked open broken)))

(test-equal "cond with => hands the branch the value its test produced"
  '("found 2" "absent")
  (let ((counts (make-hash-table)))
    (hash-set! counts "a" 2)
    (map (lambda (key)
           (cond ((hash-ref counts key) => (lambda (count) (format #f "found ~a" count)))
                 (else "absent")))
         '("a" "z"))))

;;; iteration

(test-equal "do steps every variable at once and yields the expression beside its test"
  '("0:a" "1:b")
  (do ((items '("a" "b") (cdr items))
       (index 0 (+ index 1))
       (out '() (cons (format #f "~a:~a" index (car items)) out)))
      ((null? items) (reverse out))))

(test-equal "walking a list by its tails puts the next item within reach"
  '(3 5 7)
  (let walk ((values '(1 2 3 4)) (out '()))
    (if (null? (cdr values))
        (reverse out)
        (walk (cdr values) (cons (+ (car values) (cadr values)) out)))))

;;; functions

(test-equal "a procedure is a value, so map and filter take one by name"
  '((2 4 6) (2 3))
  (list (map (lambda (n) (* 2 n)) '(1 2 3))
        (filter (lambda (n) (> n 1)) '(1 2 3))))

(test-equal "fold hands its procedure the item first and the accumulator second"
  '(10 (4 3 2 1))
  (list (fold + 0 '(1 2 3 4))
        (fold cons '() '(1 2 3 4))))

;;; errors

(define (parse-percentage text)
  (let ((value (string->number text)))
    (if (and value (<= 0 value 100))
        value
        (throw 'not-a-percentage text))))

(test-equal "catch receives the key it asked for and everything thrown beside it"
  '(40 (not-a-percentage "140"))
  (list (parse-percentage "40")
        (catch 'not-a-percentage
          (lambda () (parse-percentage "140"))
          (lambda (key text) (list key text)))))

;;; gotchas

(test-equal "#f is the only false value, so zero and the empty list are both true"
  '(then then else)
  (map (lambda (value) (if value 'then 'else))
       (list 0 '() #f)))

(test-end "kitchen-sink")
