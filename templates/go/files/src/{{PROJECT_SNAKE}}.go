// The package name is the unit of visibility, and it is not the directory name:
// this directory is named after the project and the package is called greet.
// What makes Greet reachable from another package is the capital G -- an
// identifier starting with a lower-case letter is private to the package, and
// that is the whole of Go's access control.
package greet

import "fmt"

// Greet returns a greeting addressed to name.
//
// A doc comment starts with the identifier it documents, which is a convention
// `go doc` relies on rather than something the compiler checks. The type comes
// after the parameter name, and the return type after the parentheses --
// backwards from C and from Java, and the thing people get wrong on day one.
func Greet(name string) string {
	// Sprintf formats into a new string, where Printf would write it to stdout.
	// %s is the verb for a string; %v works for anything and is what you reach
	// for when you do not know.
	return fmt.Sprintf("Hello, %s!", name)
}
