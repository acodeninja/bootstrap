# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim

# SBCL has no Docker Official Image. clfoundation/sbcl is a credible vendor one
# -- multi-arch, current, no Quicklisp baked in -- and is deliberately not used:
# it publishes no datestamped tag, so the Debian packages installed on top of it
# would move under the tag that does exist. FiveAM and its three dependencies
# are Debian packages, so the datestamped base is the pin for all five at once.
# This is the trade the r template makes for the same reason.
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         cl-fiveam \
         sbcl \
    && rm -rf /var/lib/apt/lists/*

# compile-file writes the .fasl beside the source unless something says
# otherwise, which would leave the bind-mounted project dirty after every run.
# One translation sends every compiled output under /cache instead.
ENV ASDF_OUTPUT_TRANSLATIONS=/:/cache/fasl/
# Debian ships its Common Lisp libraries as sources under /usr/share, and
# nothing in SBCL's own ASDF looks there.
ENV CL_SOURCE_REGISTRY=/work/:/cache/suite/:/usr/share/common-lisp/source//
ENV HOME=/cache/home

# ASDF wants a system's components listed, and listing the test files in the
# project's own .asd would name the kitchen sink -- which is meant to be
# deleted. Writing a system definition from whatever test/ holds is what keeps
# that promise.
#
# The set is recomputed every run, because deleting a file changes it without
# touching a survivor. The file is only replaced when the bytes differ: ASDF
# counts a component stale whenever its system definition is newer than its
# fasl, so writing it unconditionally would recompile the suite every time.
COPY <<'LISP' /usr/local/lib/bootstrap-suite.lisp
(require :asdf)

(defpackage #:bootstrap-suite
  (:use #:cl)
  (:export #:project-system #:test-system))

(in-package #:bootstrap-suite)

(defun project-system ()
  (let ((definitions (directory "/work/*.asd")))
    (unless definitions
      (error "no system definition: /work holds no .asd file"))
    (pathname-name (first definitions))))

(defun test-system ()
  (let* ((definition #p"/cache/suite/project-tests.asd")
         (files (sort (directory "/work/test/*.lisp") #'string<
                      :key #'pathname-name))
         (wanted (with-output-to-string (stream)
                   (write `(asdf:defsystem "project-tests"
                             :depends-on ("fiveam" ,(project-system))
                             :pathname "/work/test/"
                             :components ,(mapcar (lambda (file)
                                                    (list :file (pathname-name file)))
                                                  files))
                          :stream stream :escape t :case :downcase)
                   (terpri stream))))
    (ensure-directories-exist definition)
    (unless (and (probe-file definition)
                 (string= wanted (uiop:read-file-string definition)))
      (with-open-file (stream definition :direction :output :if-exists :supersede)
        (write-string wanted stream)))
    (asdf:clear-source-registry))
  "project-tests")
LISP

# run-all-tests walks the suites FiveAM knows about rather than any list of
# them, and answers T for a project with no tests at all.
COPY --chmod=0755 <<'LISP' /usr/local/bin/sbcl-test
#!/usr/bin/sbcl --script
(load "/usr/local/lib/bootstrap-suite.lisp")

(asdf:load-system (bootstrap-suite:test-system))

(sb-ext:exit :code (if (5am:run-all-tests) 0 1))
LISP

# SBCL publishes no linter, so the compiler is the check: an undefined
# variable, an argument of the wrong type, a call with the wrong number of them
# and a binding nothing reads are all conditions it signals while compiling,
# and catching them is what turns them into a failure. ASDF's
# *compile-file-warnings-behaviour* is not enough on its own: SBCL keeps style
# warnings out of compile-file's warnings-p, so an unused binding would pass.
#
# :force is the other half. A fasl that is already up to date is loaded in
# silence, so without it a second run would pass whatever it was handed.
# FiveAM is loaded first because somebody else's warnings are not this
# project's lint.
COPY --chmod=0755 <<'LISP' /usr/local/bin/sbcl-lint
#!/usr/bin/sbcl --script
(load "/usr/local/lib/bootstrap-suite.lisp")
(asdf:load-system "fiveam")

(let ((problems '())
      (tests (bootstrap-suite:test-system))
      (project (bootstrap-suite:project-system)))
  (handler-case
      (handler-bind ((warning (lambda (problem) (push problem problems))))
        (asdf:load-system tests :force (list tests project)))
    (error (problem)
      (format *error-output* "~&~a~%" problem)
      (sb-ext:exit :code 1)))
  (when problems
    (dolist (problem (reverse problems))
      (format *error-output* "~&~a~%" problem))
    (sb-ext:exit :code 1)))

(format t "~&no compiler warnings~%")
LISP

COPY --chmod=0755 <<'LISP' /usr/local/bin/sbcl-build
#!/usr/bin/sbcl --script
(load "/usr/local/lib/bootstrap-suite.lisp")

(asdf:compile-system (bootstrap-suite:project-system))
LISP

# A cold run otherwise compiles FiveAM and its dependencies before reaching a
# line of test code. Compiling them here seeds the named volume from the image,
# and these fasls travel where zig's build runner cannot: they are keyed on the
# SBCL in this image, not on the machine that built them.
#
# /cache is world-writable so the service runs as any host uid without a passwd
# entry or a writable $HOME. See docs/containers.md "File ownership". The chmod
# shares this layer deliberately: run separately it rewrites the mode of every
# fasl just compiled, and overlayfs then copies all of it again.
RUN mkdir -p /cache/fasl /cache/home /cache/suite \
    && sbcl --non-interactive \
         --eval '(require :asdf)' \
         --eval '(asdf:load-system "fiveam")' \
    && chmod -R 777 /cache

WORKDIR /work
