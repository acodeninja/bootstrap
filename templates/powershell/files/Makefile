RUN := docker compose run --rm dev

.DEFAULT_GOAL := help
.PHONY: help test lint fmt build shell

# $(info) is make's own, so the text and its columns survive cmd.exe, which
# prints the quotes echo needs; @cd . stops "Nothing to be done for 'help'".
help:
	$(info make test    Run the test suite)
	$(info make lint    Check lint rules and formatting)
	$(info make fmt     Reformat in place)
	$(info make build   Nothing to build: PowerShell runs from source)
	$(info make shell   Open a shell in the container)
	@cd .

test:
	$(RUN) pwsh-test

lint:
	$(RUN) pwsh -NoLogo -NoProfile -Command "Invoke-ScriptAnalyzer -Path . -Recurse -Settings ./PSScriptAnalyzerSettings.psd1 -EnableExit"

fmt:
	$(RUN) pwsh-fmt

build:
	@echo "nothing to build: PowerShell runs from source"

shell:
	$(RUN) bash
