// A class named Greeter in a file named after the project, which Groovy allows
// where Java does not: a public class need not match its filename here.
//
// Nothing marks anything exported. Groovy's default is public for classes,
// methods and fields alike, so `public` is a keyword you almost never type.
class Greeter {
    // `static` means the method belongs to the class rather than an instance,
    // so callers write Greeter.greet(name). The return type is declared here
    // and could have been `def`, which defers the check to run time -- Groovy
    // is optionally typed, and a declared type is checked where `def` is not.
    static String greet(String name) {
        // No `return`. The last expression in a method is its value, the same
        // as Ruby, and an explicit `return` is legal and less usual.
        //
        // "${name}" interpolates and only double quotes do it: single quotes
        // make a plain java.lang.String where double quotes make a GString,
        // and the two are different types with the same printed form.
        "Hello, ${name}!"
    }
}
