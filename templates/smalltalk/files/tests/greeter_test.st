"Nothing names this file. `make test` loads every tests/*.st and asks SUnit to
run each TestCase subclass it can find, so a test is found by subclassing and
deleting one is safe. Run the suite with `make test`.

SUnit is where every runner in this repo descends from -- it is the original,
and the discovery rule below is the one everybody copied."
TestCase subclass: GreeterTest [

    "A method whose name begins with `test` is a test, and that is the whole
    registration. The name is the method selector, so it cannot contain spaces
    and is camel case; it is what a failure prints."
    testAGreetingAddressesTheNameItIsGiven [
        "Temporaries are declared between vertical bars, all of them at the top
        of the method -- there is no declaring one where it is first used."
        | name greeting |
        "Arrange, act, assert. := assigns and = compares, and a statement ends
        with a full stop rather than a semicolon -- a semicolon is a cascade,
        which sends another message to the same receiver."
        name := 'world'.

        greeting := Greeter greet: name.

        "`assert:` takes a boolean, so the comparison is yours to write -- which
        is why there is no expected-first order to remember and also why a
        failure can only say that something was false. `assert:equals:` is the
        one that prints both sides, and is worth reaching for when a value is
        worth seeing.

        = on two strings compares their characters. == would compare identity
        and fail for two strings that merely match, which is the trap here."
        self assert: greeting = 'Hello, world!'
    ]
]
