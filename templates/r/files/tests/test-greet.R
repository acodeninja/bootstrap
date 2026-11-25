# Nothing names this file, and nothing imports anything either. The runner
# sources every file under src and then runs each tests/test-*.R through
# testthat, so a test file is found by that filename prefix and deleting one is
# safe. Run the suite with make test.  test_that takes a description and a
# block of expectations. The description is a plain string and can be a real
# sentence, which is what it should be: it is what a failure prints.
test_that("a greeting addresses the name it is given", {
  # expect_equal takes the actual value first and the expected second. It
  # compares with a tolerance for numbers, which is usually what you want and
  # occasionally is not -- expect_identical is the strict one.  A failure
  # raises, and testthat catches it and carries on with the next expectation,
  # so one block may report several problems at once.
  expect_equal(greet("world"), "Hello, world!")
})
