// `pub` is what makes this reachable from outside the module; without it the
// function is private to this file, and that is the whole of Rust's visibility
// apart from the narrower `pub(crate)`.
//
// The two string types are the thing to notice. `&str` is a borrowed view of
// text somebody else owns, and `String` is text this function owns and hands
// over -- so the signature says "lend me a name and I will give you a greeting
// of your own to keep". Taking `String` here would mean taking the caller's
// value away from them, which is a decision the compiler makes you make.
pub fn greet(name: &str) -> String {
    // format! builds a String. The braces interpolate the variable of that
    // name, and the `!` says this is a macro rather than a function -- which is
    // why the format string has to be a literal and cannot be a variable.
    format!("Hello, {name}!")
}

// The test lives in the same file, inside a module that only exists when
// compiling tests -- that is what #[cfg(test)] means, so none of this is in the
// shipped binary. Rust puts unit tests beside the code on purpose: a test here
// can reach private items, where a file under tests/ is a separate crate and
// sees only the public interface.
#[cfg(test)]
mod tests {
    // The test module is a child module, so it does not inherit the names
    // around it. `use super::*` brings in everything from the parent, which is
    // the line that makes `greet` visible below.
    use super::*;

    // #[test] is the whole registration. `cargo test` compiles this crate,
    // collects every function marked that way and runs it -- so nothing names
    // this test and deleting one is safe.
    //
    // The function name is the test name, because Rust identifiers cannot
    // contain spaces and there is no attribute to carry a sentence. It is what
    // a failure prints, so it is written to read as one anyway.
    #[test]
    fn a_greeting_addresses_the_name_it_is_given() {
        // Arrange, act, assert, separated by blank lines. Every test in this
        // project has those three parts in that order.
        let name = "world";

        let greeting = greet(name);

        // assert_eq! prints both sides on failure, which a bare assert! with
        // `==` would not. There is no expected-first convention to remember
        // because the message names left and right rather than guessing.
        assert_eq!(greeting, "Hello, world!");
    }
}
