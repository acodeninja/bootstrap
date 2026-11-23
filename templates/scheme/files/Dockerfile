# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim

# Guile has no Docker Official Image and the GNU project publishes none, so the
# datestamped Debian base is the pin. One package is the whole toolchain:
# guile-3.0 carries 3.0.10 and its entire module tree, SRFI-64 at
# /usr/share/guile/3.0/srfi/srfi-64.scm included, so there is no test framework
# to add and no language-level dependency manager to lock. guile-3.0-dev, which
# is where Debian puts guild, is deliberately absent -- the compiler is reachable
# as the (system base compile) module, which ships in the runtime package.
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends guile-3.0 \
    && rm -rf /var/lib/apt/lists/*

# Guile compiles every file it loads and caches the .go under
# $XDG_CACHE_HOME/guile/ccache, falling back to $HOME/.cache. Both default into
# a home directory the service's uid cannot write, where the cache is dropped
# silently and every run recompiles; these point them at the named volume.
ENV XDG_CACHE_HOME=/cache
ENV HOME=/cache/home
# So a suite can say (use-modules ({{PROJECT_SNAKE}})) without naming a path.
ENV GUILE_LOAD_PATH=/work/src

# A module rather than a file the helpers load: a load at the top of a script is
# invisible to the compiler, which then warns about every name it provides.
# /usr/share/guile/site/3.0 is on the default load path, and GUILE_LOAD_PATH
# above prepends to it rather than replacing it.
COPY <<'SCHEME' /usr/share/guile/site/3.0/bootstrap/suite.scm
(define-module (bootstrap suite)
  #:use-module (ice-9 ftw)
  #:export (scheme-files))

;; scandir answers #f for a directory that is not there, and sorts what it finds.
(define (scheme-files directory)
  (map (lambda (name) (string-append directory "/" name))
       (or (scandir directory (lambda (name) (string-suffix? ".scm" name)))
           '())))
SCHEME

# SRFI-64 reports failures and returns; test-end prints the tally and the process
# exits 0 whatever it said, so the exit status has to be built here. A runner
# factory hands out the counters: every test-begin asks for a runner, this keeps
# the one it made, and the counts survive test-end because nothing resets them.
#
# Loading each file in a fresh module is what lets two suites define the same
# name, and what keeps the helper's own bindings out of their reach.
#
# test-log-to-file defaults to #t, which opens <suite-name>.log in the working
# directory -- here the bind-mounted project, which a test run must leave clean.
COPY --chmod=0755 <<'SCHEME' /usr/local/bin/guile-test
#!/usr/bin/guile -s
!#
(define-module (bootstrap run)
  ;; load mutates the module it is called in, which a declarative one forbids.
  #:declarative? #f
  #:use-module (bootstrap suite)
  #:use-module (srfi srfi-64))

(module-set! (resolve-module '(srfi srfi-64)) 'test-log-to-file #f)

(define runners '())

(test-runner-factory
 (lambda ()
   (let ((runner (test-runner-simple)))
     (set! runners (cons runner runners))
     runner)))

(define (failures runner)
  (+ (test-runner-fail-count runner)
     (test-runner-xpass-count runner)))

(define (run file)
  (save-module-excursion
   (lambda ()
     (set-current-module (make-fresh-user-module))
     (load (string-append (getcwd) "/" file)))))

(let ((suites (scheme-files "tests")))
  (if (null? suites)
      (display "no tests found under tests/\n")
      (for-each run suites))
  (exit (if (zero? (apply + (map failures runners))) 0 1)))
SCHEME

# Guile publishes no linter, so the compiler is the check -- and compile-file
# reports an unbound variable, a call of the wrong arity and a malformed format
# string without failing, so a warning only becomes a failure by reading the
# port it was written to.
#
# The warnings are listed rather than taken from a level: -W3 adds
# unused-variable, which fires fifteen times on SRFI-64's own expansion of
# test-equal and would make the suite unlintable.
#
# Compiling a suite does not run it: test-equal expands to a call, and a call is
# emitted rather than evaluated.
COPY --chmod=0755 <<'SCHEME' /usr/local/bin/guile-lint
#!/usr/bin/guile \
--no-auto-compile -s
!#
(use-modules (bootstrap suite)
             (system base compile))

(define warnings
  '(unbound-variable
    macro-use-before-definition
    use-before-definition
    arity-mismatch
    duplicate-case-datum
    bad-case-datum
    format
    unsupported-warning))

(define (complaints file)
  (let ((port (open-output-string)))
    (parameterize ((current-warning-port port))
      (compile-file file
                    #:output-file "/cache/lint/compiled.go"
                    #:opts (list #:warnings warnings)))
    (get-output-string port)))

(let ((quiet #t))
  (for-each (lambda (file)
              (format #t "== ~a~%" file)
              (force-output)
              (let ((said (complaints file)))
                (unless (string-null? said)
                  (set! quiet #f)
                  (display said (current-error-port)))))
            (append (scheme-files "src") (scheme-files "tests")))
  (exit (if quiet 0 1)))
SCHEME

COPY --chmod=0755 <<'SCHEME' /usr/local/bin/guile-build
#!/usr/bin/guile \
--no-auto-compile -s
!#
(use-modules (bootstrap suite)
             (system base compile))

(for-each (lambda (file)
            (format #t "~a~%" (compile-file file)))
          (scheme-files "src"))
SCHEME

# Compiling the helpers here seeds the named volume from the image, so the first
# run of each compiles the project and nothing else. Guile decides a .go is
# current by comparing mtimes, which the image preserves.
#
# /cache is world-writable so the service runs as any host uid without a passwd
# entry or a writable $HOME. See docs/containers.md "File ownership". The chmod
# shares this layer deliberately: run separately it rewrites the mode of every
# .go just compiled, and overlayfs then copies all of it again.
RUN mkdir -p /cache/home /cache/lint \
    && guile --no-auto-compile -c '(use-modules (system base compile)) (for-each compile-file (list "/usr/share/guile/site/3.0/bootstrap/suite.scm" "/usr/local/bin/guile-test"))' \
    && chmod -R 777 /cache

WORKDIR /work
