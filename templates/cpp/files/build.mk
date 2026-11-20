# Run inside the container by the Makefile beside this file. It may use a real
# shell and globbing; the Makefile may not, because on Windows it runs under
# cmd.exe.

BUILD := /cache/build
CXXFLAGS := -std=c++23 -Wall -Wextra -Werror -O1 -Isrc -Ivendor/doctest

LIB_SOURCES := $(wildcard src/*.cpp)
TEST_SOURCES := $(wildcard test/*.cpp)
OURS := $(wildcard src/*.cpp src/*.hpp test/*.cpp)

LIBRARY := $(BUILD)/lib{{PROJECT_SNAKE}}.a
RUNNER := $(BUILD)/test-runner

LIB_OBJECTS := $(patsubst %.cpp,$(BUILD)/%.o,$(LIB_SOURCES))
TEST_OBJECTS := $(patsubst %.cpp,$(BUILD)/%.o,$(TEST_SOURCES))

.PHONY: test lint fmt build
.DEFAULT_GOAL := test

test: $(RUNNER)
	$(RUNNER)

build: $(LIBRARY)

lint:
	clang-format --dry-run --Werror $(OURS)

fmt:
	clang-format -i $(OURS)

$(LIBRARY): $(LIB_OBJECTS)
	@mkdir -p $(@D)
	ar rcs $@ $^

$(RUNNER): $(TEST_OBJECTS) $(LIBRARY)
	g++ $(CXXFLAGS) -o $@ $^

$(BUILD)/%.o: %.cpp
	@mkdir -p $(@D)
	g++ $(CXXFLAGS) -MMD -MP -c $< -o $@

-include $(LIB_OBJECTS:.o=.d) $(TEST_OBJECTS:.o=.d)
