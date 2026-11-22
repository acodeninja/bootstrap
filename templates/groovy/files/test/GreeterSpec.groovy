import spock.lang.Specification

class GreeterSpec extends Specification {
    def 'a greeting addresses the name it is given'() {
        given:
        def name = 'world'

        when:
        def greeting = Greeter.greet(name)

        then:
        greeting == 'Hello, world!'
    }
}
