//> using scala 3.10.1
//> using options -Wunused:all -Werror
//> using test.dep org.scalameta::munit::1.3.6

// The standard library still reaches for sun.misc.Unsafe, which this JDK
// reports in four lines printed ahead of the test results.
//> using test.javaOpt --sun-misc-unsafe-memory-access=allow
