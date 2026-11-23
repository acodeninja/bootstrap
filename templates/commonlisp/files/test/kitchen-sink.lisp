;;;; Fifteen passing tests: the toolbox for solving a kata in Common Lisp.

(defpackage #:kitchen-sink
  (:use #:cl #:fiveam))

(in-package #:kitchen-sink)

;;; collections

(test a-list-is-built-at-the-front-and-read-from-there
  (let* ((items (list "b" "c"))
         (grown (cons "a" items)))

    (is (equal '("a" "b" "c") grown))
    (is (= 3 (length grown)))
    (is (equal '("b" "c") (rest grown)))))

(test a-hash-table-lookup-reports-whether-the-key-was-there
  (let ((counts (make-hash-table :test #'equal)))
    (setf (gethash "a" counts) 2)

    (is (= 2 (gethash "a" counts)))
    (multiple-value-bind (value present) (gethash "z" counts)
      (is (null value))
      (is (not present)))))

(test a-set-is-a-list-plus-the-functions-that-treat-one-as-a-set
  (let ((letters (list "b" "a")))

    (is (equal '("b" "a") (adjoin "a" letters :test #'equal)))
    (is (equal '("c" "b" "a") (adjoin "c" letters :test #'equal)))
    (is (member "a" letters :test #'equal))))

;;; strings

(test the-standard-has-no-split-so-position-and-subseq-do-the-work
  (let ((text "one two three")
        (words '()))
    (loop with start = 0
          for space = (position #\Space text :start start)
          do (push (subseq text start space) words)
             (if space (setf start (1+ space)) (return)))
    (setf words (nreverse words))

    (is (equal '("one" "two" "three") words))
    (is (string= "one-two-three" (format nil "~{~a~^-~}" words)))))

(test a-string-is-a-vector-so-the-sequence-functions-work-on-it
  (let ((text "abcdef"))

    (is (char= #\a (char text 0)))
    (is (string= "abc" (subseq text 0 3)))
    (is (string= "ef" (subseq text (- (length text) 2))))))

(test format-lays-text-out-and-string-trim-takes-the-edges-off
  (let ((label "world")
        (times 2))

    (is (string= "world x2" (format nil "~a x~d" label times)))
    (is (string= "ababab" (format nil "~{~a~}" (make-list 3 :initial-element "ab"))))
    (is (string= "padded" (string-trim " " "  padded  ")))))

;;; types and branching

(defstruct point x y)

(test a-defstruct-record-is-mutable-so-a-copy-is-made-on-purpose
  (let* ((origin (make-point :x 1 :y 2))
         (moved (copy-point origin)))
    (setf (point-x moved) 5)

    (is (= 5 (point-x moved)))
    (is (= 1 (point-x origin)))
    (is (point-p moved))))

(defgeneric measure (value))

(defmethod measure ((value point))
  (+ (point-x value) (point-y value)))

(defmethod measure ((value string))
  (length value))

(defmethod measure ((value integer))
  value)

(test a-generic-function-picks-its-method-from-the-class-of-the-argument
  (is (= 3 (measure (make-point :x 1 :y 2))))
  (is (= 2 (measure "ab")))
  (is (= 7 (measure 7))))

(test a-case-over-keywords-needs-a-fallback-because-nothing-checks-the-keys
  (flet ((next-state (state)
           (case state
             (:locked :open)
             (:open :locked)
             (t :unknown))))

    (is (eq :open (next-state :locked)))
    (is (eq :locked (next-state :open)))
    (is (eq :unknown (next-state :broken)))))

;;; iteration

(test loop-reads-the-position-and-the-item-in-the-same-pass
  (let ((items '("a" "b")))

    (is (equal '("0:a" "1:b")
               (loop for item in items
                     for index from 0
                     collect (format nil "~d:~a" index item))))
    (is (equal '(1)
               (loop for item in items
                     for index from 0
                     when (string= "b" item) collect index)))))

(test loop-on-walks-a-list-by-its-tails-so-the-next-item-is-in-reach
  (let ((values '(1 2 3 4)))

    (is (equal '((1 2) (2 3) (3 4))
               (loop for (a b) on values while b collect (list a b))))
    (is (equal '(3 5 7)
               (loop for (a b) on values while b collect (+ a b))))))

;;; functions

(test a-function-becomes-a-value-only-once-sharp-quote-has-fetched-it
  (flet ((twice (n) (* 2 n)))

    (is (equal '(2 4 6) (mapcar #'twice '(1 2 3))))
    (is (equal '(2 3) (remove-if-not (lambda (n) (> n 1)) '(1 2 3))))))

(test reduce-folds-a-sequence-down-to-one-value
  (let ((values '(1 2 3 4)))

    (is (= 10 (reduce #'+ values)))
    (is (equal '(4 3 2 1)
               (reduce (lambda (accumulated value) (cons value accumulated))
                       values
                       :initial-value '())))))

;;; errors

(define-condition invalid-percentage (error)
  ((input :initarg :input :reader invalid-percentage-input))
  (:report (lambda (problem stream)
             (format stream "not a percentage: ~a"
                     (invalid-percentage-input problem)))))

(defun parse-percentage (input)
  (let ((value (parse-integer input :junk-allowed t)))
    (unless (and value (<= 0 value 100))
      (error 'invalid-percentage :input input))
    value))

(test an-input-that-cannot-be-read-signals-a-condition-rather-than-guessing
  (is (= 40 (parse-percentage "40")))

  (signals invalid-percentage (parse-percentage "140"))
  (is (string= "half" (handler-case (parse-percentage "half")
                        (invalid-percentage (problem)
                          (invalid-percentage-input problem))))))

;;; gotchas

(test two-equal-strings-are-not-eql-which-is-the-default-hash-table-test
  (let ((by-eql (make-hash-table))
        (by-equal (make-hash-table :test #'equal)))
    (setf (gethash (copy-seq "a") by-eql) 1
          (gethash (copy-seq "a") by-equal) 1)

    (is (not (eql (copy-seq "a") (copy-seq "a"))))
    (is (null (gethash "a" by-eql)))
    (is (= 1 (gethash "a" by-equal)))))
