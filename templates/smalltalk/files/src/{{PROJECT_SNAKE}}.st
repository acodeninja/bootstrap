"A comment is delimited by double quotes and a string by single ones, which is
the reverse of almost everywhere else. A stray double quote silently swallows
code until the next one, and this template treats any compiler complaint on
stderr as a test failure -- so an unbalanced comment fails the suite rather than
merely looking odd. To put a double quote inside a comment you double it."

"Declaring a class is sending a message. `subclass:` is a message to Object, and
the brackets hold the body -- so there is no class keyword, because there did not
need to be one. Everything inherits from Object."
Object subclass: Greeter [
    "A pragma rather than a comment: this is the class documentation, reachable
    at runtime by sending `comment` to the class. A plain double-quoted comment
    here would be thrown away."
    <comment: 'The one class this project starts with.'>

    "`Greeter class >> greet:` defines a method on the class itself rather than
    on its instances, so callers send the message to Greeter with nothing to
    create. Dropping the `Greeter class >>` would make it an instance method.

    The colon in `greet:` is part of the method name, and a method taking two
    arguments is named something like `greet:prefix:` -- so the name and the
    argument labels are the same thing."
    Greeter class >> greet: aName [
        "^ returns. Without it a method answers the receiver, which is a
        quiet wrong answer rather than an error.

        The comma is a binary message that concatenates -- `,` is a method on
        the collection, not syntax, which is true of `+` too. Nothing here is
        an operator in the sense other languages mean."
        ^ 'Hello, ', aName, '!'
    ]
]
