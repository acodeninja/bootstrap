(defpackage #:{{PROJECT_SLUG}}
  (:use #:cl)
  (:export #:greet))

(in-package #:{{PROJECT_SLUG}})

(defun greet (who)
  (format nil "Hello, ~a!" who))
