// A package declaration, and it has to match the directory: this file is at
// src/<project>/Greeting.hx, so the package is the project and the class is
// Greeting. Unlike Java the filename need not match the class, but the
// directory and the package do.
package {{PROJECT_SNAKE}};

class Greeting {
	// `public` is what makes this reachable from another package; the default
	// without it is private to the class. `static` means it belongs to the
	// class rather than an instance, so callers write Greeting.greet(name).
	//
	// The parameter type comes after a colon and the return type after the
	// parentheses, also after a colon. Both are checked: Haxe compiles to
	// several other languages and the type system is the part that does not
	// vary between them.
	public static function greet(name:String):String {
		// Single quotes interpolate and double quotes do not, which is the
		// opposite way round from PHP and Ruby. $name interpolates a variable
		// and ${...} a whole expression -- and a literal dollar sign in an
		// interpolating string has to be written twice.
		return 'Hello, $name!';
	}
}
