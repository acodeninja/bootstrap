// Greeter is package-private -- there is no `public` on it -- and that is deliberate.
// Java requires a public class to match its filename, and this file is named after the
// project rather than after the class. A non-public class carries no such rule, so one
// file may hold a class with any name at all.
class Greeter {
  // Every method in Java lives on a class; there are no free functions. `static` says
  // this one belongs to the class rather than to an instance, so callers write
  // Greeter.greet(name) and never new Greeter().
  //
  // Nothing marks it visible outside this package either, which is the same default the
  // class has. Add `public` when something outside the package needs to call it.
  //
  // The return type comes before the name, and the parameter's type before its name. The
  // compiler checks both, so a caller passing an int here does not build.
  static String greet(String name) {
    return "Hello, " + name + "!";
  }
}
