// `object` declares a singleton: the type and its one instance at once, which is
// how Kotlin spells a module of functions. A `class` would need constructing.
//
// The name is Greeter and the file is named after the project, which Kotlin
// allows -- unlike Java, a file may hold a declaration of any name. ktlint's
// filename rule disagrees and is the one rule this project turns off.
object Greeter {
    // `fun` declares a function. The parameter type comes after the name and
    // the return type after the parentheses, both separated by a colon, and
    // nothing marks this exported: the default visibility is public.
    //
    // `=` instead of a braced body makes this an expression function, so there
    // is no `return`. The return type could be inferred and is written out
    // anyway, which is the convention for anything public.
    //
    // "$name" interpolates a variable and "${...}" a whole expression. There is
    // no prefix to remember: every string literal interpolates, so a literal
    // dollar sign has to be escaped rather than the other way round.
    fun greet(name: String): String = "Hello, $name!"
}
