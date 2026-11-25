// No imports. Both files are in the root namespace, so `greet` is already in
// scope, and Assert is in the standard library.
//
// Nothing names this file. `flix test` compiles the project and runs every
// definition marked @Test, so a test is found by the annotation and deleting one
// is safe. Run the suite with `make test`.
@Test
// The return type is `Unit \ Assert`, and that effect annotation is the thing to
// take away: asserting is an effect in Flix, like printing or reading a
// reference, so a function that asserts says so in its type. Leave the `\ Assert`
// off and this does not compile -- which means the effect system knows which of
// your functions are pure, and it is not a comment you can forget to update.
//
// The name is an identifier rather than a string, so it is snake case and reads
// as closely to a sentence as it can. It is what a failure prints.
def a_greeting_addresses_the_name_it_is_given(): Unit \ Assert =
    // Arrange, act, assert, separated by blank lines. `let` binds and the
    // semicolon separates it from what follows -- these are expressions being
    // sequenced rather than statements.
    let name = "world";

    let greeting = greet(name);

    // The expected value is passed by name, which is Flix making the order
    // unmistakable rather than asking you to remember it. There is no way to
    // get this round the wrong way without the compiler saying so.
    Assert.assertEq(expected = "Hello, world!", greeting)
