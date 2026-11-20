# Run inside the container by the Makefile beside this file. It may use a real
# shell and globbing; the Makefile may not, because on Windows it runs under
# cmd.exe.

BUILD := /cache/build
CFLAGS := -std=c17 -Wall -Wextra -Werror -O1 -Isrc -Ivendor/unity

LIB_SOURCES := $(wildcard src/*.c)
TEST_SOURCES := $(wildcard test/*.c)
UNITY_SOURCES := $(wildcard vendor/unity/*.c)
OURS := $(wildcard src/*.c src/*.h test/*.c)

LIBRARY := $(BUILD)/lib{{PROJECT_SNAKE}}.a
RUNNER := $(BUILD)/test-runner

OBJECTS := $(patsubst %.c,$(BUILD)/%.o,$(LIB_SOURCES) $(TEST_SOURCES) $(UNITY_SOURCES))

.PHONY: test lint fmt build FORCE
.DEFAULT_GOAL := test

test: $(RUNNER)
	$(RUNNER)

build: $(LIBRARY)

lint:
	clang-format --dry-run --Werror $(OURS)

fmt:
	clang-format -i $(OURS)

$(LIBRARY): $(patsubst %.c,$(BUILD)/%.o,$(LIB_SOURCES))
	@mkdir -p $(@D)
	ar rcs $@ $^

$(RUNNER): $(BUILD)/main.o $(patsubst %.c,$(BUILD)/%.o,$(TEST_SOURCES) $(UNITY_SOURCES)) $(LIBRARY)
	gcc $(CFLAGS) -o $@ $^

# Rebuilt every run and kept only when it differs, so deleting a test file is
# noticed without recompiling the runner when nothing changed.
$(BUILD)/main.c: FORCE
	@mkdir -p $(@D)
	@unity-discover $(TEST_SOURCES) > $@.tmp
	@cmp -s $@.tmp $@ || cp $@.tmp $@
	@rm -f $@.tmp

FORCE:

$(BUILD)/main.o: $(BUILD)/main.c
	gcc $(CFLAGS) -c $< -o $@

$(BUILD)/%.o: %.c
	@mkdir -p $(@D)
	gcc $(CFLAGS) -MMD -MP -c $< -o $@

-include $(OBJECTS:.o=.d)
