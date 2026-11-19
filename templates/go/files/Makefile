RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

help:
	@echo "make test    Run the test suite"
	@echo "make lint    Check vet rules and formatting"
	@echo "make fmt     Reformat in place"
	@echo "make build   Compile every package"
	@echo "make shell   Open a shell in the container"

test:
	$(RUN) go test ./...

lint:
	$(RUN) go vet ./...
	$(RUN) gofmt-check

fmt:
	$(RUN) gofmt -w .

build:
	$(RUN) go build ./...

shell:
	$(RUN) bash
