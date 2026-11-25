// Spock is a dependency declared in build.gradle. This imports the name, not a
// file -- Greeter needs no import, because both files are in the same default
// package and the name is already in scope.
import spock.lang.Specification

// Nothing names this file. Gradle compiles everything under test/ and Spock
// finds each class extending Specification, so a spec is found by existing and
// deleting one is safe. Run the suite with `make test`.
class GreeterSpec extends Specification {
    // A method name in quotes, which Groovy allows and Java does not: the test
    // name is a real sentence rather than camel case, and it is what a failure
    // prints. `def` as the return type means it is not declared.
    def 'a greeting addresses the name it is given'() {
        // Spock replaces arrange, act, assert with labels that are part of the
        // language it builds on top of Groovy. given/when/then is the usual
        // trio; setup/expect/cleanup/where are the others.
        given:
        def name = 'world'

        when:
        def greeting = Greeter.greet(name)

        // No assertion method. Every expression in a `then:` block is an
        // assertion, and Spock rewrites it so a failure prints each
        // sub-expression and its value -- which is why there is no
        // assertEquals here to learn, and no expected-first order to remember.
        then:
        greeting == 'Hello, world!'
    }
}
