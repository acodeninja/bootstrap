import groovy.transform.Immutable
import spock.lang.Specification

class KitchenSinkSpec extends Specification {

    // collections

    def 'a list grows with the left shift operator and slices with ranges'() {
        given:
        def items = ['a', 'b']

        when:
        items << 'c'

        then:
        items == ['a', 'b', 'c']
        items[1..2] == ['b', 'c']
        items[-1] == 'c'
        'c' in items
    }

    def 'a map reads its keys as names and a key it does not have as null'() {
        given:
        def counts = [a: 2, b: 1]

        expect:
        counts.a == 2
        counts.z == null
        counts.get('z', 0) == 0
        counts.with { a + b } == 3
    }

    def 'a set discards duplicates'() {
        given:
        def letters = ['a', 'b', 'a']

        when:
        def unique = letters as Set

        then:
        unique.size() == 2
        'a' in unique
        !('z' in unique)
    }

    // strings

    def 'a string splits into parts and joins back up'() {
        when:
        def words = 'one two three'.tokenize(' ')

        then:
        words == ['one', 'two', 'three']
        words.join('-') == 'one-two-three'
    }

    def 'a slice of a string is a range of its characters'() {
        given:
        def text = 'abcdef'

        expect:
        text[0] == 'a'
        text[0..2] == 'abc'
        text[-2..-1] == 'ef'
    }

    def 'text is built up by interpolation and multiplication'() {
        given:
        def name = 'world'
        def count = 2

        expect:
        "$name x$count" == 'world x2'
        'ab' * 3 == 'ababab'
        '  padded  '.trim() == 'padded'
    }

    // types and branching

    @Immutable
    static class Point {
        int x
        int y

        Point plus(Point other) {
            new Point(x + other.x, y + other.y)
        }
    }

    def 'a value class can say what plus means for it'() {
        given:
        def start = new Point(x: 1, y: 2)

        when:
        def moved = start + new Point(x: 3, y: 4)

        then:
        moved == new Point(x: 4, y: 6)
        start == new Point(x: 1, y: 2)
    }

    enum State {
        LOCKED, OPEN
    }

    def 'a switch over an enum produces a value'() {
        // Nothing checks that every case is covered. Delete a branch and a
        // state that matches nothing throws at run time instead.
        given:
        def state = State.LOCKED

        when:
        def next = switch (state) {
            case State.LOCKED -> State.OPEN
            case State.OPEN -> State.LOCKED
        }

        then:
        next == State.OPEN
    }

    def 'a missing value falls through to the elvis operator'() {
        given:
        def record = [name: null]

        expect:
        (record.name ?: 'unknown') == 'unknown'
        record.name?.size() == null
    }

    // iteration

    def 'a loop can read both the position and the item'() {
        given:
        def seen = []

        when:
        ['a', 'b'].eachWithIndex { item, index -> seen << "$index:$item" }

        then:
        seen == ['0:a', '1:b']
    }

    def 'a sequence can be walked two items at a time'() {
        given:
        def values = [1, 2, 3, 4]

        when:
        def sums = values.collate(2, 1, false).collect { it.sum() }

        then:
        sums == [3, 5, 7]
    }

    // functions

    def 'a closure is a value you can name and hand to a collection'() {
        given:
        def twice = { n -> n * 2 }

        expect:
        [1, 2, 3].collect(twice) == [2, 4, 6]
        [1, 2, 3].findAll { it > 1 } == [2, 3]
        ['a', 'bb']*.size() == [1, 2]
    }

    def 'a list folds down to a single value'() {
        given:
        def values = [1, 2, 3, 4]

        expect:
        values.inject(0) { sum, n -> sum + n } == 10
    }

    // errors

    def 'an invalid input is refused rather than guessed at'() {
        when:
        parsePercentage('half')

        then:
        def refusal = thrown(IllegalArgumentException)
        refusal.message == 'not a percentage: half'
    }

    // gotchas

    def 'an empty string is false, so a truth check is not a null check'() {
        // if (name) reads like a null check and turns away the empty string
        // too. != null is the spelling that asks only the question you meant.
        given:
        def name = ''

        expect:
        !name
        name != null
    }

    private static int parsePercentage(String input) {
        if (!input.isInteger()) {
            throw new IllegalArgumentException("not a percentage: $input")
        }
        input.toInteger()
    }
}
