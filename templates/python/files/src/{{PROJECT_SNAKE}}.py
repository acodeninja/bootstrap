# `def` is the whole of declaring a function, and nothing here exports it: every
# name defined at module level is importable, which is how the test beside this
# file reaches `greet`. A leading underscore is the only way to say "private",
# and it is a convention rather than a rule the language enforces.
#
# The annotations say this takes a str and returns a str. Nothing checks them
# while the program runs -- hand it an int and it will format that quite
# happily -- but ruff reads them, editors read them, and a type checker would
# refuse the call. They are documentation the tooling can act on.
def greet(name: str) -> str:
    # An f-string interpolates whatever expression sits inside the braces. The
    # `f` prefix is what makes it one; without it this returns the eleven
    # characters "Hello, {name}!" and no test would catch the difference until
    # it read the message.
    return f"Hello, {name}!"
