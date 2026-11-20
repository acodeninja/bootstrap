# Fifteen passing assertions: the toolbox for solving a kata in R.

# collections

test_that("a vector keeps what you put in it, in order", {
  items <- c("a", "b")

  items <- c(items, "c")

  expect_equal(length(items), 3)
  expect_equal(items[2], "b")
  expect_equal(items[2:3], c("b", "c"))
})

# A list with names is the map. A name it does not hold answers NULL from [[,
# and a one-element list from [ -- which is the difference between the two.
test_that("a name a list does not hold comes back NULL", {
  counts <- list(a = 2, b = 1)

  expect_equal(counts[["a"]], 2)
  expect_null(counts[["z"]])
  expect_equal(length(counts["z"]), 1)
})

test_that("unique discards duplicates and %in% asks about membership", {
  letters_seen <- c("a", "b", "a")

  expect_equal(length(unique(letters_seen)), 2)
  expect_true("b" %in% letters_seen)
  expect_false("z" %in% letters_seen)
})

# strings

# strsplit works on a vector of strings, so it answers with a list of vectors
# even when you handed it one string. [[1]] is how you get the parts.
test_that("strsplit answers with a list, one element per input", {
  parts <- strsplit("one two three", " ")

  expect_true(is.list(parts))
  expect_equal(parts[[1]], c("one", "two", "three"))
  expect_equal(paste(parts[[1]], collapse = "-"), "one-two-three")
})

test_that("substr takes a first and a last position, counting from one", {
  text <- "abcdef"

  expect_equal(substr(text, 1, 1), "a")
  expect_equal(substr(text, 1, 3), "abc")
  expect_equal(substr(text, nchar(text) - 1, nchar(text)), "ef")
})

test_that("text is built up by paste0, strrep and sprintf", {
  expect_equal(paste0("one", "-", "two"), "one-two")
  expect_equal(strrep("ab", 3), "ababab")
  expect_equal(sprintf("%s x%d", "world", 2), "world x2")
  expect_equal(trimws("  padded  "), "padded")
})

# types and branching

# Assignment copies, so a function cannot change its caller's data. R only
# copies when something is written to, but the effect is a copy either way.
test_that("assigning a list copies it rather than sharing it", {
  point <- list(x = 1, y = 2)

  moved <- point
  moved$x <- 5

  expect_equal(moved$x, 5)
  expect_equal(point$x, 1)
})

test_that("a factor is a fixed set of states and knows them all", {
  state <- factor("unlocked", levels = c("locked", "unlocked"))

  expect_equal(as.character(state), "unlocked")
  expect_equal(levels(state), c("locked", "unlocked"))
  expect_equal(as.integer(state), 2)
})

# if is an expression, so a branch produces a value without anything being
# assigned inside it. switch does the same for a fixed set of names.
test_that("a branch produces a value rather than assigning one", {
  state <- "unlocked"

  outcome <- if (state == "locked") {
    "shut"
  } else {
    "open"
  }
  described <- switch(state, locked = "shut", unlocked = "open")
  fallback <- switch("melted", locked = "shut", "anything else")

  expect_equal(outcome, "open")
  expect_equal(described, "open")
  expect_equal(fallback, "anything else")
})

# iteration

test_that("seq_along counts the positions of a vector", {
  values <- c(1, 2, 3, 4)

  weighted <- 0
  for (at in seq_along(values)) {
    weighted <- weighted + at * values[at]
  }

  expect_equal(weighted, 30)
  expect_equal(seq_along(values), 1:4)
})

test_that("diff walks a sequence two items at a time for you", {
  values <- c(1, 2, 4, 8)

  expect_equal(diff(values), c(1, 2, 4))
  expect_equal(max(diff(values)), 4)
})

# functions

test_that("a function is a value, so it can be handed to another function", {
  doubled <- function(value) value * 2

  mapped <- vapply(c(1, 2, 3), doubled, numeric(1))

  expect_equal(mapped, c(2, 4, 6))
  expect_equal(doubled(4), 8)
})

test_that("Reduce folds a vector down to one value", {
  values <- c(1, 2, 3, 4)

  expect_equal(Reduce(`+`, values), 10)
  expect_equal(sum(values), 10)
  expect_equal(Reduce(function(a, b) a * b, values), 24)
})

# errors

# stop raises a condition, which is R's exception. The message is matched
# rather than a type, because the condition classes are yours to invent.
test_that("an invalid input is refused by stop", {
  parse_positive <- function(text) {
    if (!grepl("^[0-9]+$", text)) {
      stop("not a number: ", text)
    }
    as.integer(text)
  }

  expect_equal(parse_positive("42"), 42)
  expect_error(parse_positive("nope"), "not a number")
})

# gotchas

# The hour this saves: arithmetic on two vectors of different lengths does not
# fail. The shorter one starts again from the beginning, as many times as it
# takes, and only warns when the lengths are not multiples.
test_that("a shorter vector is recycled to meet a longer one", {
  expect_equal(c(1, 2, 3, 4) + c(10, 20), c(11, 22, 13, 24))
  expect_equal(c(1, 2, 3, 4) * 2, c(2, 4, 6, 8))
  expect_warning(c(1, 2, 3) + c(10, 20), "multiple")
})
