import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertFalse
import kotlin.test.assertIs
import kotlin.test.assertNull
import kotlin.test.assertTrue

class KitchenSinkTest {
    // collections

    @Test
    fun `a list keeps what you put in it, in order`() {
        val items = mutableListOf("a", "b")

        items.add("c")

        assertEquals(listOf("a", "b", "c"), items)
        assertEquals(3, items.size)
        assertEquals(listOf("b", "c"), items.subList(1, 3))
    }

    @Test
    fun `a lookup for a key that is not there comes back null`() {
        val counts = mapOf("a" to 2, "b" to 1)

        assertEquals(2, counts["a"])
        assertNull(counts["z"])
        assertEquals(0, counts.getOrDefault("z", 0))
    }

    @Test
    fun `a set discards duplicates`() {
        val letters = setOf("a", "b", "a")

        assertEquals(2, letters.size)
        assertTrue("a" in letters)
        assertFalse("z" in letters)
    }

    // strings

    @Test
    fun `a string splits into parts and joins back up`() {
        val words = "one two three".split(" ")

        assertEquals(listOf("one", "two", "three"), words)
        assertEquals("one-two-three", words.joinToString("-"))
    }

    @Test
    fun `a slice of a string counts from zero`() {
        val text = "abcdef"

        assertEquals('a', text[0])
        assertEquals("abc", text.substring(0, 3))
        assertEquals("ef", text.takeLast(2))
    }

    @Test
    fun `text can be built up by interpolation`() {
        val name = "world"
        val count = 2

        assertEquals("world x2", "$name x$count")
        assertEquals("ababab", "ab".repeat(3))
        assertEquals("padded", "  padded  ".trim())
    }

    // types and branching

    data class Point(
        val x: Int,
        val y: Int,
    )

    @Test
    fun `a data class copies itself with one field changed`() {
        val record = Point(x = 1, y = 2)

        val moved = record.copy(x = 5)

        assertEquals(Point(5, 2), moved)
        assertEquals(Point(1, 2), record)
    }

    enum class State { LOCKED, OPEN }

    @Test
    fun `a when over an enum has to cover every case`() {
        // Leave a branch out and this stops compiling, because the result is
        // assigned. A when used as a statement is not checked that way.
        val state = State.LOCKED

        val next =
            when (state) {
                State.LOCKED -> State.OPEN
                State.OPEN -> State.LOCKED
            }

        assertEquals(State.OPEN, next)
    }

    @Test
    fun `a branch produces a value instead of setting one`() {
        fun label(n: Int) =
            when {
                n < 0 -> "negative"
                n == 0 -> "zero"
                else -> "positive"
            }

        assertEquals("negative", label(-1))
        assertEquals("zero", label(0))
        assertEquals("positive", label(1))
    }

    // iteration

    @Test
    fun `a loop can read both the position and the item`() {
        val seen = mutableListOf<String>()

        for ((index, item) in listOf("a", "b").withIndex()) {
            seen.add("$index:$item")
        }

        assertEquals(listOf("0:a", "1:b"), seen)
    }

    @Test
    fun `a sequence can be walked two items at a time`() {
        val values = listOf(1, 2, 3, 4)

        val sums = values.zipWithNext { left, right -> left + right }

        assertEquals(listOf(3, 5, 7), sums)
    }

    // functions

    @Test
    fun `a function can be handed to another function`() {
        fun double(n: Int) = n * 2

        val doubled = listOf(1, 2, 3).map(::double)
        val big = listOf(1, 2, 3).filter { it > 1 }

        assertEquals(listOf(2, 4, 6), doubled)
        assertEquals(listOf(2, 3), big)
    }

    @Test
    fun `a list can be folded down to a single value`() {
        val values = listOf(1, 2, 3, 4)

        val total = values.fold(0) { sum, n -> sum + n }

        assertEquals(10, total)
    }

    // errors

    sealed class PercentageError(
        message: String,
    ) : Exception(message) {
        class NotANumber(
            input: String,
        ) : PercentageError("not a percentage: $input")

        class OutOfRange(
            value: Int,
        ) : PercentageError("not a percentage: $value")
    }

    @Test
    fun `an invalid input is refused rather than guessed at`() {
        fun parsePercentage(input: String): Result<Int> {
            val value = input.toIntOrNull() ?: return Result.failure(PercentageError.NotANumber(input))
            if (value !in 0..100) return Result.failure(PercentageError.OutOfRange(value))
            return Result.success(value)
        }

        assertEquals(40, parsePercentage("40").getOrThrow())
        assertIs<PercentageError.NotANumber>(parsePercentage("half").exceptionOrNull())
        assertFailsWith<PercentageError.OutOfRange> { parsePercentage("140").getOrThrow() }
    }

    // gotchas

    data class Tagged(
        val id: Int,
    ) {
        var note: String = ""
    }

    @Test
    fun `a data class leaves a property declared in its body out of copy and equals`() {
        // equals, hashCode, toString and copy are generated from the primary
        // constructor alone. Move note into it and both assertions flip.
        val record = Tagged(1).apply { note = "kept" }

        val copied = record.copy()

        assertEquals(record, copied)
        assertEquals("", copied.note)
    }
}
