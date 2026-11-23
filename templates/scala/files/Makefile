RUN := docker compose run --rm dev

# Where .scala-build goes; without it scala-cli writes it beside the sources, in
# the bind mount. It has to follow the sub-command rather than precede it:
# anything before the sub-command is read as an input, so
# `scala-cli --workspace x test .` compiles a directory called test.
WORKSPACE := --workspace /cache/workspace

# scalafmt's configuration is looked up in the workspace rather than beside the
# sources, so moving the workspace off the bind mount would otherwise leave it
# falling back to scalafmt's own version, dialect and width.
SCALAFMT := $(WORKSPACE) --scalafmt-conf /work/.scalafmt.conf

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Compile both scopes with warnings fatal, and check formatting)
	$(info make fmt     Reformat in place)
	$(info make build   Compile the module into a library jar)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) scala-cli test $(WORKSPACE) .

# --server=false compiles in process instead of through the incremental build
# server, which recompiles only what changed -- and reports warnings only for
# what it recompiled, so an incremental lint can pass a file it never looked at.
# It is also the only form that fails on a warning: -Werror still produces class
# files, and the server's own exit code does not notice.
lint:
	$(RUN) scala-cli compile --test --server=false $(WORKSPACE) .
	$(RUN) scala-cli fmt --check $(SCALAFMT) .

fmt:
	$(RUN) scala-cli fmt $(SCALAFMT) .

build:
	$(RUN) scala-cli compile $(WORKSPACE) -d /cache/build/{{PROJECT_SLUG}}.jar .

shell:
	$(RUN) bash
