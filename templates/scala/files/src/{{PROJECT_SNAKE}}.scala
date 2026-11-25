// `object` declares a singleton: the type and its one instance at once, which is
// how Scala spells a module of functions. A `class` would need constructing.
//
// The colon after the name, and no braces: this is Scala 3 indentation syntax,
// where layout delimits a block the way it does in Python. The braced form is
// still legal and this project uses the newer one throughout.
object Greeter:
  // `def` declares a method. The parameter type comes after its name and the
  // return type after the parentheses, both after a colon, and nothing marks
  // this exported -- the default visibility is public.
  //
  // The return type could be inferred and is written out anyway, which is the
  // convention for anything public: it stops a change to the body quietly
  // changing the signature.
  //
  // s"..." is an interpolated string and the s is what makes it one. $name
  // interpolates a variable, ${...} a whole expression, and f"..." and raw"..."
  // are two more interpolators -- the prefix picks which.
  def greet(name: String): String = s"Hello, $name!"
