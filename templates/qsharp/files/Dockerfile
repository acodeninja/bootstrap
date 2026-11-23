# syntax=docker/dockerfile:1
FROM python:3.15.2-slim-trixie

# pip installs by package name, which carries no URL, so the upstream is named
# here instead. pins.yml finds it by grepping for the variable and reading the
# link off the same line, so those two have to stay together:
# ${QDK_VERSION} is at https://github.com/microsoft/qsharp/releases/tag/v${QDK_VERSION}
ARG QDK_VERSION=1.34.0

# qdk/telemetry.py starts a thread on import that posts a metric to an Azure
# Monitor endpoint, and an atexit handler that flushes it. Both are on unless
# one of two environment variables says otherwise, so a template without this
# line phones home on every make test.
ENV QDK_PYTHON_TELEMETRY=none

ENV HOME=/cache/home

RUN pip install --no-cache-dir "qdk==${QDK_VERSION}"

# The released QDK publishes no test runner: qsc lives in Microsoft's own repo
# and never ships in the wheel, so the suite is driven from Python. It belongs
# here rather than in the project, which stays Q# only.
#
# qsharp.json may enumerate files but not directories, so tests/ cannot join
# the project without the manifest naming the suite -- the one thing the
# contract forbids. The project compiles src/, each test source is evaluated
# into the same context, and run_tests then finds the @Test callables by the
# attribute rather than by any name. An empty tests/ is nought tests and a
# green run, which is what makes the suite deletable.
COPY --chmod=0755 <<'PY' /usr/local/bin/qsharp-test
#!/usr/bin/env python3
import pathlib
import sys

import qdk
from qdk.test_utils import run_tests

context = qdk.Context(project_root=".")
for source in sorted(pathlib.Path("tests").rglob("*.qs")):
    context.eval(source.read_text(encoding="utf-8"))

try:
    run_tests(context=context, verbose=2)
except RuntimeError:
    sys.exit(1)
PY

# Loading the project compiles src/, and evaluating a test source type-checks
# it without running anything, so this is the compiler's own diagnostics over
# every file the suite will touch. A traceback would bury the diagnostic the
# compiler wrote, so only the message is printed.
COPY --chmod=0755 <<'PY' /usr/local/bin/qsharp-check
#!/usr/bin/env python3
import pathlib
import sys

import qdk

try:
    context = qdk.Context(project_root=".")
    for source in sorted(pathlib.Path("tests").rglob("*.qs")):
        context.eval(source.read_text(encoding="utf-8"))
except Exception as error:
    sys.exit(str(error))
PY

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home && chmod -R 777 /cache

WORKDIR /work
