RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check formatting"
	@echo "make fmt     Reformat in place"
	@echo "make build   Compile the project"
	@echo "make shell   Open a shell in the container"

# Discovery is reflection over the built assembly, so no file is named. Exit
# code 8 is "ran zero tests", which is what makes the suite safe to delete; a
# failing test is exit 2 and still goes red.
test:
	$(RUN) dotnet test --results-directory /cache/test-results --ignore-exit-code 8

lint:
	$(RUN) dotnet format --verify-no-changes

fmt:
	$(RUN) dotnet format

build:
	$(RUN) dotnet build

shell:
	$(RUN) bash
