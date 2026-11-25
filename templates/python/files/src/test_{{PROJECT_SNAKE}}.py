# pytest discovers by name, and nothing anywhere lists this file: it collects
# files matching test_*.py and, inside them, functions matching test_*. That is
# why `make test` names no path at all, and why writing a new test file is
# enough to have it run.
#
# This one sits in src/ rather than tests/ because src is on the import path and
# because the kitchen sink is meant to be deleted -- deleting it has to leave a
# project with a test still in it, and this is that test.
from {{PROJECT_SNAKE}} import greet


# The function name is the test name. pytest prints it on failure with nothing
# around it, so it is written as a sentence with underscores standing in for the
# spaces, rather than as test_greet_2.
def test_a_greeting_addresses_the_name_it_is_given():
    # Arrange, act, assert, separated by blank lines. Every test in this project
    # has those three parts in that order.
    name = "world"

    greeting = greet(name)

    # A bare `assert`, not a method on a framework object. pytest rewrites the
    # expression before running it, so a failure still shows both sides and the
    # difference between them -- which is the reason there is no assert_equal
    # here to learn.
    assert greeting == "Hello, world!"
