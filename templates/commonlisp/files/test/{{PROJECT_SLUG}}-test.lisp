(defpackage #:{{PROJECT_SLUG}}-test
  (:use #:cl #:fiveam))

(in-package #:{{PROJECT_SLUG}}-test)

(test a-greeting-addresses-the-name-it-is-given
  (let ((greeting ({{PROJECT_SLUG}}:greet "world")))

    (is (string= "Hello, world!" greeting))))
